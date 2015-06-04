//
//  MKContactDetailPhoneListCell.h
//  MKContact
//
//  Created by chenzhihao on 15-5-20.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKContactDetailPhoneListCell : UITableViewCell
//显示姓名的Label
@property (nonatomic, strong) UILabel *phoneNumLab;

//显示电话号码归属地的Label
@property (nonatomic, strong) UILabel *phoneOnwerLab;

//拨打电话按钮
@property (nonatomic, strong) UIButton *callBtn;
@end
