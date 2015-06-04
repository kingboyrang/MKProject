//
//  RecharegeBaseViewController.m
//  MKRecharegSetting
//
//  Created by wulanzhou-mini on 15-5-27.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "RecharegeBaseViewController.h"

@interface RecharegeBaseViewController ()

@end

@implementation RecharegeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
/**
 *  按钮正常时的颜色
 *
 *  @return  按钮颜色
 */
- (UIColor*)getButtonNormalColor{
    return [UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0];
}

/**
 *  按钮高亮时的颜色
 *
 *  @return 按钮颜色
 */
- (UIColor*)getButtonHighlightedColor{
    return [UIColor colorWithRed:2/255.0 green:157/255.0 blue:0/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
