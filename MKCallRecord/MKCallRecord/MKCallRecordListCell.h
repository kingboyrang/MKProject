//
//  CallRecordListCell.h
//  MKDemo
//
//  Created by chenzhihao on 15-5-20.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKCallRecordUtils.h"

@interface MKCallRecordListCell : UITableViewCell

@property(nonatomic,strong) UILabel      *nameLab;    //联系人名称或呼叫电话
@property(nonatomic,strong) UILabel      *placeLab;     //归属地
@property(nonatomic,strong) UILabel      *recordNumLab;  //呼叫次数
@property(nonatomic,strong) UILabel      *lastTimeLab;     //最后呼叫时间
@property(nonatomic,strong) UIImageView  *recordTypeImg; //呼叫类型icon
@property(nonatomic,strong) UIButton     *operationBtn;  //展示操作菜单按钮

@end
