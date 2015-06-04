//
//  MKContactDetailViewController.h
//  MKContact
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactNode.h"

@interface MKContactDetailViewController : UIViewController

//联系人对象
@property (nonatomic,strong) ContactNode *aContact;

@end
