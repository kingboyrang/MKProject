
#ifndef _CODES_GL_WLDH
#define _CODES_GL_WLDH

#ifdef __cplusplus   
extern "C"  
#endif  
//注意:rc4,md5接口必须放到codes.c中来，因为我的工程也有rc4,md5接口，可能会被调用导致程序出错.
char* KcDecode(char *src, char *keystr,int srclen,int deType,int keyType,int keylen);
#endif
