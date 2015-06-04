//
//  AppConfigManager.m
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-21.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "AppConfigManager.h"
#import "PayTypeNode.h"
#import "CZServiceManager.h"
#import "ConfigDefineKey.h"


@implementation AppConfigManager

/**
 *  默认静态配置请求[注：目前内部只实现了支付充值列表缓存]
 *
 *  @param completed 静态配置请求的结果回调
 */
+ (void)requestDefaultConfigWithCompleted:(void(^)(NSDictionary *userInfo))finished{
    
    CZRequestArgs *args=[[CZRequestArgs alloc] init];
    args.serviceType=CZServiceDefaultConfigType;
    NSString *strFlag=[[NSUserDefaults standardUserDefaults] objectForKey:kCZDefaultConfigFlagKey];
    if (strFlag&&[strFlag length]>0) {
        [args paramWithObjectsAndKeys:strFlag,@"flag", nil];
    }
    [[CZServiceManager shareInstance] requestServiceWithArgs:args completed:^(NSDictionary *userInfo) {
        if([[userInfo objectForKey:@"result"] intValue]==0)
        {
            [[NSUserDefaults standardUserDefaults] setValue:[userInfo objectForKey:@"flag"] forKey:kCZDefaultConfigFlagKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self saveDefaultConfig:userInfo];
            
        }
        if (finished) {
            finished(userInfo);
        }
    }];
}



#pragma mark -私有方法
+ (void)saveDefaultConfig:(NSDictionary*)dic
{
    switch ([[dic objectForKey:@"result"]intValue])
    {
        case 0:
        {
            NSMutableDictionary *tempDic = [dic objectForKey:@"defaultconfig"];
            NSMutableDictionary *tempDic1 = [tempDic objectForKey:@"bootini"];
            if([tempDic count]>0)
            {
                //保存充值界面的充值方式
                NSMutableArray *rechargePayTypeArray = [tempDic1 objectForKey:@"paytypes"];
                [self saveRechargeTypeList:rechargePayTypeArray];
            }
        }
            
            break;
        default:
            break;
    }
    
}
+ (void)saveRechargeTypeList:(NSMutableArray *)rechargePayTypeArray{
    NSMutableArray *payTypeArray = [[NSMutableArray array] init];
    
    if(rechargePayTypeArray && [rechargePayTypeArray count]>0)
    {
        for(int i = 0;i<[rechargePayTypeArray count];i++)
        {
            NSMutableDictionary *payTypeDic = [rechargePayTypeArray objectAtIndex:i];
            PayTypeNode *node = [[PayTypeNode alloc] init];
            node.descStr = [payTypeDic objectForKey:@"desc"];
            node.payTypeStr = [payTypeDic objectForKey:@"paytype"];
            node.payKindStr = [payTypeDic objectForKey:@"paykind"];
            switch ([node.payKindStr intValue])
            {
                case 701:
                    node.leftIconImageName = @"yd.png";
                    break;
                case 702:
                    node.leftIconImageName = @"lt.png";
                    break;
                case 703:
                    node.leftIconImageName = @"dx.png";
                    break;
                case 704:
                    node.leftIconImageName = @"zfb.png";
                    break;
                case 705:
                    node.leftIconImageName = @"yl.png";
                    break;
                case 707:
                    node.leftIconImageName = @"zfbWeb.png";
                    break;
                default:
                    break;
            }
            [payTypeArray addObject:node];
        }
        //保存充值列表
        NSData *data=[NSKeyedArchiver archivedDataWithRootObject:payTypeArray];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCZRechargePayTypeListKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
@end
