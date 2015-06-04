//md5.h
#ifndef MD5_GL_WLDH_H
#define MD5_GL_WLDH_H

#ifdef __alpha
typedef unsigned int uint32;
#else
typedef unsigned int uint32;
#endif

struct MD5Context_GL_WLDH {
        uint32 buf[4];
        uint32 bits[2];
        unsigned char in[64];
};

extern void MD5Init_GL_WLDH();
extern void MD5Update_GL_WLDH();
extern void MD5Final_GL_WLDH();
extern void MD5Transform_GL_WLDH();

/*
* This is needed to make RSAREF happy on some MS-DOS compilers.
*/
typedef struct MD5Context_GL_WLDH MD5_CTX;

#endif /* !MD5_H */