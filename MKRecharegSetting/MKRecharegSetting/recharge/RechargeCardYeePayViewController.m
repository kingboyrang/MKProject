//
//  RechargeCardViewController.m
//  WldhMini
//
//  Created by zhaojun on 14-6-19.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "RechargeCardYeePayViewController.h"
#import "UIImage+CZExtend.h"
#import "SVProgressHUD.h"
#import "RechargeViewController.h"
#import "CZServiceManager.h"
#define ltCardNoLenght 17
#define ltCardPWDLenght 12

#define kWldhIsIos7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)       //是否为ios7
#define kWldhIsRetain4  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)    //是否为4寸屏

@interface RechargeCardYeePayViewController ()
{
    NSInteger readyCount;
    NSInteger subCount;
    NSInteger failCount;
    NSTimer *timer;
    int      theta;
}

@end

@implementation RechargeCardYeePayViewController
@synthesize isCMCard,cardArr,pwdArr,isEditCardNO,isEditCardPWD,statesArr;


- (id)init{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"MKRechargeSettingRecource" withExtension:@"bundle"]];
    if ((self = [super initWithNibName:@"RechargeCardYeePayViewController" bundle:bundle]))
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
    
    cardArr = [NSMutableArray array];
    pwdArr = [NSMutableArray array];
    statesArr = [NSMutableArray array];
    readyCount = 0;
    failCount = 0;
    self.detailBt.hidden = YES;
    self.cardPWdText.delegate = self;
    self.cardNOText.delegate = self;
    self.failNumCount.hidden = YES;
    self.topTip.hidden = YES;
    self.rechargeFailImage.hidden = YES;
    self.actionView.hidden = NO;
    self.circleImage.hidden = YES;
    
    [self.meshuobtn setTitleColor:[UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.meshuobtn setTitleColor:[UIColor colorWithRed:2/255.0 green:151/255.0 blue:0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    
    CGRect rect = self.actionView.frame;
    rect.origin.y -= 39;
    self.actionView.frame = rect;
    
    
    CGRect rect1 = self.firstLine.frame;
    rect1.size.height = 0.5;
    self.firstLine.frame = rect1;
    
    CGRect rect2 = self.secondLine.frame;
    rect2.size.height = 0.5;
    self.secondLine.frame = rect2;
    
    CGRect rect3 = self.cardNOText.frame;
    rect3.size.height = 47;
    self.cardNOText.frame = rect3;
    self.cardNOText.layer.cornerRadius = 5.0;
    
    CGRect rect4 = self.cardPWdText.frame;
    rect4.size.height = 47;
    self.cardPWdText.frame = rect4;
    self.cardPWdText.layer.cornerRadius = 5.0;
    
    UIColor *corlor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    self.cardInputImage.backgroundColor = self.pwdinputImage.backgroundColor = [UIColor clearColor];
    self.cardInputImage.layer.borderWidth = self.pwdinputImage.layer.borderWidth = 1.f;
    self.cardInputImage.layer.borderColor = self.pwdinputImage.layer.borderColor = corlor.CGColor;
    self.cardInputImage.layer.cornerRadius = self.pwdinputImage.layer.cornerRadius = 6.5f;
    self.cardInputImage.layer.masksToBounds = self.pwdinputImage.layer.masksToBounds = YES;
    
    
    
    
    UIImage *callNormalBgImge = [UIImage createImageWithColor:[UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0]];
    UIImage *callDownBgImge = [UIImage createImageWithColor:[UIColor colorWithRed:2/255.0 green:151/255.0 blue:0/255.0 alpha:1.0]];
    
    [self.submitBt.layer setMasksToBounds:YES];
    [self.submitBt.layer setCornerRadius:8.0];   //设置矩形四个圆角半径
    [self.submitBt.layer setBorderWidth:0.0];    //
    
    
    [self.submitBt setBackgroundImage:callNormalBgImge forState:UIControlStateNormal];
    [self.submitBt setBackgroundImage:callDownBgImge forState:UIControlStateHighlighted];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCardChaged:)
                                                 name:@"cardChaged"
                                               object:nil];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) backContact
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!kWldhIsIos7)
    {
        if (isCMCard)
        {
            [self setDisplayCustomTitleText:@"移动卡充值" withviewcon:self];
        }else{
            [self setDisplayCustomTitleText:@"联通卡充值" withviewcon:self];
        }
        
    }else
    {
        if (isCMCard)
        {
            self.title = @"移动卡充值";
        }else{
            self.title = @"联通卡充值";
        }
    }
    
    
    
    if (isCMCard) {
        //self.title = @"移动卡充值";
        self.cardNOCount.text = nil;
        self.pwdCount.text = nil;
        
    }
    else
    {
        //self.title = @"联通卡充值";
        self.cardNOText.placeholder = @"请输入15位序列号";
        self.cardPWdText.placeholder = @"请输入19位密码";

    }
    self.moneyLab.text = [NSString stringWithFormat:@"%@元",[self.rechargeNode moneyStr]];
}

- (IBAction)addCardAction:(id)sender {
    
//    [self.view endEditing:YES];
    [self.cardPWdText resignFirstResponder];
    [self.cardNOText resignFirstResponder];
    if (self.view.frame.origin.y != 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, 64, 320, self.view.bounds.size.height);
        }completion:nil];
    }
    
    isEditCardPWD = [self.cardPWdText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    isEditCardNO = [self.cardNOText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ((!isCMCard) && ((isEditCardNO.length != 15) || (isEditCardPWD.length != 19))) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的卡号和密码" message:@"联通卡卡号为15位，密码为19位。请正确的输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
            [alert show];
    }
    else if((isEditCardPWD.length != 0)&&(isEditCardNO.length != 0))
    {
        [cardArr addObject:isEditCardNO];
        [pwdArr addObject:isEditCardPWD];
        self.cardNOText.text = nil;
        self.cardPWdText.text = nil;
        self.pwdCount.text = @"0";
        self.cardNOCount.text = @"0";
        readyCount ++;
        self.cardNum.text = [NSString stringWithFormat:@"%d",readyCount];
        self.detailBt.hidden = NO;
       
        self.cardNum.textColor = [UIColor blueColor];
        if (self.topTip.hidden) {
            self.topTip.hidden = NO;
            CGRect rect = self.actionView.frame;
            rect.origin.y += 39;
            self.actionView.frame = rect;
        }
        [self.cardNOText becomeFirstResponder];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的卡号和密码" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(void)teleButtonEvent:(id) sender
{
    [self.cardPWdText resignFirstResponder];
    [self.cardNOText resignFirstResponder];
    if (self.view.frame.origin.y != 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, 64, 320, self.view.bounds.size.height);
        }completion:nil];
    }
    
    isEditCardPWD = [self.cardPWdText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    isEditCardNO = [self.cardNOText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ((!isCMCard) && ((isEditCardNO.length != 15) || (isEditCardPWD.length != 19))) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的卡号和密码" message:@"联通卡卡号为15位，密码为19位。请正确的输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    }
    else if((isEditCardPWD.length != 0)&&(isEditCardNO.length != 0))
    {
        [cardArr addObject:isEditCardNO];
        [pwdArr addObject:isEditCardPWD];
        self.cardNOText.text = nil;
        self.cardPWdText.text = nil;
        self.pwdCount.text = @"0";
        self.cardNOCount.text = @"0";
        readyCount ++;
        self.cardNum.text = [NSString stringWithFormat:@"%d",readyCount];
        self.detailBt.hidden = NO;
        
        self.cardNum.textColor = [UIColor blueColor];
        if (self.topTip.hidden) {
            self.topTip.hidden = NO;
            CGRect rect = self.actionView.frame;
            rect.origin.y += 39;
            self.actionView.frame = rect;
        }
        [self.cardNOText becomeFirstResponder];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的卡号和密码" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    }


}


- (IBAction)backgroundTaped:(id)sender {
    [self.cardPWdText resignFirstResponder];
    [self.cardNOText resignFirstResponder];
    if (self.view.frame.origin.y != 0) {
        [UIView animateWithDuration:0.2 animations:^{
            if (kWldhIsIos7)
            {
                 self.view.frame = CGRectMake(0, 64, 320, self.view.bounds.size.height);
            }else{
                self.view.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
            }
           
        }completion:nil];
    }

}

- (IBAction)subAction:(id)sender {
    
    if([self.payKindStr isEqualToString:@"701"])
    {
        
    }
    else
    {
       
        
    }
    [statesArr removeAllObjects];
    failCount = 0;
    [self.cardNOText resignFirstResponder];
    [self.cardPWdText resignFirstResponder];
    [self backgroundTaped:nil];

//    [self performSelector:@selector(preparePayAction) withObject:nil afterDelay:0.6];
    [self preparePayAction];

}

-(void)preparePayAction
{
    isEditCardPWD = [self.cardPWdText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    isEditCardNO = [self.cardNOText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!isCMCard) {
        if (((readyCount == 0) && ((isEditCardNO.length != 15) || (isEditCardPWD.length != 19)))) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的卡号和密码" message:@"联通卡卡号为15位，密码为19位。请正确的输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
            [alert show];
        }
        else if ((readyCount != 0) && !((isEditCardNO.length == 0 && isEditCardPWD.length == 0) ||(isEditCardNO.length == 15 && isEditCardPWD.length == 19)))
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的卡号和密码" message:@"联通卡卡号为15位，密码为19位。请正确的输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            if ((isEditCardNO.length == 15) && (isEditCardPWD.length == 19)) {
                [cardArr addObject:isEditCardNO];
                [pwdArr addObject:isEditCardPWD];
            }
            
            if (cardArr.count == 0 || pwdArr == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请确定您已经输入了正确的卡号密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
            self.cardNOText.text = nil;
            self.cardPWdText.text = nil;
            self.pwdCount.text = @"(0/19)";
            self.cardNOCount.text = @"(0/15)";
            readyCount  = cardArr.count;
            self.detailBt.hidden = NO;
            self.cardTipLab.text = @"已提交       张";
            self.cardNum.text = [NSString stringWithFormat:@"0/%d",readyCount];
            subCount = readyCount;
            [self payAction];

        }

    }else
    {
        if((isEditCardPWD.length != 0)&&(isEditCardNO.length != 0))
        {
            [cardArr addObject:isEditCardNO];
            [pwdArr addObject:isEditCardPWD];
             readyCount ++;

        }
        if (cardArr.count == 0 || pwdArr == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请确定您已经输入了正确的卡号密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        self.cardNOText.text = nil;
        self.cardPWdText.text = nil;
        self.pwdCount.text = @"0";
        self.cardNOCount.text = @"0";
        
        self.detailBt.hidden = NO;
        self.cardTipLab.text = @"已提交       张";
        self.cardNum.text = [NSString stringWithFormat:@"0/%d",readyCount];
        subCount = readyCount;
        [self payAction];
        
    }
}

-(void)payAction
{
    
    CZRequestArgs *args=[[CZRequestArgs alloc] init];
    args.serviceType=RechargeType;
    [args paramWithObjectsAndKeys:args.userId,@"account",self.paytypeStr,@"paytype",
     self.rechargeNode.goods_id,@"goodsid",@"56",@"src",@"n",@"wmlflag",
     [cardArr objectAtIndex:(subCount -1)],@"cardno",[pwdArr objectAtIndex:(subCount-1)],@"cardpwd",
     @"",@"subbank",nil];
    
   
    [SVProgressHUD showInView:self.navigationController.view status:@"数据提交中，请稍候..." networkIndicator:NO posY:-1 maskType:SVProgressHUDMaskTypeClear];
    [[CZServiceManager shareInstance] requestServiceWithArgs:args completed:^(NSDictionary *userInfo) {
        [self receiveUnAppRechargeData:userInfo];
    }];
    self.circleImage.hidden = NO;
    [self start:nil];
    
}


- (void)receiveUnAppRechargeData:(NSDictionary *)dic
{
   
    int nRet = [[dic objectForKey:@"result"] intValue];
    NSString *str  = [dic objectForKey:@"reason"];
    [self stop:nil];
    self.circleImage.hidden = YES;
    switch (nRet)
    {
        case 0:
        {
            [SVProgressHUD dismiss];
            self.cardNum.text = [NSString stringWithFormat:@"%d/%d",readyCount-subCount,readyCount];
            [statesArr addObject:@"yes"];
        }
            break;
        default:
        {
            [SVProgressHUD dismissWithError: str afterDelay:2];
            [statesArr addObject:@"no"];
            failCount ++;
            self.failNumCount.hidden = NO;
            self.rechargeFailImage.hidden = NO;
            self.detailBt.hidden = YES;
             self.cardNum.text = [NSString stringWithFormat:@"%d/%d",readyCount-subCount,readyCount];
            [self.failNumCount setTitle:[NSString stringWithFormat:@"失败%d张>",failCount] forState:UIControlStateNormal];
            [self.failNumCount setTitle:[NSString stringWithFormat:@"失败%d张>",failCount] forState:UIControlStateHighlighted];
        }
            break;
    }
    subCount--;
    if (subCount > 0) {
        [self payAction];
    }
    else
    {
        self.failNumCount.hidden = NO;
        self.detailBt.hidden = YES;
         self.cardNum.text = [NSString stringWithFormat:@"%d/%d",readyCount-subCount,readyCount];
        [self.failNumCount setTitle:[NSString stringWithFormat:@"失败%d张>",failCount] forState:UIControlStateNormal];
        [self.failNumCount setTitle:[NSString stringWithFormat:@"失败%d张>",failCount] forState:UIControlStateHighlighted];
        self.rechargeFailImage.hidden = NO;
        
        if (failCount == 0) {

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"  message:@"提交充值成功，请稍后查询余额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 111;
            [alert show];

        }
        else
        {
            NSString *resultStr =    [NSString stringWithFormat:@"一共提交%d张,失败%d张",readyCount,failCount];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"数据提交完成" message:resultStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    
}
-(void)receiveCardChaged:(NSNotification *)notification
{
     NSDictionary *dic = [notification userInfo];
    if (dic) {
        self.cardArr = [dic objectForKey:@"card"];
        self.pwdArr = [dic objectForKey:@"pwd"];
    }
    
}


#pragma mark - uitextfeld delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!kWldhIsRetain4) {
        if (textField == self.cardNOText) {
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0, -12, 320, self.view.bounds.size.height);
            }completion:nil];
        }
        else
        {
//            [UIView animateWithDuration:0.2 animations:^{
//                self.view.frame = CGRectMake(0, -40, 320, self.view.bounds.size.height);
//            }completion:nil];
        }
    }
    else{
        if (textField == self.cardPWdText) {
            [UIView animateWithDuration:0.2 animations:^{
                self.view.frame = CGRectMake(0, -20, 320, self.view.bounds.size.height);
            }completion:nil];
        }
    }
    


}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text = @"";
    if (!isCMCard)
    {
        if (textField == self.cardNOText) {
            //int i = self.cardNOText.text.length;
            self.cardNOCount.text = [NSString stringWithFormat:@"(0/15)"];
        }
        else
        {
            //int i = self.cardPWdText.text.length;
            self.pwdCount.text = [NSString stringWithFormat:@"(0/19)"];
        }
    }
    else if (isCMCard)
    {
        if (textField == self.cardNOText) {
            //int i = self.cardNOText.text.length;
            self.cardNOCount.text = [NSString stringWithFormat:@"(0)"];
        }
        else
        {
            //int i = self.cardPWdText.text.length;
            self.pwdCount.text = [NSString stringWithFormat:@"(0)"];
        }

    }
    else
    {
        // do thing
    }

    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (string.length > 0) {
        if (!isCMCard) {
            if (textField == self.cardNOText) {
               NSString * tempStr = [self.cardNOText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (tempStr.length >= 15  ) {
                    return NO;
                }
                int i = tempStr.length;
                self.cardNOCount.text = [NSString stringWithFormat:@"(%d/15)",i + 1];
                
            }
            else
            {
              NSString *tempStr  = [self.cardPWdText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (tempStr.length >= 19) {
                    return NO;
                }
                int i = tempStr.length;
                self.pwdCount.text = [NSString stringWithFormat:@"(%d/19)",i + 1];
            }
        }
        else
        {
            if (textField == self.cardNOText) {
                NSString * tempStr = [self.cardNOText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
                int i = tempStr.length+1;
                self.cardNOCount.text = [NSString stringWithFormat:@"(%d)",i];
            }
            else
            {
                NSString * tempStr = [self.cardPWdText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                int i = tempStr.length+1;
                self.pwdCount.text = [NSString stringWithFormat:@"(%d)",i];
            }
        }
    }
    
    NSLog(@"rang.loc = %d",range.location);
    if (string.length > 0) {
        if ((range.location+1)%5 == 0) {
            textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
        }
    }
    else
    {
        if (isCMCard) {
        
            if (range.location%5 == 0) {
                textField.text = [textField.text substringToIndex:range.location];
                if (textField == self.cardNOText) {
                    NSString * tempStr = [self.cardNOText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    int i = tempStr.length;
                    self.cardNOCount.text = [NSString stringWithFormat:@"(%d)",i];
                }
                else
                {
                    NSString * tempStr = [self.cardPWdText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    int i = tempStr.length;
                    self.pwdCount.text = [NSString stringWithFormat:@"(%d)",i];
                }
                
            }
            else {
            if (textField == self.cardNOText) {
                NSString * tempStr = [self.cardNOText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                int i = tempStr.length-1;
                self.cardNOCount.text = [NSString stringWithFormat:@"(%d)",i];
            }
            else
            {
                NSString * tempStr = [self.cardPWdText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                int i = tempStr.length-1;
                self.pwdCount.text = [NSString stringWithFormat:@"(%d)",i];
            }
            
            }}
        else
        {
            if (textField == self.cardNOText) {
                NSString * tempStr = [self.cardNOText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                int i = tempStr.length;
                self.cardNOCount.text = [NSString stringWithFormat:@"(%d/15)",i];
            }
            else
            {
                NSString *tempStr  = [self.cardPWdText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                int i = tempStr.length;
                self.pwdCount.text = [NSString stringWithFormat:@"(%d/19)",i];
            }
        }
        
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
    }completion:nil];
    return YES;
}

- (IBAction)goDetailAction:(id)sender {
    CardDetailViewController * detailContro = [[CardDetailViewController alloc] init];
    detailContro.isFailAction = NO;
    detailContro.cardArr = self.cardArr;
    detailContro.pwdArr = self.pwdArr;
    [self.navigationController pushViewController:detailContro animated:YES];
    
}
- (IBAction)goSeefail:(id)sender {
    CardDetailViewController * detailContro = [[CardDetailViewController alloc] init];
    detailContro.isFailAction = YES;
    detailContro.cardArr = self.cardArr;
    detailContro.pwdArr = self.pwdArr;
    detailContro.statesArr = self.statesArr;
    [self.navigationController pushViewController:detailContro animated:YES];
}

- (void) start: (id) sender
{
	timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(move:) userInfo:nil repeats:YES];
	[self move:nil];
}

- (void) stop: (id) sender
{
	[timer invalidate];
	timer = nil;
}

- (void) move: (NSTimer *) aTimer
{
	// Rotate each iteration by 1% of PI
    CGFloat angle = theta * (M_PI / 100.0f);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    
	// Theta ranges between 0% and 199% of PI, i.e. between 0 and 2*PI
	theta = (theta + 1) % 200;
    
    // For fun, scale by the absolute value of the cosine
    float degree = cos(angle);
    if (degree < 0.0) degree *= -1.0f;
    degree += 0.5f;
	
	// Create add scaling to the rotation transform
    CGAffineTransform scaled = CGAffineTransformScale(transform, degree, 0);
	
    // Apply the affine transform
    [self.circleImage setTransform:transform];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 111)
    {
//        if (buttonIndex == 0) {
//            VerifyPhoneViewController *verifyPhoneViewController = [[VerifyPhoneViewController alloc] init];
//            verifyPhoneViewController.isResetPwd = NO;
//            verifyPhoneViewController.isBindPhone = NO;
//            verifyPhoneViewController.isFromRegist = NO;
//            verifyPhoneViewController.isValityPhone = YES;
//            verifyPhoneViewController.phoneNum = [WldhUtils getLocalStringDataValue:kWldhDataKeyUserPhone];
//            [self presentModalViewController:verifyPhoneViewController animated:YES];
//        }
        
        self.cardNOText.text = self.cardPWdText.text = @"";
        
    }
}
- (void)setDisplayCustomTitleText:(NSString*)text withviewcon:(UIViewController *) viewcon

{
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    titleView.autoresizesSubviews = YES;
    titleView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.lineBreakMode = UILineBreakModeClip;
    CGRect leftViewbounds = viewcon.navigationItem.leftBarButtonItem.customView.bounds;
    CGRect rightViewbounds = viewcon.navigationItem.rightBarButtonItem.customView.bounds;
    CGRect frame;
    CGFloat maxWidth = leftViewbounds.size.width > rightViewbounds.size.width ? leftViewbounds.size.width : rightViewbounds.size.width;
    frame = titleLabel.frame;
    frame.size.width = 320 - maxWidth * 2;
    titleLabel.frame = frame;
    frame = titleView.frame;
    frame.size.width = 320 - maxWidth * 2;
    titleView.frame = frame;
    titleLabel.text = text;
    [titleView addSubview:titleLabel];
    viewcon.navigationItem.titleView = titleView;
    
}
@end
