//
//  PayConfigHandler.m
//  CZBaseLib
//
//  Created by wulanzhou-mini on 15-5-26.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "PayConfigHandler.h"
#import "CacheDataUtil.h"

#define kCZAliPayConfigKey  @"kCZAliPayConfigKey"
#define kCZWXPayConfigKey   @"kCZWXPayConfigKey"

@implementation PayConfigHandler

/**
 *  支付宝支付配置
 *
 *  @param config 支付宝配置信息
 */
+ (void)setAliPayWithConfig:(AlipayConfig*)config{
    [CacheDataUtil setValueArchiver:config forKey:kCZAliPayConfigKey];
}

/**
 *  删除支付宝配置
 */
+ (void)removeAliPayConfig{
    [CacheDataUtil removeForKey:kCZAliPayConfigKey];
}

/**
 *  取得支付宝配置信息
 *
 *  @return 取得支付宝配置信息
 */
+ (AlipayConfig*)shareAliPayConfig{
    AlipayConfig *config=[CacheDataUtil unarchiveValueForKey:kCZAliPayConfigKey];
    if (config==nil) {
        config=[[AlipayConfig alloc] init];
    }
    return config;
}

/**
 *  微信支付配置
 *
 *  @param config 微信支付配置信息
 */
+ (void)setWXPayWithConfig:(WXPayConfig*)config{
    [CacheDataUtil setValueArchiver:config forKey:kCZWXPayConfigKey];
}

/**
 *  删除微信支付配置
 */
+ (void)removeWXPayConfig{
    [CacheDataUtil removeForKey:kCZWXPayConfigKey];
}

/**
 *  取得微信支付配置
 *
 *  @return 取得微信支付配置信息
 */
+ (WXPayConfig*)shareWXPayConfig{
    WXPayConfig *config=[CacheDataUtil unarchiveValueForKey:kCZWXPayConfigKey];
    if (config==nil) {
       config=[[WXPayConfig alloc] init];
    }
    return config;
}
@end
