//
//  CZRequestConfig.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-15.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

//默认请求配置

#import <Foundation/Foundation.h>

@interface CZRequestConfig : NSObject<NSCoding>
/**
 *  服务地址
 */
@property (nonatomic,copy)     NSString *httpServer;
/**
 *  agw版本,默认值为1.0
 */
@property (nonatomic,copy)     NSString *agwVersion;
/**
 *  品牌id
 */
@property (nonatomic,copy)     NSString *brandId;
/**
 *  平台类型,默认值为iphone(iphone表示企业版,iphone-app表示appstore版)
 */
@property (nonatomic,copy)     NSString *plateVersion;
/**
 *  app版本(如:1.0.0),默认值为[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
 */
@property (nonatomic,copy)     NSString *appVersion;
/**
 *  渠道ID或推荐人ID,默认值为43
 */
@property (nonatomic,copy)     NSString *invitedBy;
/**
 *  渠道类型,默认值为ad
 */
@property (nonatomic,copy)     NSString *invitedWay;
/**
 *  用户Id号
 */
@property (nonatomic,copy)     NSString *userId;
/**
 *  用户登陆密码
 */
@property (nonatomic,copy)     NSString *password;
@end
