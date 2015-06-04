//
//  RechargeViewController.h
//  MKRecharegSetting
//
//  Created by wulanzhou-mini on 15-5-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecharegeBaseViewController.h"
@class RechargeNode;

/**
 *  商品充值列表
 */
@interface RechargeViewController : RecharegeBaseViewController<UITableViewDataSource,UITableViewDelegate>
/**
 *  充值列表
 */
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *rechargeTable;
/**
 *  数据源列表[RechargeNode对象集合]
 */
@property (nonatomic,strong) NSMutableArray *listData;
/**
 *  设置数据源
 */
- (void)setRechargeDataSource;
/**
 *  选中充值
 */
- (void)selectedRechargeItem:(RechargeNode*)node;
@end
