//
//  wldh_rc4.m
//  WldhUtils
//
//  Created by dyn on 13-6-5.
//  Copyright (c) 2013年 dyn. All rights reserved.
//

#import "RC4Encrypt.h"
#import "rc4.h"
@implementation RC4Encrypt

/**
 *  对字符串进行rc4加密
 *
 *  @param strInput 需要加密的字符串
 *  @param strKey   加密所使用的key值
 *
 *  @return 加密后字符串
 */
+ (NSString *)encrypt:(NSString*)strInput withKey:(NSString *)key
{
    char *buffer = Encrypt([strInput UTF8String], [key UTF8String]);
    
    NSString *strEncry = [NSString stringWithCString:buffer encoding:NSISOLatin1StringEncoding];
    
    delete [] buffer;
    
    return strEncry;
}

/**
 *  对字符串进行rc4加密 加密后的字符不转为16进制
 *
 *  @param strInput 需要加密的字符串
 *  @param key      加密所使用的key值
 *
 *  @return 加密后字符串
 */
+ (NSString *)encryptEx:(NSString *)strInput withKey:(NSString *)key
{
    char *buffer = Encrypt([strInput UTF8String], [key UTF8String]);
    
    unsigned char* src = HexToByte(buffer);
    
    NSString *strEncry = [[NSString alloc] initWithBytes:src
                                                  length:strlen(buffer)/2
                                                encoding:NSISOLatin1StringEncoding];
    delete [] src;
    
    delete [] buffer;
    
    return strEncry;
}

/**
 *  对字符串进行rc4解密
 *
 *  @param strInput 需要解密的字符串
 *  @param rc4Key   解密所使用的key值
 *
 *  @return 解密后字符串
 */
+ (NSString *)decrypt:(NSString *)strInput withKey:(NSString *)rc4Key
{
    char *buffer = Decrypt([strInput UTF8String], [rc4Key UTF8String]);
    
    NSString *strDecry = [NSString stringWithCString:buffer encoding:NSISOLatin1StringEncoding];
    
    delete [] buffer;
    
    return strDecry;

}

/**
 *  对字符串进行rc4解密 接收的解密字符没有转为16进制
 *
 *  @param strInput 需要解密的字符串
 *  @param rc4Key   解密所使用的key值
 *
 *  @return 解密后字符串
 */
+ (NSString *)decryptEx:(NSString *)strInput withKey:(NSString *)rc4Key
{
    char *buffer = Decrypt([strInput UTF8String], [rc4Key UTF8String]);
    
    NSString *strDecry = [NSString stringWithCString:buffer encoding:NSISOLatin1StringEncoding];
    
    delete [] buffer;
    
    return strDecry;
}

@end
