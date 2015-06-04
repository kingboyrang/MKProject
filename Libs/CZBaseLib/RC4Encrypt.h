//
//  wldh_rc4.h
//  WldhUtils
//
//  Created by dyn on 13-6-5.
//  Copyright (c) 2013年 dyn. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  rc4加密与解密
 */
@interface RC4Encrypt : NSObject
/**
 *  对字符串进行rc4加密
 *
 *  @param strInput 需要加密的字符串
 *  @param rc4Key   加密所使用的key值
 *
 *  @return 加密后字符串
 */
+ (NSString *)encrypt:(NSString*)strInput withKey:(NSString *)rc4Key;

/**
 *  对字符串进行rc4解密
 *
 *  @param strInput 需要解密的字符串
 *  @param rc4Key   解密所使用的key值
 *
 *  @return 解密后字符串
 */
+ (NSString *)decrypt:(NSString *)strInput withKey:(NSString *)rc4Key;

/**
 *  对字符串进行rc4加密 加密后的字符不转为16进制
 *
 *  @param strInput 需要加密的字符串
 *  @param rc4Key   加密所使用的key值
 *
 *  @return 加密后字符串
 */
+ (NSString *)encryptEx:(NSString *)strInput withKey:(NSString *)rc4Key;

/**
 *  对字符串进行rc4解密 接收的解密字符没有转为16进制
 *
 *  @param strInput 需要解密的字符串
 *  @param rc4Key   解密所使用的key值
 *
 *  @return 解密后字符串
 */
+ (NSString *)decryptEx:(NSString *)strInput withKey:(NSString *)rc4Key;

@end
