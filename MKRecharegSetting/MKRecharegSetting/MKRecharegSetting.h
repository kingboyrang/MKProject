//
//  MKRecharegSetting.h
//  MKRecharegSetting
//
//  Created by wulanzhou-mini on 15-5-25.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKRecharegSetting : NSObject

/**
 *  单例
 *
 *  @return
 */
+ (MKRecharegSetting *)shareInstance;

/**
 *  注册微信
 */
- (void)registerWXPay;

@end
