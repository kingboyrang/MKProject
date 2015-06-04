//
//  WXPayConfig.h
//  CZBaseLib
//
//  Created by wulanzhou on 15-5-26.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZBaseObject.h"

/**
 *  微信支付信息配置
 *
 *  微信支付分为三步
 *  1.取得访问权限gettoken
 *  2.根据订单生成预支付id
 *  3.通过预支付id调用微信支付
 *  注：1，2步可通过后台来处理，客户端取得预支付id再调起微信支付
 */
@interface WXPayConfig : CZBaseObject

/**
 *  开发者Id,默认值:wx56a16cfc49718c9a
 *  注：返回应用url scheme type设置
 */
@property (nonatomic,strong) NSString *appId;

/**
 *  开发者密钥,默认值:8e46d28a0ec519d92e2c1b0ac6b4933e
 */
@property (nonatomic,strong) NSString *appAppSecret;

/**
 *  商户Id,默认值:9876543210ZxCvBnM9876543210ZxCvB
 */
@property (nonatomic,strong) NSString *partnerId;


/**
 *  取得微信支付访问权限gettoken[微信支付第一步]
 *
 *  @param finished 取得微信支付token回调
 */
- (void)requestWXPayTokenWithCompleted:(void(^)(NSString *token,NSError *error))finished;

/**
 *  取得微信支付预支付id[微信支付第二步]
 *
 *  @param token          访问权限token[微信支付第一步]
 *  @param productData    订单数据(参数官网demo)
 *  @param finished       取得预支付id回调
 */
- (void)requestWXPayPrepayIdWithToken:(NSString*)token productData:(NSData*)productData completed:(void(^)(NSString *prepayId,NSError *error))finished;

/**
 *  取得微信支付签名参数
 *
 *  @param prepayId 预支付Id
 *  @return         签名参数
 */
- (NSDictionary*)wxPaySignParamWithPrepayId:(NSString*)prepayId;

/**
 *  取得微信支付md5签名字符串
 *
 *  @param dict 签名参数
 *
 *  @return 签名字符串
 */
- (NSString*)wxPayMd5SignString:(NSDictionary*)dict;

@end
