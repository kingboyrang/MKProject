//
//  MyCostDetail.m
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-21.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "MyCostDetail.h"
#import "ConfigDefineKey.h"
#import "CZServiceManager.h"
#import "Md5Encrypt.h"

@implementation MyCostDetail

/**
 *  请求查询话费收支情况(如：话费收入url地址，话费支出url地址等)
 *  注：用户必须登陆，请求才有效
 *
 *  @param finished  查询话费收支情况结果回调
 */
+ (void)requestQueryCostWithCompleted:(void(^)(NSDictionary *userInfo))finished{
    CZRequestArgs *args=[[CZRequestArgs alloc] init];
    args.serviceType=CZServiceTemplateConfigType;
    NSString *strFlag=[[NSUserDefaults standardUserDefaults] objectForKey:kCZQueryCostDetailFlag];
    if (strFlag&&[strFlag length]>0) {
        [args paramWithObjectsAndKeys:strFlag,@"flag",[Md5Encrypt md5:args.requestSign.password],@"pwd", nil];
    }else{
        [args paramWithObjectsAndKeys:[Md5Encrypt md5:args.requestSign.password],@"pwd", nil];
    }
    [[CZServiceManager shareInstance] requestServiceWithArgs:args completed:^(NSDictionary *userInfo) {
        if (finished) {
            finished(userInfo);
        }
        if([[userInfo objectForKey:@"result"] intValue]==0){
            [[NSUserDefaults standardUserDefaults] setValue:[userInfo objectForKey:@"flag"] forKey:kCZQueryCostDetailFlag];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSDictionary *wap_target_url = userInfo[@"wap_target_url"];
            if (wap_target_url) {
                
                NSDictionary *incomeDic = wap_target_url[@"wap_account_details"];
                NSDictionary *expendDic = wap_target_url[@"wap_call_log"];
                
                // 收入
                if (incomeDic) {
                    NSString *incomeURL = incomeDic[@"url"];
                    if (incomeURL)
                    {
                        [[NSUserDefaults standardUserDefaults] setValue:incomeURL forKey:kCZCostIncomeURLKey];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                // 支出
                if (expendDic) {
                    NSString *expendURL = expendDic[@"url"];
                    if (expendURL)
                    {
                        [[NSUserDefaults standardUserDefaults] setValue:expendURL forKey:kCZCostExpendURLKey];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            }
            
        }
    }];
}

/**
 *  取得话费收支URL
 *
 *  @return 话费收支URL
 */
+ (NSString*)getIncomeExpendURLString{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:kCZCostIncomeURLKey]) {
        return [userDefault objectForKey:kCZCostIncomeURLKey];
    }
    return nil;
}

/**
 *  取得话单查询URL
 *
 *  @return 话单查询URL
 */
+ (NSString*)getCostDetailURLString{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:kCZCostExpendURLKey]) {
        return [userDefault objectForKey:kCZCostExpendURLKey];
    }
    return nil;
}
@end
