
.macro quarter_round ia ib ic id
	lw t3, \ia(sp)
	lw t4, \ib(sp)
	lw t5, \ic(sp)
	lw t6, \id(sp)

	add t3, t3, t4
	xor a0, t6 ,t3
	addi a1, zero, 16
	call .chacha20_rotate
	addi t6, a0, 0

	add t5, t5, t6
	xor a0, t4, t5
	addi a1, zero, 12
	call .chacha20_rotate
	addi t4, a0, 0

	add t3, t3, t4
	xor a0, t6 ,t3
	addi a1, zero, 8
	call .chacha20_rotate
	addi t6, a0, 0

	add t5, t5, t6
	xor a0, t4, t5
	addi a1, zero, 7
	call .chacha20_rotate
	addi t4, a0, 0

	sw t3, \ia(sp)
	sw t4, \ib(sp)
	sw t5, \ic(sp)
	sw t6, \id(sp)
.endm

.macro load_littleendian reg i0 i1
	addi a0, \reg, \i0
	call .chacha20_load_littleendian
	sw a0, \i1(sp)
	sw a0, \i1(s4)
.endm

.macro store_littleendian i
	lw t3, \i(sp)
	lw t4, \i(s4)
	add a1, t3, t4
	addi a0, s0, \i
	call .chacha20_store_littleendian
.endm

.section .text
.global crypto_chacha20

crypto_chacha20:
	addi sp, sp, -144
	sd ra, 136(sp)
	sd s6, 128(sp)
	sd s5, 120(sp)
	sd s4, 112(sp)
	sd s3, 104(sp)
	sd s2, 96(sp)
	sd s1, 88(sp)
	sd s0, 80(sp)

	addi s0, a0, 0
	addi s1, a1, 0
	addi s2, a2, 0
	addi s3, a3, 0
	addi s4, a4, 0

	sd zero, 64(sp)
	addi s5, sp, 72
	addi s6, zero, 8
1:
	beq s6, zero, 2f
	lb t0, (s4)
	sb t0, (s5)
	addi s6, s6, -1
	addi s4, s4, 1
	addi s5, s5, 1
	j 1b
2:
	addi s5, s2, 0
3:
	addi a0, sp, 0
	addi a1, sp, 64
	addi a2, s3, 0
	la a3, .chacha_constant
	call .chacha20_block

	addi a0, sp, 0
	addi s6, zero, 64
4:
	beq s5, zero, 6f
	beq s6, zero, 5f

	addi t0, zero, 0
	addi t1, zero, 0
	lb t0, (s1)
	lb t1, (a0)
	xor t0, t0, t1
	sb t0, (s0)

	addi s5, s5, -1
	addi s6, s6, -1
	addi s0, s0, 1
	addi a0, a0, 1
	addi s1, s1, 1
	j 4b
5:
	ld t0, 64(sp)
	addi t0, t0, 1
	sd t0, 64(sp)
	j 3b
6:

	ld s0, 80(sp)
	ld s1, 88(sp)
	ld s2, 96(sp)
	ld s3, 104(sp)
	ld s4, 112(sp)
	ld s5, 120(sp)
	ld s6, 128(sp)
	ld ra, 136(sp)
	addi sp, sp, 144
	ret

.chacha20_block:
	addi sp, sp, -184
	sd ra, 176(sp)
	sd s5, 168(sp)
	sd s4, 160(sp)
	sd s3, 152(sp)
	sd s2, 144(sp)
	sd s1, 136(sp)
	sd s0, 128(sp)
	
	addi s0, a0, 0
	addi s1, a1, 0
	addi s2, a2, 0
	addi s3, s3, 0

	addi s4, sp, 64
	
// Load the constant
	load_littleendian s3, 0, 0
	load_littleendian s3, 4, 4
	load_littleendian s3, 8, 8
	load_littleendian s3, 12, 12
// Load the key
	load_littleendian s2, 0, 16
	load_littleendian s2, 4, 20
	load_littleendian s2, 8, 24
	load_littleendian s2, 12, 28
	load_littleendian s2, 16, 32
	load_littleendian s2, 20, 36
	load_littleendian s2, 24, 40
	load_littleendian s2, 28, 44
// Load the counter and nonce
	load_littleendian s1, 0, 48
	load_littleendian s1, 4, 52
	load_littleendian s1, 8, 56
	load_littleendian s1, 12, 60

	addi s5, zero, 20
1:
	beq s5, zero, 2f

	quarter_round  0, 4, 8, 12
	quarter_round  1, 5, 9, 13
	quarter_round  2, 6, 10, 14
	quarter_round  3, 7, 11, 15

	quarter_round  0, 5, 10, 15
	quarter_round  1, 6, 11, 12
	quarter_round  2, 7, 8, 14
	quarter_round  3, 4, 9, 13

	addi s5, s5, -2
	j 1b
2:
	
	store_littleendian 0
	store_littleendian 4
	store_littleendian 8
	store_littleendian 12
	store_littleendian 16
	store_littleendian 20
	store_littleendian 24
	store_littleendian 28
	store_littleendian 32
	store_littleendian 36
	store_littleendian 40
	store_littleendian 44
	store_littleendian 48
	store_littleendian 52
	store_littleendian 56
	store_littleendian 60

	ld s0, 128(sp)
	ld s1, 136(sp)
	ld s2, 144(sp)
	ld s3, 152(sp)
	ld s4, 160(sp)
	ld s5, 168(sp)
	ld ra, 176(sp)
	addi sp, sp, 184

.chacha20_rotate:
	addi t0, zero, 32
	sub t0, t0, a1
	srl t1, a0, t0
	sll a0, a0, a1
	or a0, a0, t1
	ret

.chacha20_load_littleendian:
	addi t0, zero, 0
	lb t0, 0(a0)
	addi t1, zero, 0
	lb t1, 1(a0)
	slli t2, t1, 8
	or t0, t0, t2
	lb t1, 2(a0)
	slli t2, t1, 16
	or t0, t0, t2
	lb t1, 3(a0)
	slli t2, t1, 24
	or a0, t0, t2
	ret

.chacha20_store_littleendian:
	sb a1, 0(a0)
	srli a1, a1, 8
	sb a1, 1(a0)
	srli a1, a1, 8
	sb a1, 2(a0)
	srli a1, a1, 8
	sb a1, 3(a0)
	ret

.chacha_constant:
.string "expand 32-byte k"

