
.section .text
.global crypto_chacha20

crypto_chacha20:
	addi sp, sp, -48
	sd ra, 40(sp)
	sd s4, 32(sp)
	sd s3, 24(sp)
	sd s2, 16(sp)
	sd s1, 8(sp)
	sd s0, 0(sp)

	addi s0, a0, 0
	addi s1, a1, 0
	addi s2, a2, 0
	addi s3, a3, 0
	addi s4, a4, 0



	ld s0, 0(sp)
	ld s1, 8(sp)
	ld s2, 16(sp)
	ld s3, 24(sp)
	ld s4, 32(sp)
	ld ra, 40(sp)
	addi sp, sp, 40
	ret

.chacha20_block:
	

.chacha20_rotate:
	addi t0, x0, 32
	sub t0, t0, a1
	srl t1, a0, t0
	sll a0, a0, a1
	or a0, a0, t1
	ret

.chacha20_load_littleendian:
	addi t0, x0, 0
	lb t0, 0(a0)
	addi t1, x0, 0
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
