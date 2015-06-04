//
//  KcCardViewController.m
//  WldhMini
//
//  Created by zhaojun on 14-6-18.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "RechargeCardViewController.h"
#import "UIImage+CZExtend.h"
#import "CZRequestArgs.h"
#import "CZServiceManager.h"
#import "SVProgressHUD.h"

@interface RechargeCardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rechargeCardSecret;
@property (weak, nonatomic) IBOutlet UILabel *rechargeTip;

@end

@implementation RechargeCardViewController


- (id)init{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"MKRechargeSettingRecource" withExtension:@"bundle"]];
    if ((self = [super initWithNibName:@"RechargeCardViewController" bundle:bundle]))
    {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"充值卡";
    
 
    // Do any additional setup after loading the view from its nib.
    CGRect rect1 = self.inputText.frame;
    rect1.size.height += 17;
    self.inputText.frame = rect1;
    self.inputText.delegate=self;
    
    [self.submitBt setBackgroundImage:[UIImage createImageWithColor:[self getButtonNormalColor]] forState:UIControlStateNormal];
    [self.submitBt setBackgroundImage:[UIImage createImageWithColor:[self getButtonHighlightedColor]] forState:UIControlStateHighlighted];
    self.submitBt.layer.cornerRadius = 6.5f;
    self.submitBt.layer.masksToBounds = YES;
    
    self.cardInputImage.layer.borderWidth = 1.0;
    self.cardInputImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cardInputImage.layer.masksToBounds = YES;
    self.cardInputImage.layer.cornerRadius = 10.0;
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitAction:(id)sender {
    if (self.inputText.text.length > 0) {
         [self.inputText resignFirstResponder];
        
        
        NSString *cardPwd = [[self.inputText text]stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        CZRequestArgs *args=[[CZRequestArgs alloc] init];
        args.serviceType=RechargeType;
        [args paramWithObjectsAndKeys:args.userId,@"account",
         @"5",@"paytype",@"40010",@"goodsid",@"35",@"src",
         @"n",@"wmlflag",cardPwd,@"cardno",cardPwd,@"cardpwd",@"",@"subbank", nil];
        
        [SVProgressHUD showInView:self.navigationController.view status:@"数据提交中，请稍候..." networkIndicator:NO posY:-1 maskType:SVProgressHUDMaskTypeClear];
        
        [[CZServiceManager shareInstance] requestServiceWithArgs:args completed:^(NSDictionary *userInfo) {
            [self receiveRechargeData:userInfo];
        }];
   }
  else
  {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"卡密不能为空" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
  }
}
- (IBAction)backgroundTaped:(id)sender {
    [self.inputText resignFirstResponder];
}
- (void)receiveRechargeData:(NSDictionary *)dic
{
    int nRet = [[dic objectForKey:@"result"] intValue];
    NSString *str  = [dic objectForKey:@"reason"];
    switch (nRet)
    {
        case 0:
        {
            
            [SVProgressHUD dismissWithSuccess:@"充值成功"];
            [self rechargeSuccess];
        }
            break;
        default:
        {
            [SVProgressHUD dismissWithError: str afterDelay:2];
            self.inputText.text = @"";
            [self.inputText becomeFirstResponder];
        }
            break;
    }
    
}
- (void)rechargeSuccess
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"充值成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 111)
    {
        if (buttonIndex == 0) {

        }
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.inputText == textField) {
        [self.inputText resignFirstResponder];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ((range.location  ==4||range.location ==9||range.location  ==14||range.location ==19||range.location ==24) && string.length >0)
    {
        textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
    }
    return (range.location<17);
}

@end
