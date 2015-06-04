//
//  UserViewController1.m
//  MKDemo
//
//  Created by chenzhihao on 15-5-25.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "UserViewController1.h"

@interface UserViewController1 ()

@end

@implementation UserViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.title = @"商家自定义";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
