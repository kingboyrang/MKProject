//
//  DialSettingViewController.m
//  MKRecharegSetting
//
//  Created by wulanzhou-mini on 15-5-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "DialSettingViewController.h"
#import "ConfigSettingHandler.h"

@interface DialSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *wifilab;
@property (weak, nonatomic) IBOutlet UILabel *otherlab;
@property (weak, nonatomic) IBOutlet UIButton *wifiBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;


@end

@implementation DialSettingViewController

- (id)init{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"MKRechargeSettingRecource" withExtension:@"bundle"]];
    if ((self = [super initWithNibName:@"DialSettingViewController" bundle:bundle]))
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"拨打设置";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.wifiBtn.selected=[ConfigSettingHandler isWiFiCallBackOn];
    [self setDefaultDialSettingWithButton:self.wifiBtn tipLabel:self.wifilab];
    self.otherBtn.selected=[ConfigSettingHandler is3G4GCallBackOn];
    [self setDefaultDialSettingWithButton:self.otherBtn tipLabel:self.otherlab];
    
    //重设frame
    CGRect r=self.wifiBtn.frame;
    CGFloat leftX=(self.view.bounds.size.width-r.size.width*2)/3.0;
    r.origin.x=leftX;
    self.wifiBtn.frame=r;
    
    NSLog(@"self.wifiBtn.frame =%@",NSStringFromCGRect(self.wifiBtn.frame));
    
    r=self.otherBtn.frame;
    r.origin.x=leftX*2+r.size.width;
    self.otherBtn.frame=r;
    
    r=self.wifilab.frame;
    r.origin.x=(self.view.bounds.size.width-r.size.width*2)/3.0;
    self.wifilab.frame=r;
    
    r=self.otherlab.frame;
    r.origin.x=self.wifilab.frame.origin.x*2+r.size.width;
    self.otherlab.frame=r;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//wifi回拨设置
- (IBAction)WiFiCallBackSettingClick:(id)sender {
    UIButton *btn=(UIButton*)sender;
    [self setDialSettingWithButton:btn tipLabel:self.wifilab];
    [ConfigSettingHandler setWiFiCallBackOn:btn.selected];
}

//3g,4g回拨设置
- (IBAction)G4GCallBackSettingClick:(id)sender {
    UIButton *btn=(UIButton*)sender;
    [self setDialSettingWithButton:btn tipLabel:self.otherlab];
    [ConfigSettingHandler set3G4GCallBackOn:btn.selected];
}

//什么是回拨
- (IBAction)WhichIsCallBackClick:(id)sender {
    
}
//拨打设置
- (void)setDialSettingWithButton:(UIButton*)btn tipLabel:(UILabel*)lab{
    if (btn.selected) {
        lab.text=@"已关闭";
        btn.selected=NO;
        lab.textColor=[UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1.0];
    }else{
        lab.text=@"已开启";
        btn.selected=YES;
        lab.textColor=[UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0];
    }
}
//默认设置
- (void)setDefaultDialSettingWithButton:(UIButton*)btn tipLabel:(UILabel*)lab{
    if (btn.selected) {
        lab.text=@"已开启";
        lab.textColor=[UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0];
    }else{
        lab.text=@"已关闭";
        lab.textColor=[UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1.0];
    }
}
@end
