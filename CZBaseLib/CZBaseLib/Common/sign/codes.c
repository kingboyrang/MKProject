
#include "sign_rc4.h"
#include "sign_md5.h"
#include "codes.h"
#include "stdio.h"
//#include "openssl/md5.h"
#include <stdlib.h>
#include <string.h>

#define KEYLEN  16
#define CODELEN  32
char *str=NULL;
char* GetKey_GL_WLDH(int mType) //内置key,长度固定为16
{
	switch(mType)
	{
	case 1: str="9876543210!@#$%^";
		break;
	case 2: str="1234567890!@#$%^";
		break;
	case 3: str="qazwsxedcrfvtgby";
		break;
	case 4: str="plmnkoijbuhbtfcr";
		break;
	case 5: str="plmnk12345998575";
		break;
	case 6: str="ple4kkfldsaflakf";
		break;
	case 7: str="pldsafdsaererfdf";
		break;
	case 8: str="ploiiwnjdklsflak";
		break;
	case 9: str="ple4deeedsaflakf";
		break;
	case 10: str="pl83skdueafl2ak1";
		break;
	case 11:str="ple4kk%lds3fjsd2";
		break;
	case 12:str="ple+03()123323=1";
		break;
	case 13:str="dfsfa#~23232132*";
		break;
	default:str="aaabbbcccdddeeef";
		break;
	}
	return str;
}
void MD5_GL_WLDH(unsigned char* buf, int len, unsigned char* outString)
{
    struct MD5Context_GL_WLDH md5Context;
    unsigned char md5[16];
    int i;

    MD5Init_GL_WLDH(&md5Context);
    MD5Update_GL_WLDH(&md5Context, (unsigned char*)buf, len);
    MD5Final_GL_WLDH(md5, &md5Context);

	//只输出32个字符?
    for(i=0; i < 16; i++)
    {
        sprintf(outString, "%02x", md5[i]);
		outString+=2;
   }
}

//MD5算法调用
int Call_MD5(int keyType, char *keystr,int keylen, char *src,int len, char *dst)
{
    //printf("keyType=%d  keystr=%s keylen=%d src=%s len=%d \n",keyType,keystr,keylen,src,len);
	if(keylen==0) //使用内置key
	{
		//src+key
		//unsigned char temp[1024*1000]={0};
		unsigned char *temp=(unsigned char*)malloc(len+16*4);
		//unsigned char *buf=(unsigned char*)malloc(len+16*4);
		//unsigned char buf[1024*1000]={0};
		//unsigned char keytemp[1024*1000]={0};
		char* key;
		key=GetKey_GL_WLDH(keyType);

		memset(temp,0,len+16*4);
		memcpy(temp,(unsigned char*)src,len);
		//printf("key:%s\n",key);
		memcpy(temp+len,(unsigned char*)key,KEYLEN);
		//printf("temp:%s\n",temp);
                //LOGD("temp:%s",temp);
		MD5_GL_WLDH(temp,len+KEYLEN,dst);
                //LOGD("dst:%s",dst);
		//printf("%s\n",dst);
		//for(i=0;i<16;i++)
			//printf("%02x",*(temp+i));
		//printf("n");

		//在传出之前再经过一次md5
		memset(temp,0,len+16*4);
		memcpy(temp,(unsigned char*)dst,CODELEN);
		memcpy(temp+CODELEN,(unsigned char*)key,KEYLEN);
		//printf("%s\n",temp);
		MD5_GL_WLDH(temp,CODELEN+KEYLEN,dst);
		printf("%s\n",dst);
                //LOGD("dst:%s",dst);
		
// 		memcpy(buf,temp,1024);
// 		memcpy(keytemp,keystr,1024);
// 		RC4(buf,len,keytemp,keylen);
		if(temp)
			free(temp);

	}else  //使用从服务器获取到的key
	{
		unsigned char *temp=(unsigned char*)malloc(len+16*4);
		char* key;
		key=GetKey_GL_WLDH(keyType);

        //第一次加密用从服务器获取到的key,防止第一次通过截获的密钥解密
		memset(temp,0,len+16*4);
		memcpy(temp,(unsigned char*)src,len);
		memcpy(temp+len,(unsigned char*)keystr,keylen);
		//printf("%s\n",temp);
		MD5_GL_WLDH(temp,len+keylen,dst);
		//printf("%s\n",dst);
		//for(i=0;i<16;i++)
			//printf("%02x",*(temp+i));
		//printf("n");

		//在传出之前再经过一次md5 ,这次使用内置key
		memset(temp,0,len+keylen);
		memcpy(temp,(unsigned char*)dst,CODELEN);
		memcpy(temp+CODELEN,(unsigned char*)key,KEYLEN);
		//printf("%s\n",temp);
		MD5_GL_WLDH(temp,CODELEN+KEYLEN,dst);
		printf("%s\n",dst);
		if(temp)
			free(temp);
	}
	return 0;
}

//RC4算法调用
int Call_RC4(int keyType,  char *keystr,int keylen, char *src,int len, char *dst)
{
	if(keylen==0) //使用内置key
	{
		//src+key
		unsigned char *temp=(unsigned char*)malloc(len+16*4);
		GetKey_GL_WLDH(keyType);
		//int i;
		memset(temp,0,len+16*4);
		memcpy(temp,(unsigned char *)src,len);
		//printf("src:%s key:%s\n",temp,key);
		RC4_GL_WLDH(temp,len,(unsigned char *)str,KEYLEN);
		//for(i=0;i<len;i++)
		   //printf("%02x",*(temp+i));
		//printf(" len:%d \n",strlen(temp));

		//在传出之前再经过一次md5
		//注意：传入的len必须是int,如果为long，可能会为0
		memcpy(temp+len,(unsigned char *)str,KEYLEN);
		//printf("%s\n",temp);
		MD5_GL_WLDH(temp,len+KEYLEN,dst);
        //printf("%s\n",dst);
		if(temp)
		   free(temp);

	}else  //使用从服务器获取到的key
	{
		//第一次加密用从服务器获取到的key,防止第一次通过截获的密钥解密
		unsigned char *temp=(unsigned char*)malloc(len+16*4);
		char* key=GetKey_GL_WLDH(keyType);
		//int i;
		memset(temp,0,len+16*4);
		memcpy(temp,(unsigned char *)src,len);
		//printf("src:%s key:%s\n",temp,key);
		RC4_GL_WLDH(temp,len,(unsigned char *)keystr,keylen);
		//for(i=0;i<len;i++)
		   //printf("%02x ",*(temp+i));
		//printf(" len:%d \n",strlen(temp));
		//在传出之前再经过一次md5 ,这次使用内置key
		memcpy(temp+len,(unsigned char *)key,KEYLEN);
		//printf("%s\n",temp);
		MD5_GL_WLDH(temp,len+KEYLEN,dst);
		//printf("%s\n",dst);
		if(temp)
		  free(temp);
	}
	return 0;
}
//参数：
//src:要加密的字符串
//srclen:加加密的字符串长度
//outstr:输出加密后的字符串
//deType:加密算法类型
//keyType:加密key类型
//keystr;加密码key字符串
//keylen;加密码key字符串长度
//注：如果keystr为空，就使用内置key字符串
 char out[33]={0};
char* KcDecode(char *src, char *keystr,int srclen,int deType,int keyType,int keylen)
{
    //printf("decode start!\n");
    memset(out,0,sizeof(out));

	//printf("src:%s len:%d \n",src,srclen);
	//printf("deType:%d keyType:%d keystr=%d keylen=%d \n",deType,keyType,keystr,keylen);
    //char *out=(char*)malloc(100);
	//LOGD("src %s",src);
	//LOGD("kstr %s",keystr);
   	//LOGD("src %d",srclen);
   	//LOGD("deType %d",deType);
   	//LOGD("ktype %d",keyType);
   	//LOGD("klen %d",keylen);
	switch(deType)
	{
	case  1:  //DES
		Call_MD5(keyType,keystr,keylen,src,srclen,out);
		break;
	case 2: //RC4
		Call_RC4(keyType,keystr,keylen,src,srclen,out);
		break;
	case 3: //AES
		break;
	case 4: //MD5-hash
		break;
	case 5: //SHA-hash
		break;
	case 6: //RSA 非对称
		break;
	}
        //LOGD("out %d",out);
	return out;
}
