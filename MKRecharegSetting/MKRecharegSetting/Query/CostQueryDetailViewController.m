//
//  WSWebViewViewController.m
//  WldhWeishuo
//
//  Created by lonelysoul on 14-9-12.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "CostQueryDetailViewController.h"
#import "SVProgressHUD.h"

@interface CostQueryDetailViewController (){
    BOOL isSuccess;
    UIButton *refershBtn;
}

@end

@implementation CostQueryDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //添加webView
    self.webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate=self;
    [self.view addSubview:self.webView];
    
    if (self.showRightRefreshBtn) {
        if (self.navigationController) {
            UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
            aButton.frame = CGRectMake(0, 0, 40, 30);
            [aButton setTitle:@"刷新" forState:UIControlStateNormal];
            [aButton setTitleColor:[UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0] forState:UIControlStateNormal];
            [aButton setTitleColor:[UIColor colorWithRed:2/255.0 green:157/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
            [aButton addTarget:self action:@selector(goRefresh:) forControlEvents:UIControlEventTouchUpInside];
            [self.navigationItem setRightBarButtonItem:aBarButtonItem];
        }
    }
    [self loadWebView];
    
    
    //重新加载
    refershBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refershBtn.frame = self.webView.frame;
    [refershBtn setTitle:@"点击屏幕,重新加载" forState:UIControlStateNormal];
    [refershBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    refershBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16.0];
    [refershBtn addTarget:self action:@selector(goRefresh:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refershBtn];
    
    refershBtn.hidden = YES;
}

- (void)loadWebView
{
    NSURL *url = [NSURL URLWithString:self.requestURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

//刷新
- (void)goRefresh:(UIButton*)btn{
    if (![self.webView isLoading]) {
        if (isSuccess) {
            [self.webView reload];
        }else{
            [self loadWebView];
        }
    }
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showInView:self.view
                       status:@"正在加载..."
             networkIndicator:NO
                         posY:-1
                     maskType:SVProgressHUDMaskTypeClear];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    isSuccess=YES;
    refershBtn.hidden=YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    isSuccess=NO;
    refershBtn.hidden=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
