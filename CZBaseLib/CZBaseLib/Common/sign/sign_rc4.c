#include "rc4.h"

// ��ʼ������
void rc4_init_GL_WLDH(unsigned char* sbox, unsigned char* key, unsigned long len)
{
	unsigned char tmp = 0;
    int  i = 0;
    int  j = 0;
    char k[256] = {0};
    
	if(sbox==0x00 ||key==0x00) //liao add
		return;

    for(i = 0; i < 256; i++)
    {
        sbox[i] = i;
        k[i] = key[i % len];
    }

    for(i = 0; i < 256; i++)
    {
        j = (j + sbox[i] + k[i]) % 256;
        tmp  = sbox[i];
        sbox[i] = sbox[j]; //����s[i]��s[j]
        sbox[j] = tmp;
    }
}

// ����/����
void rc4_crypt_GL_WLDH(unsigned char* sbox, unsigned char* data, unsigned long len)
{
    unsigned long i = 0;
    unsigned long j = 0;
    unsigned long k = 0;
    unsigned char tmp;
    int t = 0;    
	if(sbox==0x00 ||data==0x00) //liao add
		return;

    for(k = 0; k < len; k++)
    {
        i = (i + 1) % 256;
        j = (j + sbox[i]) % 256;
        tmp = sbox[i];
        sbox[i] = sbox[j]; // ����s[x]��s[y]
        sbox[j] = tmp;
        t = (sbox[i] + sbox[j]) % 256;
        data[k] ^= sbox[t];
    }
}

/* ================================================== *
    RC4����/����
    data[dataLen] [in/out] ����/���ܵ�����
    key[keyLen]   [in]     ��Կ
 * ================================================== */
void RC4_GL_WLDH(unsigned char* data, unsigned long dataLen, unsigned char* key, unsigned long keyLen)
{
    unsigned char sbox[256] = {0};
	
	if(key==0x00 ||data==0x00) //liao add
		return;

    rc4_init_GL_WLDH(sbox, key, keyLen);
    rc4_crypt_GL_WLDH(sbox, data, dataLen);
}