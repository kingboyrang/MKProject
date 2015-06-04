//
//  MKRecharegSetting.m
//  MKRecharegSetting
//
//  Created by wulanzhou-mini on 15-5-25.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKRecharegSetting.h"
#import "WXApi.h"
#import "PayConfigHandler.h"
#import "SVProgressHUD.h"

@interface MKRecharegSetting ()<WXApiDelegate>

@end

@implementation MKRecharegSetting

/**
 *  单例
 *
 *  @return
 */
+ (MKRecharegSetting *)shareInstance
{
    static dispatch_once_t  onceToken;
    static MKRecharegSetting * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[MKRecharegSetting alloc] init];
    });
    return sSharedInstance;
}

/**
 *  注册微信
 */
- (void)registerWXPay{
   WXPayConfig *pay=[PayConfigHandler shareWXPayConfig];
   [WXApi registerApp:pay.appId];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp
{
    [SVProgressHUD dismiss];
    if([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp*)resp;
        // NSlog(@"支付失败， retcode=%d",resp.errCode);
        switch(response.errCode){
            case WXSuccess:
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"支付成功!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
             break;
            case WXErrCodeUserCancel:
                break;
            default:
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"支付失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
             break;
         }
    }
}

@end
