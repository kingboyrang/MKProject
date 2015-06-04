//
//  AlixPayObj.h
//  WldhMini
//
//  Created by dyn on 15/1/13.
//  Copyright (c) 2015年 Guoling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChargeDefine.h"
@protocol AlixPayObjDelegate;

@interface AlixPayObj : NSObject
@property (nonatomic, assign) id<AlixPayObjDelegate>delegate;
- (void)requestAlixPay:(NSString *)moneyStr schemaStr:(NSString *)schemaStr orderIdStr:(NSString *)orderidStr notifyURL:(NSString *)notifyURL;

@end

@protocol AlixPayObjDelegate <NSObject>

- (void)alixPayRechargeFinish:(NSDictionary *)infoDict;

@end
