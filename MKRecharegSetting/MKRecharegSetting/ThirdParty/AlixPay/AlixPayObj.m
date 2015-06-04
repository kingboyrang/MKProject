//
//  AlixPayObj.m
//  WldhMini
//
//  Created by dyn on 15/1/13.
//  Copyright (c) 2015年 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlixPayObj.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayConfigHandler.h"
@implementation AlixPayObj

- (void)requestAlixPay:(NSString *)moneyStr schemaStr:(NSString *)schemaStr orderIdStr:(NSString *)orderidStr notifyURL:(NSString *)notifyURL{
    
    AlipayConfig *config=[PayConfigHandler shareAliPayConfig];
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = config.partnerId;
    order.seller = config.sellerId;
    order.tradeNO = orderidStr; //订单ID（由商家自行制定）
    order.productName = @"充值"; //商品标题
    order.productDescription = [NSString stringWithFormat:@"充值%@",moneyStr]; //商品描述
    order.amount = moneyStr; //商品价格
    order.notifyURL = notifyURL;
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = config.schemeStr;

    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(config.rsaPrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
/*
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        __block AlixPayObj *weakSelf = self;
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([weakSelf.delegate respondsToSelector:@selector(alixPayRechargeFinish:)]) {
                [weakSelf.delegate alixPayRechargeFinish:resultDic];
            }
            
        }];
    }
 */

}

@end
