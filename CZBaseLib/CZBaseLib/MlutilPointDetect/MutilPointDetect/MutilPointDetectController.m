//
//  MutilPointDetectController.m
//  MultipleAccessDemo
//
//  Created by wulanzhou-mini on 15-4-15.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "MutilPointDetectController.h"

//以下为connectedToNetwork方法的引用
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <arpa/inet.h>

#import "WldhSimplePingManager.h"
#import "SimplePingResult.h"
#import "ServiceOperationQueue.h"


@interface MutilPointDetectController (){
    NSInteger _maxQueue;               //最大并行个数
    __block NSInteger _curIndex;       //当前执行的第几个
    ServiceOperationQueue  *_queue;    //队列
}
@property (nonatomic,strong) NSArray *mutilAddress;
@end

@implementation MutilPointDetectController

- (id)init{
    if (self=[super init]) {
        _queue=[[ServiceOperationQueue alloc] init];
        _maxQueue=4;
        _curIndex=0;
    }
    return self;
}

/**
 *  设置检测地址
 *
 *  @param address 地址列表[MlutilPointItem]
 */
- (void)setMutilPointDetectAddress:(NSArray*)address{
    self.mutilAddress=address;
}
/**
 *  开始探测
 *  1.判断网络是否开启,如果是关，则直接提示
 *  2.网络开,则ping百度是否通，不知则提示
 *  3.ping百度通，则走4个地址并行探测，不通则继续下4个地址探测(再不通则继续4个)，通则直接中断运行
 */
- (void)startDetect{
    //[self stopDetect];//先停止
    
    _curIndex=0;
    //开始检测
    [self nextQueue];
    
    /**
    if (!self.isDirectDetect) {
        if (![self connectedToNetwork]) {//网络未连接
            if (self.delegate&&[self.delegate respondsToSelector:@selector(mutilPointDetectFinshed:state:)]) {
                [self.delegate mutilPointDetectFinshed:nil state:MutilPointDetectStateNotNetWork];
            }
        }else{//网络已连接
            
            [WldhSimplePingManager ping:@"http://wwww.baidu.com" target:self action:@selector(pingFinished:)];
        }
    }else{
        _curIndex=0;
        //开始检测
        [self nextQueue];
    }
     **/
    
}
/**
 *  停止探测
 */
- (void)stopDetect{
    if(_queue){
        [_queue reset];
    }
    _curIndex=0;
}
/**
 *  ping 百度结果处理
 *
 *  @param ping 结果对象
 */
- (void)pingFinished:(SimplePingResult*)ping{
    if (ping.pingHostStatus==PingHostAddressStatusSuccess) {
        [self nextQueue];
    }else{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(mutilPointDetectFinshed:state:)]) {
            [self.delegate mutilPointDetectFinshed:nil state:MutilPointDetectStateNotAccessInternet];
        }
    }
}
/**
 *  最大并行执行4个,只要其中一个成功，则停止运行
 */
- (void)nextQueue{
    if([self.mutilAddress count]==0)return;
    if(_curIndex>=[self.mutilAddress count]-1&&[self.mutilAddress count]!=1)return;
   
   [_queue reset];
   NSInteger total;
   if(_curIndex+_maxQueue>[self.mutilAddress count])
   {
       total=[self.mutilAddress count];
   }else{
       total=_curIndex+_maxQueue;
   }
   if(_curIndex>0){
        _curIndex+=1;
   }
    while (_curIndex<total) {
        MutilPointItem *item=(MutilPointItem*)[self.mutilAddress objectAtIndex:_curIndex];
        [_queue addOperation:item.requestOperation];
        _curIndex++;
    }
    if (_curIndex==total) {
        _curIndex-=1;
    }
    __block MutilPointDetectController  *_mult=self;
    __block ServiceOperationQueue *_queueSelf=_queue;
    //每当一个请求完成就会执行这里
    [_queue setFinishBlock:^(ServiceOperation *operation) {
        NSLog(@"operation =%@",operation);
        MutilPointItem *item=[_mult searchItemWithOperate:operation];
        if(operation.responseStatusCode==200){//表示请求成功
            item.isFinished=YES;
            if (_mult.delegate&&[_mult.delegate respondsToSelector:@selector(mutilPointDetectFinshed:state:)]) {
                [_mult.delegate mutilPointDetectFinshed:item state:MutilPointDetectStateSuccess];
            }
            [_queueSelf reset];
        }else{
            
            item.isFinished=NO;
        }
    }];
    //表示当前所有的失败了
    [_queue setCompleteBlock:^{
        BOOL boo=[_mult isMutilDetectSuccess];
        //表示所有的探测都失败
        if(!boo){
            if (_mult.delegate&&[_mult.delegate respondsToSelector:@selector(mutilPointDetectFinshed:state:)]) {
                [_mult.delegate mutilPointDetectFinshed:nil state:MutilPointDetectStateFailed];
            }
            
        }else{
            NSLog(@"nextQueue ");
            [_mult nextQueue];
        }
    }];

}
#pragma mark -
-(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}
/**
 *  判断探测是否成功
 *
 *  @return  成功则为YES,否则为NO
 */
- (BOOL)isMutilDetectSuccess{
    BOOL boo=NO;
    for (MutilPointItem *item in self.mutilAddress) {
        if (item.isFinished) {
            boo=YES;
            break;
        }
    }
    //表示所有的探测都失败
    if(!boo&&_curIndex>=[self.mutilAddress count]-1){
        return NO;
    }
    return YES;
}
/**
 *  查找当前执行完成的线程
 *
 *  @param oper 查询的对象
 *
 *  @return     返回查找到的对象
 */
- (MutilPointItem*)searchItemWithOperate:(ServiceOperation*)oper{
    for (MutilPointItem *item in self.mutilAddress) {
        if(item.requestOperation==oper){
            return item;
        }
    }
    return nil;
}
@end
