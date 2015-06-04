//
//  CZRechargeManager.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-21.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 充值管理
 */
@interface RechargeManager : NSObject
/**
 *  商品充值列表请求[注：登陆成功才能取到充值列表]
 *
 *  @param completed 充值列表请求成功的结果回调
 */
+ (void)requestRecharegWithCompleted:(void(^)(NSArray *rechargeList))completed;

/**
 *  取得本地缓存商品充值列表
 *
 *  @return  返回缓存商品充值列表
 */
+ (NSArray*)getRechargeGoodsList;

/**
 *  取得本地缓存支付类型列表
 *
 *  @return  返回缓存支付类型列表
 */
+ (NSArray*)getRechargePayTypeList;
@end
