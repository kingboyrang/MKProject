//
//  NSString+CZExtend.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-13.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CZExtend)
/**
 *  生成guid值
 *
 *  @return 返回guid值
 */
+ (NSString*)createGUID;
/**
 *  @brief  判断字符串是否为空
 *
 *
 *  @return YES表示字符串为空，NO表示字符串不为空
 */
- (BOOL) isEmpty;

/**
 *  判断是否为email
 *
 *  @return 是email字符中返回YES,否则为NO
 */
- (BOOL)isEmail;

/**
 *  字符串去前后空格
 *
 *  @return 返回去空格后的内容
 */
- (NSString*)Trim;

/**
 *  字符串md5加密
 *
 *  @return md5字符串
 */
- (NSString*) stringFromMD5;
/**
 *  url字符串编码处理
 *
 *  @return  url编码字符串
 */
- (NSString*)URLEncode;
/**
 *  url字符串解码处理
 *
 *  @return url解码字符串
 */
- (NSString *)URLDecoded;
@end
