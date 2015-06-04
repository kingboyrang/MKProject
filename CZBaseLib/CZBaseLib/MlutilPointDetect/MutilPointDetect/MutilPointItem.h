//
//  MlutilPointItem.h
//  MultipleAccessDemo
//
//  Created by wulanzhou-mini on 15-4-15.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServiceOperation;

@interface MutilPointItem : NSObject
@property (nonatomic,strong) NSString *requestURLString;          //探测的URL(原始的URL+接口)
@property (nonatomic,strong) NSString *methodName;                //方法名
@property (nonatomic,strong) NSString *name;                      //名称[用于区分]
@property (nonatomic,assign) BOOL isFinished;                     //表示是否探测成功
@property (nonatomic,readonly) ServiceOperation *requestOperation;//线程
/**
 *  构造初始化
 *
 *  @param urlString 请求的URL
 *
 *  @return          获取探入点对象
 */
- (id)initWithString:(NSString*)urlString;
/**
 *  构造初始化
 *
 *  @param urlString  请求的URL
 *  @param methodName 请求的方法名
 *
 *  @return 获取探入点对象
 */
- (id)initWithString:(NSString*)urlString method:(NSString*)methodName;

@end
