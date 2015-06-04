//
//  DialViewController.h
//  MKDemo
//
//  Created by chenzhihao on 15-5-25.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DialplateViewController.h"
#import "ContactViewController.h"

@interface DialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic,strong) DialplateViewController *dialplateVc;
@property (nonatomic,strong) ContactViewController *contactVc;
@end
