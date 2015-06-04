//
//  PayTypeViewController.h
//  WldhMini
//
//  Created by zhaojun on 14-6-19.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeNode.h"
#import "RecharegeBaseViewController.h"
/**
 *  支付类型列表
 *  支持如下:微信，支付宝，银联，联通卡，移动卡，电信卡
 */
@interface PayTypeViewController : RecharegeBaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *payTypeTable;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (strong, nonatomic) RechargeNode *rechargeNode;
@end
