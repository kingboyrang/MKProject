//
//  MKCallRecordViewController.h
//  MKCallRecord
//
//  Created by chenzhihao on 15-5-20.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

//通话记录列表
@interface MKCallRecordViewController : UIViewController 

//保存通话记录的数组
@property (nonatomic,strong) NSMutableArray *recordArray;

//显示通话记录的列表
@property (nonatomic,strong) UITableView *callRecordListTable;

@end
