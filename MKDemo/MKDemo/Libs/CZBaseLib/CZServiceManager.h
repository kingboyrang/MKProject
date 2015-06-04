//
//  WldhServiceManager.h
//  WldhMini
//
//  Created by mini1 on 14-5-29.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZRequestObj.h"

@interface CZServiceManager : NSObject<CZRequestObjDelegate>

+ (CZServiceManager *)shareInstance;

/**
 *  request请求(无参请求)
 *
 *  @param requestType      请求类型
 *  @param completed        请求完成的block
 *
 */
- (void)requestServiceWithType:(CZServiceRequestType)requestType completed:(void(^)(NSDictionary *userInfo))finished;

/**
 *  request请求
 *
 *  @param args             请求参数对象
 *  @param completed        请求完成的block
 *
 */
- (void)requestServiceWithArgs:(CZRequestArgs*)args completed:(void(^)(NSDictionary *userInfo))finished;

/**
 *  request请求停止
 *
 *  @param requestName  停止请求名称(等于CZRequestArgs.requestKey)
 *
 */
- (void)stopRequestWithName:(NSString*)requestName;
@end
