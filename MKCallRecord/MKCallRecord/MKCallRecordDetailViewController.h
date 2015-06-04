//
//  MKCallRecordDetailViewController.h
//  MKCallRecord
//
//  Created by chenzhihao on 15-5-21.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactNode.h"
#import "ContactManager.h"
#import "MKCallRecordUtils.h"


@interface MKCallRecordDetailViewController : UIViewController 

//联系人的相关信息
@property (nonatomic, strong) ContactNode *contactNode;
//通话记录的相关信息
@property (nonatomic, strong) RecordMegerNode *recordNode;

@end
