//
//  CZRequestHandler.m
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-15.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "CZRequestHandler.h"
#define CZRequestConfigDefaultKey @"CZRequestConfigDefaultKey"

@implementation CZRequestHandler
/**
 *  初始化默认请求配置
 *  @param config 初始化对象
 */
+ (void)initWithConfig:(CZRequestConfig*)config{
    if (config) {
        NSData *data=[NSKeyedArchiver archivedDataWithRootObject:config];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:CZRequestConfigDefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 *  取得默认请求配置
 *
 */
+ (CZRequestConfig*)shareRequestConfig{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    CZRequestConfig *config=nil;
    if ([userDefault objectForKey:CZRequestConfigDefaultKey]) {
        NSData *data=[userDefault objectForKey:CZRequestConfigDefaultKey];
        config=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else{
        config=[[CZRequestConfig alloc] init];
    }
    return config;
}

/**
 *  登陆成功后设置用户帐号与密码
 *
 *  用途:CZRequestArgs请求时不用每次设置userId与requestSign.password值
 *
 *  @param account 用户帐号
 *  @param pwd     用户密码
 */
+ (void)setUserId:(NSString*)account password:(NSString*)pwd{
    CZRequestConfig *config=[self shareRequestConfig];
    config.userId=account;
    config.password=pwd;
    [self initWithConfig:config];
}

/**
 *  退出登陆删除用户帐号与用户密码
 *
 */
+ (void)removeAccountAndPwd{
    [self setUserId:@"" password:@""];
}

/**
 *  设置请求服务器地址
 *  @param http 服务器地址
 */
+ (void)setRequestHttpServer:(NSString*)http{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    CZRequestConfig *config=nil;
    if ([userDefault objectForKey:CZRequestConfigDefaultKey]) {
        NSData *data=[userDefault objectForKey:CZRequestConfigDefaultKey];
        config=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else{
        config=[[CZRequestConfig alloc] init];
    }
    config.httpServer=http;
    [self initWithConfig:config];
}

/**
 *  删除默认请求配置
 *
 */
+ (void)removeConfig{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CZRequestConfigDefaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
