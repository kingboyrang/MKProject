//
//  AppDelegate.m
//  MKDemo
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactManager.h"
#import "ContactUtils.h"
#import "WldhDBManager.h"
#import "MKRecharegSetting.h"
#import "SystemUser.h"
#import "CZRequestConfig.h"
#import "CZRequestHandler.h"
#import "MKUserDataKeyDefine.h"
#import "ConfigSettingHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //注册微信
    [[MKRecharegSetting shareInstance] registerWXPay];
    
    [self loadAllContac];
    
    //加载归属地文件，只操作一次
    [self loadContactAttribution];
    
    //默认请求配置
    [self defaultRequestInit];
    
    //设置默认拨打方式:wifi下回拨
    [ConfigSettingHandler setWiFiCallBackOn:YES];
    
    //首页显示通话记录，需要加载完联系人，所以需要延时
    [NSThread sleepForTimeInterval:0.5];
    
    if ([SystemUser shareInstance].isLogin) {
        //创建用户数据库
        [[WldhDBManager shareInstance] createUserDatabase:[SystemUser shareInstance].userId];
    }
    return YES;
}

/**
 *  @author chenzhihao, 15-02-28 10:02:40
 *
 *  @brief  加载联系人归属地
 */
- (void)loadContactAttribution
{
    //定义一个NSBundle对象获取得到应用程序的main bundle
    //    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MKContactResource" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    //用对象mainBundle获取图片路径
    NSString *filePath = [bundle pathForResource:@"upbkAtt" ofType:@"dat"];
    [[ContactManager shareInstance].myPhoneOwnerShipEngine loadDataWithFilePath:filePath];
    
    [ContactUtils setCurrentCountryCode];
}

/**
 *  @brief  默认请求配置
 */
- (void)defaultRequestInit
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MKConfig" ofType:@"plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *httpMainServer = [dict objectForKey:kWldhDataKeyServerAddress];
    NSString *brandId = [dict objectForKey:kBrandid];
    
    SystemUser *mod=[SystemUser shareInstance];
    //请求默认配置
    CZRequestConfig *config=[[CZRequestConfig alloc] init];
    config.httpServer = httpMainServer;
    config.brandId = brandId;
    if (mod.isLogin) {
        config.userId=mod.userId;
        config.password=mod.password;
    }
    [CZRequestHandler initWithConfig:config];
}

- (void)loadAllContac
{
    [[ContactManager shareInstance] loadAllContact];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
