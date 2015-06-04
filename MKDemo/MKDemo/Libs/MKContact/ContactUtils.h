//
//  Utils.h
//  MKFrameworkDemo
//
//  Created by chenzhihao on 15-5-18.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface ContactUtils : NSObject

//设置国家区号
+ (void)setCurrentCountryCode;

/**
 *  @brief  获取当前国家区号
 *
 *  @return 国家区号
 */
+ (NSString *)getCurrentCountryCode;

/**
 *  @brief  判断是否是大陆用户
 *
 *  @return YES表示是大陆用户，NO表示非大陆用户
 */
+ (BOOL)isInland;

/**
 *  @brief  加载联系人归属地文件路径
 */
+ (NSString *)getContactAttributionPath;

/**
 *  @brief  格式化手机号码，过滤一些信息 如86 086 0086等
 *
 *  @param phone 需要过滤的手机号码
 *
 *  @return 过滤后的字符串
 */
+ (NSString *)formatPhoneNumber:(NSString *)phone;

/**
 *  @brief  为电话号码加上国家码
 *
 *  @param phoneNumber 电话号码
 *  @param countryCode 00开头的国家吗(如:0086)
 *
 *  @return 处理后的电话号码
 */
+ (NSString *)addCountryCodeForPhoneNumber:(NSString *)phoneNumber countryCode:(NSString *)countryCode;

/**
 *  @brief  去掉电话号码中的特殊字符
 *
 *  @param phoneNumber 电话号码
 *  @param countryCode 00开头的国家吗(如:0086)
 *
 *  @return 处理后的电话号码
 */
+ (NSString *)deleteCountryCodeFromPhoneNumber:(NSString *)phoneNumber countryCode:(NSString *)countryCode;

/**
 *  @brief  获取归属地
 *
 *  @param phone 手机号码
 *
 *  @return 归属地
 */
+ (NSString *)getPlaceByPhone:(NSString *)phone;

/**
 *  @brief  根据手机号码获取联系人姓名
 *
 *  @param phone 手机号码
 *
 *  @return 联系人姓名
 */
+ (NSString *)getContactNameByPhone:(NSString *)phone;

/**
 *  @brief  插入通话记录
 */
+ (void)insertOneCallRecord:(NSString *)phone;

@end
