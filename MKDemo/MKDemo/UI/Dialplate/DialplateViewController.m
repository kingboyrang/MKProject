//
//  DialplateViewController.m
//  MKDemo
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "DialplateViewController.h"
#import "MKDialplateView.h"
#import <AudioToolbox/AudioToolbox.h>

#import "MKCallBackManager.h"
#import "CZRequestHandler.h"
#import "CZServiceManager.h"
#import "CZRequestArgs.h"
#import "Md5Encrypt.h"

@interface DialplateViewController ()

@end

@implementation DialplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
