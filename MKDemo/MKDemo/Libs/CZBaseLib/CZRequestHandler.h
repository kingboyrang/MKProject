//
//  CZRequestHandler.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-15.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZRequestConfig.h"
@interface CZRequestHandler : NSObject
/**
 *  初始化默认请求配置
 *  @param config 初始化对象
 */
+ (void)initWithConfig:(CZRequestConfig*)config;

/**
 *  取得默认请求配置
 *
 */
+ (CZRequestConfig*)shareRequestConfig;

/**
 *  设置请求服务器地址
 *  @param http 服务器地址
 */
+ (void)setRequestHttpServer:(NSString*)http;

/**
 *  登陆成功后设置用户帐号与密码
 *
 *  用途:CZRequestArgs请求时不用每次设置userId与requestSign.password值
 *
 *  @param account 用户帐号
 *  @param pwd     用户密码
 */
+ (void)setUserId:(NSString*)account password:(NSString*)pwd;

/**
 *  退出登陆删除用户帐号与用户密码
 *
 */
+ (void)removeAccountAndPwd;

/**
 *  删除默认请求配置
 *
 */
+ (void)removeConfig;
@end
