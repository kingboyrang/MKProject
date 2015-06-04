//
//  RechargeNode.h
//  MKRecharegSetting
//
//  Created by wulanzhou-mini on 15-5-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZBaseObject.h"

/**
 * 充值商品
 */
@interface RechargeNode : CZBaseObject
/** 商品ID */
@property(nonatomic, strong) NSString    *goods_id;
/** 苹果内产品ID */
@property(nonatomic, strong) NSString    *product_id;
/** 商品名称 */
@property(nonatomic, strong) NSString    *name;
/** 商品价格 */
@property(nonatomic, strong) NSString    *price;
/**  */
@property(nonatomic, strong) NSString    *pure_name;
/**  */
@property(nonatomic, strong) NSString    *enable_flag;
/**  */
@property(nonatomic, strong) NSString    *present;
/** 商品类型 */
@property(nonatomic, strong) NSString    *goods_type;

- (NSString*)priceToStringText;
- (NSString*)moneyStr;

@end
