//
//  MyCostDetail.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-21.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 话单处理
 */
@interface MyCostDetail : NSObject

/**
 *  请求查询话费收支情况(如：话费收入url地址，话费支出url地址等)
 *  注：用户必须登陆，请求才有效
 *
 *  @param finished  查询话费收支情况结果回调
 */
+ (void)requestQueryCostWithCompleted:(void(^)(NSDictionary *userInfo))finished;

/**
 *  取得话费收支URL
 *
 *  @return 话费收支URL
 */
+ (NSString*)getIncomeExpendURLString;

/**
 *  取得话单查询URL
 *
 *  @return 话单查询URL
 */
+ (NSString*)getCostDetailURLString;

@end
