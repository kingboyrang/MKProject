//
//  Md5Encrypt.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-13.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Md5Encrypt : NSObject
/**
 *  字符串md5加密
 *
 *  @param str 需要加密的字符串
 *
 *  @return md5加密字符串
 */
+ (NSString*)md5:(NSString*)str;
@end
