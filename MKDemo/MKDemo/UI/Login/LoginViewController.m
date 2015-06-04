//
//  LoginViewController.m
//  MKDemo
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "LoginViewController.h"
#import "CZRequestHandler.h"
#import "CZServiceManager.h"
#import "CZRequestArgs.h"
#import "Md5Encrypt.h"
#import "WSPromptHUD.h"
#import "WldhDBManager.h"

#import "MKCallBackManager.h"
#import "SystemUser.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *phoneNumberTextField;
@property (nonatomic,strong) UITextField *passwordTextField;
@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UILabel *uidLabel;
@property (nonatomic,strong) UILabel *pwdLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    self.phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, [UIScreen mainScreen].bounds.size.width-40, 44)];
    self.phoneNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneNumberTextField.delegate = self;
    self.phoneNumberTextField.placeholder = @"请输入手机号码";
    self.phoneNumberTextField.textAlignment = NSTextAlignmentCenter;
    self.phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneNumberTextField];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 130, [UIScreen mainScreen].bounds.size.width-40, 44)];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.delegate = self;
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.textAlignment = NSTextAlignmentCenter;
    self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:self.passwordTextField];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-120)*0.5, 200, 120, 40);
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.loginButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.loginButton.layer.borderWidth = 1.0;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 5.0;
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 280, 32)];
    [self.view addSubview:self.phoneLabel];
    self.uidLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 350, 280, 32)];
    [self.view addSubview:self.uidLabel];
    self.pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 280, 32)];
    [self.view addSubview:self.pwdLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.title = @"登录";
    SystemUser *user = [SystemUser shareInstance];
    if (user.isLogin) {
        self.phoneLabel.text = user.name;
        self.uidLabel.text = user.userId;
        self.pwdLabel.text = user.password;
    }
}

- (void)login:(UIButton *)sender
{
    if (self.passwordTextField.text.length < 6 || self.phoneNumberTextField.text.length == 0) {
        [WSPromptHUD showInView:self.view
                           info:@"请输入正确的用户名和密码"
                       isCenter:YES];
        return;
    }
    
    CZRequestArgs *args=[[CZRequestArgs alloc] init];
    args.serviceType = CZServiceLogin;
    
    [args paramWithObjectsAndKeys:self.phoneNumberTextField.text,@"account",[Md5Encrypt md5:self.passwordTextField.text],@"passwd",@"iPhone_5",@"ptype",@"wifi",@"netmode", nil];
    [[CZServiceManager shareInstance] requestServiceWithArgs:args completed:^(NSDictionary *userInfo) {
        
        [WSPromptHUD showInView:self.view
                           info:[userInfo objectForKey:@"reason"]
                       isCenter:YES];
        
        NSNumber *result = userInfo[@"result"];
        NSLog(@"userInfo=%@",userInfo);
        if ([result integerValue] == 0) {
            
            /**   登陆用户信息保存  **/
            SystemUser *mod = [[SystemUser alloc] init];
            mod.name=self.phoneNumberTextField.text;
            mod.userId=userInfo[@"uid"];
            mod.password=self.passwordTextField.text;
            mod.phone=userInfo[@"mobile"];
            mod.isLogin=YES;
            [mod saveUser];
            
            self.phoneLabel.text = [NSString stringWithFormat:@"帐号：%@",mod.name];
            self.uidLabel.text = [NSString stringWithFormat:@"uid：%@",mod.userId];
            self.pwdLabel.text = [NSString stringWithFormat:@"密码：%@",mod.password];
            
            //创建用户数据库
            [[WldhDBManager shareInstance] createUserDatabase:mod.userId];
        }
        //清空数据
        self.phoneNumberTextField.text = nil;
        self.passwordTextField.text = nil;
        [self.phoneNumberTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
