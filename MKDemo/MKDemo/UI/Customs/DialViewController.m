//
//  DialViewController.m
//  MKDemo
//
//  Created by chenzhihao on 15-5-25.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "DialViewController.h"
#import "MKUserDataKeyDefine.h"


#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DialViewController ()

@property (nonatomic,strong) UISegmentedControl *segmentControl;

@property (nonatomic,strong) UIView *showSegAndNumberView;  //显示segmen和输入号码的view

@end

@implementation DialViewController

- (void)createSegment
{
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"最近通话",@"通讯录"]];
    self.segmentControl.frame = CGRectMake(60, 6, [UIScreen mainScreen].bounds.size.width-60*2 , 32);
    //添加点击事件
    [self.segmentControl addTarget:self action:@selector(segmentControlChangeAction:) forControlEvents:UIControlEventValueChanged];
    //seg着色
    self.segmentControl.tintColor = kColorFromRGB(0x06bf04);;
    //设置默认选中
    self.segmentControl.selectedSegmentIndex = 0;
}

- (void)segmentControlChangeAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex==0) {
        if (self.dialplateVc.view.hidden) {
            self.contactVc.view.hidden = YES;
            self.dialplateVc.view.hidden = NO;
        }
    }
    else if (sender.selectedSegmentIndex==1)
    {
        if (self.contactVc.view.hidden) {
            self.contactVc.view.hidden = NO;
            self.dialplateVc.view.hidden = YES;
        }
    }
}

- (void)createUI
{
    self.containerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49);
    
    self.contactVc = [[ContactViewController alloc] init];
    [self.contactVc setParentController:self];
    self.contactVc.view.hidden = YES;
    self.contactVc.view.frame = self.containerView.bounds;
    [self addChildViewController:self.contactVc];
    [self.containerView addSubview:self.contactVc.view];
    
    self.dialplateVc = [[DialplateViewController alloc] init];
    self.dialplateVc.view.frame = self.containerView.bounds;
    [self.dialplateVc UpdateUI];    //传入所在view的bounds后需要重新布局
    [self addChildViewController:self.dialplateVc];
    [self.containerView addSubview:self.dialplateVc.view];
    
    //显示segment和手机号码的view
    self.showSegAndNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createSegment];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.title = nil;
    self.tabBarController.navigationItem.backBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.titleView = self.showSegAndNumberView;
    
    [self.showSegAndNumberView addSubview:self.segmentControl];
    [self.showSegAndNumberView addSubview:self.dialplateVc.showDialNumberView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
