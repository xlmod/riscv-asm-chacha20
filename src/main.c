
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/random.h>

#include <getoption/getoption.h>

#include <crypto.h>

void print_hex(char *name, uint8_t *h, uint64_t len) {
#define RLSIZE 16
	printf("%s:\n", name);
	for (uint64_t i = 0; i < len; i++) {
		if (i % RLSIZE == 0) printf("  ");
		else printf(":");
		printf("%02X", h[i]);
		if ((i + 1) % RLSIZE == 0 || (i + 1) == len)
			printf("\n");
	}
}

int main(int argc, char **argv) {
	int ret;
	for (;;) {
		int c = getoption(argc, argv, "e");
		if (c < 0)
			break;
		switch (c) {
			default:
				return 1;
		}
	}
	if (optionind == argc)
		return 1;
	uint8_t key[CRYPTO_KEYSIZE];
	uint8_t nonce[CRYPTO_NONCESIZE];
	uint8_t *in = (uint8_t *)argv[optionind];
	uint64_t len = strlen((char *)in);
	uint8_t *out = calloc(len, 1);
	
	// Random
	getrandom(key, CRYPTO_KEYSIZE, 0);
	getrandom(nonce, CRYPTO_NONCESIZE, 0);

	print_hex("key", key, CRYPTO_KEYSIZE);
	print_hex("nonce", nonce, CRYPTO_NONCESIZE);
	print_hex("input", in, len);

	crypto_chacha20(out, in, len, key, nonce);

	print_hex("encrypted", out, len);

	crypto_chacha20(out, out, len, key, nonce);

	print_hex("decrypted", out, len);

	return 0;
}
