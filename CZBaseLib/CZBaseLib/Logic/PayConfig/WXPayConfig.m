//
//  WXPayConfig.m
//  CZBaseLib
//
//  Created by wulanzhou-mini on 15-5-26.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "WXPayConfig.h"
#import "Md5Encrypt.h"
#import "ASIHTTPRequest.h"

@implementation WXPayConfig

- (id)init{
    if (self=[super init]) {
        self.appId=@"wx56a16cfc49718c9a";
        self.appAppSecret=@"8e46d28a0ec519d92e2c1b0ac6b4933e";
        self.partnerId=@"9876543210ZxCvBnM9876543210ZxCvB";
    }
    return self;
}



/**
 *  取得微信支付访问权限gettoken
 *
 *  @param finished 取得微信支付token回调
 */
- (void)requestWXPayTokenWithCompleted:(void(^)(NSString *token,NSError *error))finished{
      NSString *getAccessTokenUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%@&secret=%@", self.appId, self.appAppSecret];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:getAccessTokenUrl]];
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[weakRequest responseData]
                                                             options:kNilOptions
                                                               error:&error];
        if (error) {
            if (finished) {
                finished(nil,error);
            }
            return;
        }
        NSString *accessToken = dict[@"access_token"];
        if (accessToken) {
            if (finished) {
                finished(accessToken,nil);
            }
        } else {
            NSString *strMsg = [NSString stringWithFormat:@"errcode: %@, errmsg:%@", dict[@"errcode"], dict[@"errmsg"]];
            NSDictionary* userInfo = [NSDictionary dictionaryWithObject:strMsg forKey:NSLocalizedDescriptionKey];
            NSError *error_ = [[NSError alloc] initWithDomain:@"ServiceRequestManager"
                                                         code:[dict[@"errcode"] integerValue]
                                                     userInfo:userInfo];
            
            if (finished) {
                finished(nil,error_);
            }
        }
    }];
    [request setFailedBlock:^{
        if (finished) {
            finished(nil,weakRequest.error);
        }
    }];
    [request startAsynchronous];
}

/**
 *  取得微信支付预支付id[微信支付第二步]
 *
 *  @param token          访问权限token[微信支付第一步]
 *  @param productData    订单数据
 *  @param finished       取得预支付id回调
 */
- (void)requestWXPayPrepayIdWithToken:(NSString*)token productData:(NSData*)productData completed:(void(^)(NSString *prepayId,NSError *error))finished{

    NSString *getPrepayIdUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?access_token=%@", token];

    // 文档: 详细的订单数据放在 PostData 中,格式为 json
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:getPrepayIdUrl]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    [request setPostBody:[NSMutableData dataWithData:productData]];
    

    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[weakRequest responseData]
                                                             options:kNilOptions
                                                               error:&error];
        if (error) {
            if (finished) {
                finished(nil,error);
            }
            return;
        }
        NSString *prePayId = dict[@"prepayid"];
        if (prePayId) {
            if (finished) {
                finished(prePayId,nil);
            }
        } else {
            NSString *strMsg = [NSString stringWithFormat:@"errcode: %@, errmsg:%@", dict[@"errcode"], dict[@"errmsg"]];
            NSDictionary* userInfo = [NSDictionary dictionaryWithObject:strMsg forKey:NSLocalizedDescriptionKey];
            NSError *error_ = [[NSError alloc] initWithDomain:@"ServiceRequestManager"
                                                         code:[dict[@"errcode"] integerValue]
                                                     userInfo:userInfo];
            
            if (finished) {
                finished(nil,error_);
            }
        }
    }];
    [request setFailedBlock:^{
        if (finished) {
            finished(nil,weakRequest.error);
        }
    }];
    [request startAsynchronous];

}

/**
 *  取得微信支付签名参数
 *
 *  @param prepayId 预支付Id
 *  @return         签名参数
 */
- (NSDictionary*)wxPaySignParamWithPrepayId:(NSString*)prepayId{
    
    UInt32 timeStamp=[[NSDate date] timeIntervalSince1970];
    
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:self.appId        forKey:@"appid"];
    [signParams setObject:self.partnerId forKey:@"partnerid"];
    [signParams setObject:[self wxPayNonceString]    forKey:@"noncestr"];
    [signParams setObject:@"Sign=WXPay"      forKey:@"package"];
    [signParams setObject: [NSString stringWithFormat:@"%d",(unsigned int)timeStamp]   forKey:@"timestamp"];
    [signParams setObject: prepayId     forKey:@"prepayid"];
    
    return signParams;
}

/**
 *  取得微信支付md5签名字符串
 *
 *  @param dict 签名参数
 *
 *  @return 签名字符串
 */
- (NSString*)wxPayMd5SignString:(NSDictionary*)dict{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![[dict objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[dict objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", self.partnerId];
    //得到MD5 sign签名
    NSString *md5Sign =[Md5Encrypt md5:contentString];
    
    return [md5Sign uppercaseString];
}

#pragma mark -私有方法
/**
 *  生成随机串，防重发
 *
 *  @return 随机串
 */
- (NSString*)wxPayNonceString{
    NSString *randomString = [NSString stringWithFormat:@"%d",arc4random()%100000];
    return [Md5Encrypt md5:randomString];
}
@end
