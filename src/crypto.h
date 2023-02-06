
#ifndef CRYPTO_H
#define CRYPTO_H

#define CRYPTO_KEYSIZE 32
#define CRYPTO_NONCESIZE 8

int crypto_chacha20(uint8_t *out, uint8_t *in, uint64_t size, uint8_t *key, uint8_t *nonce);

#endif // CRYPTO_H
