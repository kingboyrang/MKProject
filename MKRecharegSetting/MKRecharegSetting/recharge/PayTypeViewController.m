//
//  PayTypeViewController.m
//  WldhMini
//
//  Created by zhaojun on 14-6-19.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "PayTypeViewController.h"
#import "UPPayPlugin.h"
#import "AlixPayObj.h"
#import "RechargeCardYeePayViewController.h"
#import "SVProgressHUD.h"
#import "RechargeManager.h"
#import "AppConfigManager.h"
#import "PayTypeNode.h"
#import "PhoneInfo.h"
#import "CZServiceManager.h"
#import "ASIFormDataRequest.h"
#import "CostQueryDetailViewController.h"
#import "Md5Encrypt.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "PayConfigHandler.h"
#import "UPPayPluginDelegate.h"
#import "AlixPayObj.h"
#import "SystemUser.h"

#define MERCHANTID                      @"merchantId"
#define MERCHANTORDERID                 @"merchantOrderId"
#define MERCHANTORDERTIME               @"merchantOrderTime"
#define MERCHANTORDERSIGN               @"sign"
#define kRechargeSelectNetErrorTag      124
#define kRechargeAlertViewTag           1004
#define kRechargeSelectAlixPayTag       123
#define kRechargeSelectButtonTag        100


@interface PayTypeViewController ()<UPPayPluginDelegate>{
    NSString    *_orderNO;
    AlixPayObj   *_alixPayObject;
}
@property (nonatomic,strong) NSArray *listData;
@end

@implementation PayTypeViewController
@synthesize payTypeTable;


- (id)init{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"MKRechargeSettingRecource" withExtension:@"bundle"]];
    if ((self = [super initWithNibName:@"PayTypeViewController" bundle:bundle]))
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
    

    self.listData= [RechargeManager getRechargePayTypeList];
    payTypeTable.dataSource = self;
    payTypeTable.delegate = self;
    CGRect  rect1 = payTypeTable.frame;
    rect1.size.height = 55*self.listData.count + 20;
    payTypeTable.frame = rect1;
    
    if ([self.listData count]==0) {
        [AppConfigManager requestDefaultConfigWithCompleted:^(NSDictionary *userInfo) {
            NSArray *rechargeList=[RechargeManager getRechargePayTypeList];
            if ([rechargeList count]>0) {
                self.listData=rechargeList;
                CGRect  rect1 = payTypeTable.frame;
                rect1.size.height = 55*self.listData.count + 20;
                payTypeTable.frame = rect1;
                // 主线程执行：
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.view isKindOfClass:[UIScrollView class]]) {
                        UIScrollView * tempScroll = (UIScrollView *)self.view;
                        tempScroll.tag=500;
                        tempScroll.contentSize = CGSizeMake(320, 120 + payTypeTable.frame.size.height + 10);
                        self.view = tempScroll;
                    }
                    [payTypeTable reloadData];
                });
                
                
            }
        }];
        
    }
   
    self.titleLab.text=self.rechargeNode.name;

    //self.accountLab.text = [NSString stringWithFormat:@"%@      号",kAppPrefix];
    self.phoneNumLab.text = [SystemUser shareInstance].phone;

    payTypeTable.scrollEnabled = NO;
    UIScrollView * tempScroll = (UIScrollView *)self.view;
    tempScroll.tag=500;
    tempScroll.contentSize = CGSizeMake(320, 120 + payTypeTable.frame.size.height + 10);
    self.view = tempScroll;
    

   
}

-(void)viewWillAppear:(BOOL)animated
{
     self.title = @"充值方式";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)getBunddleImageWithName:(NSString*)name{
   NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"MKRechargeSettingRecource" withExtension:@"bundle"]];
    NSString *imgPath= [[bundle resourcePath] stringByAppendingPathComponent:name];
    return imgPath;
}

#pragma  mark
#pragma mark UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellWithIdentifier];
    }
    if(indexPath.row<[self.listData count])
    {
        PayTypeNode *cellNode = [self.listData objectAtIndex:indexPath.row];
        UIImage *tempImage;
        if ([cellNode.payKindStr isEqualToString:@"800"]) {
            tempImage = [UIImage imageNamed:[self getBunddleImageWithName:@"wx.png"]];
        }
        else
        {
            tempImage =[UIImage imageNamed:[self getBunddleImageWithName:cellNode.leftIconImageName]];
        }
        
        UIImageView *picImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 6, 43, 43)];
        picImage.image = tempImage;
        [cell addSubview:picImage];
        picImage.backgroundColor = [UIColor clearColor];
        
        CGFloat y;
        if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row ==4) {
            y = 17.5;
        }
        else y = 14;
        UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(85, y, 150, 20)];
        title1.backgroundColor = [UIColor clearColor];
        title1.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];     // [UIFont systemFontOfSize: 15.0];
        title1.text = cellNode.descStr;
        [cell addSubview:title1];
    
        if ([cellNode.payKindStr isEqualToString:@"704"]) {
            UILabel *sublab = [[UILabel alloc]initWithFrame:CGRectMake(85, 32, 180, 20)];
            sublab.backgroundColor = [UIColor clearColor];
            sublab.text = @"推荐已安装支付宝客户端用户使用";
            sublab.font = [UIFont systemFontOfSize:12.0];
            sublab.textColor = [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1.0];
            [cell addSubview:sublab];
        }
        if ([cellNode.payKindStr isEqualToString:@"707"]) {
            UILabel *sublab = [[UILabel alloc]initWithFrame:CGRectMake(85, 32, 180, 20)];
            sublab.backgroundColor = [UIColor clearColor];
            sublab.text = @"无需安装支付宝客户端直接使用";
            sublab.font = [UIFont systemFontOfSize:10.0];
             sublab.textColor = [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1.0];
            [cell addSubview:sublab];
        }
        if ([cellNode.payKindStr isEqualToString:@"800"]) {
            UILabel *sublab = [[UILabel alloc]initWithFrame:CGRectMake(85, 32, 180, 20)];
            sublab.backgroundColor = [UIColor clearColor];
            sublab.text = @"推荐微信5.0及以上版本使用";
            sublab.font = [UIFont systemFontOfSize:10.0];
            sublab.textColor = [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1.0];
            [cell addSubview:sublab];
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(85, 54, self.view.bounds.size.width-85, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        [cell  addSubview:line];
    }
    return  cell;
    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self payActionViewIndex:indexPath.row];
}
- (void)payActionViewIndex:(NSInteger)index
{
    PhoneNetType currentNetType = [[PhoneInfo sharedInstance] phoneNetType];
    if(index<[self.listData count])
    {
        PayTypeNode *cellNode = [self.listData objectAtIndex:index];
        if([cellNode.payKindStr isEqualToString:@"701"]
           ||[cellNode.payKindStr isEqualToString:@"702"]
           ||[cellNode.payKindStr isEqualToString:@"703"])
        {
            
            RechargeCardYeePayViewController *cardContro = [[RechargeCardYeePayViewController alloc] init];
            cardContro.rechargeNode = self.rechargeNode;
            cardContro.payKindStr=cellNode.payKindStr;
            cardContro.paytypeStr=cellNode.payTypeStr;
            if([cellNode.payKindStr isEqualToString:@"701"])
            {
               
                cardContro.isCMCard = YES;
            }
            else if([cellNode.payKindStr isEqualToString:@"702"])
            {
                cardContro.isCMCard = NO;
            }
            else
            {
            }
            if (self.navigationController) {
                [self.navigationController pushViewController:cardContro animated:YES];
            }else{
                [self presentViewController:cardContro animated:YES completion:nil];
            }
            
            return;
        }
        else if([cellNode.payKindStr isEqualToString:@"704"])  //支付宝客户端支付
        {
            if(PNT_UNKNOWN == currentNetType)
            {
                [self showNetErrorAlert];
                return;
            }
            [self AlixpayRechargeWithPayType: cellNode.payTypeStr payKindStr:cellNode.payKindStr];
            return;
        }
        else if([cellNode.payKindStr isEqualToString:@"707"])  //支付宝网页支付
        {
            if(PNT_UNKNOWN == currentNetType)
            {
                [self showNetErrorAlert];
                return;
            }
            [self AlixpayRechargeWithPayType: cellNode.payTypeStr payKindStr:cellNode.payKindStr];
            
           
            return;
        }
        else if([cellNode.payKindStr isEqualToString:@"705"])  //银联充值
        {
            if(PNT_UNKNOWN == currentNetType)
            {
                [self showNetErrorAlert];
                return;
            }
            //[self AlixpayRechargeWithPayType: cellNode.payTypeStr payKindStr:cellNode.payKindStr];
            [self AlixpayRechargeWithPayType:@"19" payKindStr:cellNode.payKindStr];
            
        }
        else if ([cellNode.payKindStr isEqualToString:@"800"]) //微信支付充值
        {
            if(PNT_UNKNOWN == currentNetType)
            {
                [self showNetErrorAlert];
                return;
            }
            [self AlixpayRechargeWithPayType: cellNode.payTypeStr payKindStr:cellNode.payKindStr];
            
        }
    }
}

//支付宝充值,银联，微信支付
-(void)AlixpayRechargeWithPayType:(NSString*)payType payKindStr:(NSString*)payKind
{
    CZRequestArgs *args=[[CZRequestArgs alloc] init];
    args.serviceType=RechargeType;
    [args paramWithObjectsAndKeys:args.userId,@"account",payType,@"paytype",self.rechargeNode.goods_id,@"goodsid",
     @"35",@"src",@"n",@"wmlflag",@"012345678901234",@"cardno",
     @"0123456789012345678",@"cardpwd",@"",@"subbank",nil];
    
    [SVProgressHUD showInView:self.view status:@"数据提交中，请稍候..." networkIndicator:NO posY:-1 maskType:SVProgressHUDMaskTypeClear];
    [[CZServiceManager shareInstance] requestServiceWithArgs:args completed:^(NSDictionary *userInfo) {
        [self receiveRechargeData:userInfo payKindStr:payKind];
    }];

    
}
#pragma mark - receive recharge data
/**
 *  @brief  接收支付返回数据
 *
 *  @param notification 通知
 */
- (void)receiveRechargeData:(NSDictionary *)dic payKindStr:(NSString*)payKind
{
    int nRet = [[dic objectForKey:@"result"] intValue];
    if([payKind isEqualToString:@"705"])
    {
        switch (nRet)
        {
            case 0:
            {
                [SVProgressHUD dismiss];
                [self requestUnionPay: dic];
            }
                break;
            default:
            {
                
                [SVProgressHUD dismissWithError:[dic objectForKey:@"reason"] afterDelay:2];
            }
                break;
        }
        
    }
    else if ([payKind isEqualToString:@"704"])
    {
        int nRet = [[dic objectForKey:@"result"] intValue];
        switch (nRet)
        {
            case 0:
            {
                [SVProgressHUD dismiss];
                NSString *notify_url=[dic objectForKey:@"notify_url"];
                _orderNO = [dic objectForKey: @"orderid"];
                
                [self requestAlixPay:notify_url];
                
            }
                break;
            default:
            {
                [SVProgressHUD dismissWithError: [dic objectForKey:@"reason"] afterDelay:2];
            }
                break;
        }
    }
    else if([payKind isEqualToString:@"707"])
    {
        int  resultInt =[[dic objectForKey:@"result"] intValue];
        switch (resultInt) {
            case 0:
            {
                [SVProgressHUD dismiss];
                
                NSDictionary *dataDic = [dic objectForKey:@"epayresult"];
                if(dataDic&& [dataDic count]>0)
                {
                    NSString *methodStr = [dataDic objectForKey:@"method"];
                    if(methodStr && [methodStr length]>0)
                    {
                        NSMutableArray *parasArray = [dataDic objectForKey:@"tags"];
                        NSString *parasStr = @"";
                        NSString *valueStr= @"";
                        ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:nil];
                        if(parasArray && [parasArray count]>0)
                        {
                            for(int i = 0;i<[parasArray count]-1;i++)
                            {
                                NSDictionary *dic = [parasArray objectAtIndex:i];
                                valueStr = [formDataRequest encodeURL:[self replaceUnicode:[dic objectForKey:@"value"]]];
                                parasStr =[parasStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",[self replaceUnicode:[dic objectForKey:@"name"]],valueStr]];
                                
                            }
                            NSDictionary *dic = [parasArray objectAtIndex:[parasArray count]-1];
                            valueStr  = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                           (CFStringRef)[self replaceUnicode:[dic objectForKey:@"value"]],
                                                                                           NULL,
                                                                                        CFSTR(":/?#[]@!$&’()*+,;="),
                                                                                           kCFStringEncodingUTF8));

                            
                             valueStr = [formDataRequest encodeURL:[self replaceUnicode:[dic objectForKey:@"value"]]];

                            parasStr =[parasStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",[self replaceUnicode:[dic objectForKey:@"name"]],valueStr]];
                            
                        }
                        if([methodStr isEqualToString:@"get"])
                        {
                            NSString *targetURL = [NSString stringWithFormat:@"%@%@",[dataDic objectForKey:@"url"],parasStr];
                            
                            CostQueryDetailViewController *tipWebViewController = [[CostQueryDetailViewController alloc] init];
                            tipWebViewController.requestURLString=targetURL;
                            tipWebViewController.title=@"支付宝网页支付";
                            tipWebViewController.showRightRefreshBtn=NO;
                            if (self.navigationController) {
                                [self.navigationController pushViewController:tipWebViewController animated:YES];
                            }else{
                                [self presentViewController:tipWebViewController animated:YES completion:nil];
                            }
                            
                            
                        }
                    }
                }
                break;
            }
            default:
            {
                [SVProgressHUD dismissWithError: [dic objectForKey:@"reason"] afterDelay:2];
            }
                break;
        }
    }
    else if ([payKind isEqualToString:@"800"]) //响应微信支付
    {
        int nRet = [[dic objectForKey:@"result"] intValue];
        switch (nRet)
        {
            case 0:
            {
                [self requestWxpay:dic];
            }
                break;
            default:
            {
                [SVProgressHUD dismissWithError: [dic objectForKey:@"reason"] afterDelay:2];
            }
                break;
        }
    }
}

#pragma mark - AlixPay Delegate
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    NSLog(@"Output = %@", returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

-(void)requestUnionPay: (NSDictionary *)dic
{

    NSString *strTN = nil;
    NSString *result = [dic objectForKey:@"result"];
    if ([result isEqual:@"0"]) {
        strTN = [dic objectForKey:@"bankOrderId"];
        //mode 接入模式设定，两个值：
        //@"00":代表接入生产环境（正式版本需要）；
        //@"01"：代表接入开发测试环境（测试版本需要）；
        [UPPayPlugin startPay:strTN mode:@"00" viewController:self delegate:self];
    }
    else
    {
        [SVProgressHUD dismissWithError:[dic objectForKey:@"result"] afterDelay:2];
    }
}


-(void)requestAlixPay:(NSString*)notifyURL
{
    _alixPayObject = [[AlixPayObj alloc] init];
    NSString *backName = @"";
    [_alixPayObject requestAlixPay:[self.rechargeNode moneyStr]
                         schemaStr:backName
                        orderIdStr:_orderNO
                         notifyURL:notifyURL];

}

#pragma mark - TCLUPPay Delegate
/**
 *  @brief 银联支付返回结果
 *
 *  @param result 结果
 */
- (void)UPPayPluginResult:(NSString*)result
{
    NSLog(@"UPPayPluginResult = %@", result);
    if([result isEqualToString:@"success"])
    {
        [self rechargeSuccess];
    }
}
//微信支付
- (void)requestWxpay:(NSDictionary *)dict
{

    [SVProgressHUD dismiss];
    WXPayConfig *config=[PayConfigHandler shareWXPayConfig];
    NSString *prepayId=dict[@"prepay_id"];
    NSDictionary *params=[config wxPaySignParamWithPrepayId:prepayId];
    
    //调起微信支付
    PayReq* req = [[PayReq alloc] init];
    req.openID = config.appId;
    req.partnerId = config.partnerId;
    req.prepayId = prepayId;
    req.nonceStr = [params objectForKey:@"noncestr"];
    req.timeStamp = [[params objectForKey:@"timestamp"] integerValue];
    req.package = [params objectForKey:@"package"];
    
    req.sign = [config wxPayMd5SignString:params];
    [WXApi sendReq:req];    //发送请求
}

/**
 *  @brief  弹出框代理
 *
 *  @param alertView   弹出框
 *  @param buttonIndex 点击的按钮的索引
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == kRechargeSelectAlixPayTag)
    {
        if(buttonIndex==0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/id333206289?mt=8"]];
        }
	}
    else if(kRechargeAlertViewTag == alertView.tag)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
            }
                break;
            case 1:
            {
                ///TODO 查询余额
            }
            default:
                break;
        }
    }
    else if(kRechargeSelectNetErrorTag  == alertView.tag)
    {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else if(alertView.tag == 111)
    {
        
    }
}

/**
 *  @brief  网络问题提醒
 */
- (void) showNetErrorAlert
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"请检查您的网络后重试"
                                                        delegate:self
                                               cancelButtonTitle:@"我知道了"
                                               otherButtonTitles:nil];
    [alertView setTag:kRechargeSelectNetErrorTag];
    [alertView show];
    
}


/**
 *  @brief  充值成功提醒
 */
- (void)rechargeSuccess
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"充值成功" delegate:self
                                         cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

/**
 *  @brief  客户端提醒
 *
 *  @param title 标题
 *  @param msg   内容
 */
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}

@end
