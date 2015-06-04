//
//  RechargeManager.m
//  MKRecharegSetting
//
//  Created by wulanzhou-mini on 15-5-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "RechargeManager.h"
#import "RechargeNode.h"
#import "CZRequestArgs.h"
#import "CZServiceManager.h"
#import "ConfigDefineKey.h"

#define WsFormat(obj)     [NSString stringWithFormat:@"%@",obj]
#define Init(a,Obj)         {if (!Obj) {a = @"";}\
else if([ Obj isKindOfClass:[NSNull class]]){a= @"";}\
else {a = Obj;}}


@implementation RechargeManager
/**
 *  充值列表请求
 *
 *  @param completed 充值列表请求成功的结果回调
 */
+ (void)requestRecharegWithCompleted:(void(^)(NSArray *rechargeList))completed{
    
    CZRequestArgs *args=[[CZRequestArgs alloc] init];
    args.serviceType=CZServiceGetGoodsCgfType;
    NSString *strFlags=[[NSUserDefaults standardUserDefaults] objectForKey:kCZRechargeGoodsFlagKey];
    if (strFlags&&[strFlags length]>0) {
        [args paramWithObjectsAndKeys:strFlags,@"flag", nil];
    }
    [[CZServiceManager shareInstance] requestServiceWithArgs:args completed:^(NSDictionary *userinfo) {
        if([[userinfo objectForKey:@"result"] intValue]==0)
        {
            NSString *flag =[userinfo objectForKey:@"flag"];
            [[NSUserDefaults standardUserDefaults] setObject:flag forKey:kCZRechargeGoodsFlagKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //保存充值
            [self saveRechargeListWithDictionary:userinfo];
        }
        if (completed) {
            completed([self getRechargeGoodsList]);
        }
        
    }];
}

/**
 *  取得本地缓存充值列表[企业版充值列表]
 *
 *  @return  缓存企业版充值列表
 */
+ (NSArray*)getRechargeGoodsList{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSArray *chargeList=nil;
    if ([userDefault objectForKey:kCZRechargeGoodsListKey]) {
        NSData *data=[userDefault objectForKey:kCZRechargeGoodsListKey];
        chargeList=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else{
        chargeList=[NSArray array];
    }
    return chargeList;
}

/**
 *  取得本地缓存支付类型列表
 *
 *  @return  返回缓存支付类型列表
 */
+ (NSArray*)getRechargePayTypeList{

    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSArray *chargeList=nil;
    if ([userDefault objectForKey:kCZRechargePayTypeListKey]) {
        NSData *data=[userDefault objectForKey:kCZRechargePayTypeListKey];
        chargeList=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else{
        chargeList=[NSArray array];
    }
    return chargeList;
}
#pragma mark -私有方法
+ (void)saveRechargeListWithDictionary:(NSDictionary*)dic{
    NSMutableArray *rechargeMoneyInfoArray = [[NSMutableArray alloc ]initWithCapacity:0];
    NSMutableArray *moneyArray = [dic objectForKey:@"goods_list"];
    if (moneyArray==nil||[moneyArray count]==0)return;
    for(NSInteger i = 0;i< [moneyArray count];i++)
    {
        NSMutableDictionary *MoneyDic = [moneyArray objectAtIndex:i];
        RechargeNode *section = [[RechargeNode alloc] init];
        Init(section.goods_id, WsFormat([MoneyDic objectForKey:@"goods_id"]) );
        Init(section.name, WsFormat([MoneyDic objectForKey:@"name"]) );
        Init(section.price,WsFormat([MoneyDic objectForKey:@"price"])  );
        Init(section.present,  WsFormat([MoneyDic objectForKey:@"present"])  );
        Init(section.enable_flag, WsFormat([MoneyDic objectForKey:@"enable_flag"])  );
        Init(section.pure_name, WsFormat( [MoneyDic objectForKey:@"pure_name"]) );
        Init(section.goods_type, WsFormat( [MoneyDic objectForKey:@"goods_type"]) );
        
        [rechargeMoneyInfoArray addObject:section];
    }
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:rechargeMoneyInfoArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCZRechargeGoodsListKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
