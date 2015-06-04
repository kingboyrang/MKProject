//
//  PayConfigHandler.h
//  CZBaseLib
//
//  Created by wulanzhou-mini on 15-5-26.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlipayConfig.h"
#import "WXPayConfig.h"

/**
 * 支付配置
 */
@interface PayConfigHandler : NSObject

/**
 *  支付宝支付配置
 *
 *  @param config 支付宝配置信息
 */
+ (void)setAliPayWithConfig:(AlipayConfig*)config;

/**
 *  删除支付宝配置
 */
+ (void)removeAliPayConfig;

/**
 *  取得支付宝配置信息
 *
 *  @return 取得支付宝配置信息
 */
+ (AlipayConfig*)shareAliPayConfig;

/**
 *  微信支付配置
 *
 *  @param config 微信支付配置信息
 */
+ (void)setWXPayWithConfig:(WXPayConfig*)config;

/**
 *  删除微信支付配置
 */
+ (void)removeWXPayConfig;

/**
 *  取得微信支付配置
 *
 *  @return 取得微信支付配置信息
 */
+ (WXPayConfig*)shareWXPayConfig;

@end
