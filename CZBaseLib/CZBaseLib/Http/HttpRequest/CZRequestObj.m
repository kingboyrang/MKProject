//
//  WldhRequestObj.m
//  WldhMini
//  
//  Created by mini1 on 14-5-29.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "CZRequestObj.h"

@interface CZRequestObj ()

@property(nonatomic,strong) ASIHTTPRequest *requestHandle;//请求
@end


@implementation CZRequestObj

@synthesize requestHandle;
@synthesize delegate;


- (void)dealloc
{
    
    self.delegate = nil;
    if (self.requestHandle)
    {
        [self.requestHandle clearDelegatesAndCancel];
    }
    self.requestHandle = nil;
   
}
/**
 *  单例
 */
+ (CZRequestObj*)sharedInstance
{
    static dispatch_once_t  onceToken;
    static CZRequestObj * sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[CZRequestObj alloc] init];
    });
    return sSharedInstance;
}
/**
 *  request请求
 *
 *  @param args        请求参数
 *  @param reqDelegate 请求结果代理
 *
 */
- (void)requestService:(CZRequestArgs*)args
              delegate:(id<CZRequestObjDelegate>)reqDelegate{
    self.requestArgs=args;
    self.delegate=reqDelegate;

    self.requestHandle = [args GetHttpRequest];
    self.requestHandle.delegate = self;
    [self.requestHandle startAsynchronous];
}
#pragma mark -ASIHTTPRequestDelegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: nil];
    
    if (resultDict == nil || [resultDict count] == 0)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(CZRequestFailed:error:)])
        {
            [self.delegate CZRequestFailed:self error:[NSError errorWithDomain:@"返回数据为空"
                                                                            code:-999
                                                                        userInfo:nil]];
        }
    }
    else
    {
        if(self.delegate&&[self.delegate respondsToSelector:@selector(CZRequestFinished:resultDict:)])
        {
            [self.delegate CZRequestFinished:self resultDict:resultDict];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(CZRequestFailed:error:)])
    {
        [self.delegate CZRequestFailed:self error:[request error]];
    }
}
/**
 *  停止请求
 */
- (void)stopRequest
{
    if (self.requestHandle) {
        [self.requestHandle cancel];
        [self.requestHandle clearDelegatesAndCancel];
    }
}
@end
