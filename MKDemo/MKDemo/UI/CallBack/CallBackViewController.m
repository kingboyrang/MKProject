//
//  CallBackViewController.m
//  MKDemo
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "CallBackViewController.h"
#import "MKCallBackManager.h"
#import "CZRequestHandler.h"
#import "CZServiceManager.h"
#import "CZRequestArgs.h"
#import "Md5Encrypt.h"

#import "ContactUtils.h"

@interface CallBackViewController ()

@property (nonatomic,strong) UIButton *callBackBtn;
@property (nonatomic,strong) UITextField *phoneNumberTextField;

@property (nonatomic,strong) MKCallBackManager *callBackManager;

@end

@implementation CallBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 280, 44)];
    self.phoneNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneNumberTextField.placeholder = @"请输入手机号码";
    self.phoneNumberTextField.textAlignment = NSTextAlignmentCenter;
    self.phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneNumberTextField];
    
    self.callBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callBackBtn.frame = CGRectMake(100, 140, 120, 40);
    [self.callBackBtn setTitle:@"回拨" forState:UIControlStateNormal];
    [self.callBackBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.callBackBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.callBackBtn.layer.borderWidth = 1.0;
    self.callBackBtn.layer.masksToBounds = YES;
    self.callBackBtn.layer.cornerRadius = 5.0;
    [self.callBackBtn addTarget:self action:@selector(startCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.callBackBtn];
    
    
}

- (void)startCallBack:(UIButton *)sender
{
    [self.phoneNumberTextField resignFirstResponder];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MKConfig" ofType:@"plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *httpMainServer = [dict objectForKey:@"kWldhDataKeyServerAddress"];
    NSLog(@"mainServer=%@",httpMainServer);
    
    self.callBackManager = [MKCallBackManager shareInstance];
    self.callBackManager.calleePhoneNumber = self.phoneNumberTextField.text;
    self.callBackManager.calleeName = [ContactUtils getContactNameByPhone:self.phoneNumberTextField.text];
    self.callBackManager.calleePhonePlace = [ContactUtils getPlaceByPhone:self.phoneNumberTextField.text];
    [self.callBackManager startCallBackInsertRecordblock:^{
        [ContactUtils insertOneCallRecord:self.phoneNumberTextField.text];
    }];
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
