//
//  MKSearchContactListCell.h
//  MKDialplateView
//
//  Created by chenzhihao on 15-5-21.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "T9ContactRecord.h"
@interface MKSearchContactListCell : UITableViewCell

@property (nonatomic,strong) FontLabel *contactNameLab;     //显示姓名
@property (nonatomic,strong) FontLabel *phoneNumberLab;   //显示手机号和拼音

- (void)createCustomColorLabe:(T9ContactRecord*)contactRecordA;

@end
