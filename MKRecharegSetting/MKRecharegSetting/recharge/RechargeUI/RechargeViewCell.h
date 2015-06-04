//
//  WSRechangeCell.h
//  WldhWeishuo
//
//  Created by xiongjie on 14-9-11.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *labName;
@property(nonatomic,strong) UIButton *chargeBtn;

- (void)addTarget:(id)target action:(SEL)action;

@end
