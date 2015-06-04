//
//  MutilPointDetectController.h
//  MultipleAccessDemo
//
//  Created by wulanzhou-mini on 15-4-15.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//


typedef enum{
   MutilPointDetectStateNotNetWork=0,       //无网络
   MutilPointDetectStateNotAccessInternet,  //有网络  百度ping不通
   MutilPointDetectStateSuccess,            //有网络  百度通,接口通
   MutilPointDetectStateFailed              //有网络  百度通,所有接口不通
}MutilPointDetectState;

#import <Foundation/Foundation.h>
#import "MutilPointItem.h"

@protocol MutilPointDetectControllerDelegate <NSObject>

@optional
//检测结果代理
- (void)mutilPointDetectFinshed:(MutilPointItem*)mlutilPoint  state:(MutilPointDetectState)detectState;
@end

@interface MutilPointDetectController : NSObject
/**
 *  检测结果代理
 */
@property (nonatomic,assign) id<MutilPointDetectControllerDelegate> delegate;
/**
 *  设置检测地址
 *
 *  @param address 检测地址列表[string]
 */
- (void)setMutilPointDetectAddress:(NSArray*)address;
/**
 *  开始探测
 */
- (void)startDetect;
/**
 *  停止探测
 */
- (void)stopDetect;
@end
