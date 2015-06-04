//
//  AppConfigManager.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-21.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  静态配置管理
 */
@interface AppConfigManager : NSObject
/**
 *  默认静态配置请求[注：目前内部只实现了支付充值列表缓存]
 *
 *  @param completed 静态配置请求的结果回调
 */
+ (void)requestDefaultConfigWithCompleted:(void(^)(NSDictionary *userInfo))finished;


@end
