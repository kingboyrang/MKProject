//
//  WldhRequestObj.h
//  WldhMini
//  保存在NSUserDefaults中数据的key
//  Created by mini1 on 14-5-29.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "CZRequestArgs.h"
@class CZRequestObj;

@protocol CZRequestObjDelegate <NSObject>
@optional
- (void)CZRequestFinished:(CZRequestObj*)requestObj resultDict:(NSDictionary *)resultDict;
- (void)CZRequestFailed:(CZRequestObj *)requestObj error:(NSError *)error;
@end

@interface CZRequestObj : NSObject<ASIHTTPRequestDelegate>
@property(nonatomic,strong) CZRequestArgs *requestArgs;  //请求信息
@property(nonatomic,assign) id<CZRequestObjDelegate> delegate;
/**
 *  单例
 */
+ (CZRequestObj*)sharedInstance;

/**
 *  request请求
 *
 *  @param args        请求参数
 *  @param reqDelegate 请求结果代理
 *
 */
- (void)requestService:(CZRequestArgs*)args
              delegate:(id<CZRequestObjDelegate>)reqDelegate;

/**
 *  停止请求
 */
- (void)stopRequest;
@end
