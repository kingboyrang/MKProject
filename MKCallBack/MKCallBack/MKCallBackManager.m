//
//  MKCallBackManager.m
//  MKCallBack
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKCallBackManager.h"
#import "MKCallBackView.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "CZRequestHandler.h"
#import "CZRequestConfig.h"
#import "CZServiceManager.h"
#import "CZRequestArgs.h"
#import "PhoneInfo.h"

#import "ConfigSettingHandler.h"
#import "SystemUser.h"

static AVAudioPlayer *gAudioPlayer = nil;

@interface MKCallBackManager ()
@property (nonatomic,strong) MKCallBackView *callBackView;

//呼叫人的UID
@property (nonatomic,copy) NSString *callerUid;
//呼叫人密码
@property (nonatomic,copy) NSString *callerPwd;
//品牌
@property (nonatomic,copy) NSString *brandId;
//服务器地址
@property (nonatomic,copy) NSString *mainHttpServerAddress;
//呼叫人的电话号码
@property (nonatomic,copy) NSString *callerPhoneNumber;

@end

@implementation MKCallBackManager

/**
 *  @brief  设置回拨需要的参数
 *
 *  @param uid   uid
 *  @param pwd   密码
 *  @param bid   品牌id
 *  @param srv   主服务器地址
 *  @param phone 手机号码
 *
 */
- (void)setUid:(NSString *)uid password:(NSString *)pwd brandId:(NSString *)bid serverAddr:(NSString *)srvAddr phone:(NSString *)phoneNum
{
    self.callerUid = uid;
    self.callerPwd = pwd;
    self.brandId = bid;
    self.mainHttpServerAddress = srvAddr;
    self.callerPhoneNumber = phoneNum;
}

// 单列模式
+ (MKCallBackManager *)shareInstance{
    static MKCallBackManager *instance;
    @synchronized(self)
    {
        if(!instance)
        {
            instance = [[MKCallBackManager alloc] init];
        }
    }
    return instance;
}

/**
 *  @brief  开始回拨
 */
- (void)startCallBackInsertRecordblock:(CallbackSuccess)block
{
    //wifi下回拨和3g/4g下回拨都关闭了
    if (![ConfigSettingHandler isWiFiCallBackOn] && ![ConfigSettingHandler is3G4GCallBackOn]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请设置拨打方式" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //设置wifi下回拨且当前网络不是wifi，回拨失败
    if ([ConfigSettingHandler isWiFiCallBackOn] && [PhoneInfo sharedInstance].phoneNetType!=PNT_WIFI) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不是Wifi" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //设置3G/4G下回拨且当前网络不是3G/4G，回拨失败
    if ([ConfigSettingHandler is3G4GCallBackOn] && [PhoneInfo sharedInstance].phoneNetType!=PNT_2G3G) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不是3G/4G" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![[SystemUser shareInstance] isLogin]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请登录后重试" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![self isPhoneNumber:self.calleePhoneNumber]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该号码不是合法的手机号码，请重试" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if([PhoneInfo sharedInstance].phoneNetType==PNT_UNKNOWN)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络后请重试" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //显示回拨界面
    self.callBackView = [[MKCallBackView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                   calleeName:self.calleeName
                                                 calleeNumber:self.calleePhoneNumber
                                                  calleePlace:self.calleePhonePlace
                                                 callerNumber:[SystemUser shareInstance].phone
                                                    isVipUser:NO];
    [[[UIApplication sharedApplication] delegate].window addSubview:self.callBackView];
    
    //请求回拨
    CZRequestArgs *args = [[CZRequestArgs alloc] init];
    args.serviceType = CZServiceBackCall;
    args.userId = [SystemUser shareInstance].userId;
    args.requestSign.password = [SystemUser shareInstance].password;
    [args paramWithObjectsAndKeys:self.calleePhoneNumber, @"callee",nil];
    
    [[CZServiceManager shareInstance] requestServiceWithArgs:args completed:^(NSDictionary *userInfo) {
        NSLog(@"callback userInfo=%@",userInfo);
        id result = [userInfo objectForKey:@"result"];
        NSInteger resultint = [result intValue];
        NSString *reason = [userInfo objectForKey:@"reason"];
        if (resultint == 0)     //回拨成功
        {
            NSLog(@"记录详情发起的回拨成功!");
            [self playBigResourceSound:@"call7"
                         withExtension:@"mp3"
                       withRepeatTimes:0
                     playOnLoudSpeaker:YES
                            withVolume:1.0];
        }
        else
        {
            if(resultint == 17)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                    message:@"输入被叫号码格式错误"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"确定", nil] ;
                [alertView show];
            }
            else if (resultint == 16)
            {
                [self playBigResourceSound:@"call9"
                             withExtension:@"mp3"
                           withRepeatTimes:0
                         playOnLoudSpeaker:YES
                                withVolume:1.0];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"你的账户没有话费，建议赚话费后拨打"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"赚话费", nil] ;
                alertView.tag=12345;
                [alertView show];
            }
            else if (resultint==14) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                    message:@"需要绑定手机才能拨打"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"确定", nil] ;
                alertView.tag=30000;
                [alertView show];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:reason
                                                                   delegate:nil
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"确定", nil] ;
                [alertView show];
            }
            
        }
        [UIDevice currentDevice].proximityMonitoringEnabled = NO;
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        
        //这里插入通话记录
        InsertRecordBlock = block;
        InsertRecordBlock();
        
        [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(dismissCallbackView) userInfo:nil repeats:NO];
    }];
}

/**
 *  @brief  移除回拨等待界面
 */
- (void)dismissCallbackView
{
    [self.callBackView removeFromSuperview];
}

/**
 *  @brief  播放语音提示
 *
 *  @param strFileName  文件名
 *  @param strExtension 文件类型
 *  @param nTimes       循环次数
 *  @param bLoudSpeaker 是否扬声器播放
 *  @param fVolume      音量
 */
- (void)playBigResourceSound:(NSString *)strFileName
              withExtension :(NSString *)strExtension
             withRepeatTimes:(int)nTimes
           playOnLoudSpeaker:(BOOL)bLoudSpeaker
                  withVolume:(float)fVolume
{
    if (0 == [strFileName length])
    {
        return;
    }
    
    if (![ConfigSettingHandler isSpeechRemindOn]) {
        return;
    }
    
    if (nil != gAudioPlayer)
    {
        [gAudioPlayer stop];
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MKCallBackResources" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    NSString *VolPath = [bundle pathForResource:strFileName ofType:strExtension];
    NSURL *fileURL = [NSURL URLWithString:VolPath];
    
    gAudioPlayer = nil;
    gAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    gAudioPlayer.volume = fVolume;
    [gAudioPlayer prepareToPlay];
    gAudioPlayer.numberOfLoops = nTimes;
    [gAudioPlayer play];
}


/**
 *  @brief  替换特殊字符
 *
 *  @param phoneNum 手机号码
 *
 *  @return 替换后的字符串
 */
- (NSString *)replaceSpecialCharacterInPhoneNumber:(NSString *)phoneNum
{
    if (0 == [phoneNum length])
    {
        return @"";
    }
    
    NSString *str = [NSString stringWithFormat:@"%@",phoneNum];
    
    str  = [str stringByReplacingOccurrencesOfString:@"!" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"*" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"'" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@";" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"&" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"=" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"$" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"/" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"?" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"%" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"#" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"[" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 去掉'-'
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return str;
}

/**
 *  @brief  处理手机号码
 *
 *  @param strPhoneNumber 需要处理的手机号字符串
 *  @param bflag          是否中国手机号
 *
 *  @return 处理后的手机号
 */
- (NSString *)dealWithPhoneNumber:(NSString *)strPhoneNumber isChineAccount:(BOOL)bflag
{
    NSString *strReault = [strPhoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 去掉'-'
    strReault = [strReault stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    // 判断账号是中国的，则要去掉+86，0086，17951等前缀
    if (bflag)
    {
        // 去掉'+86'
        if ([strReault hasPrefix:@"+86"])
        {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
        }
        else if ([strReault hasPrefix:@"0086"])// 去掉号码前面加的"0086"
        {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""];
        }
        else if ([strReault hasPrefix:@"12593"])// 去掉号码前面加的"12593"
        {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
        else if ([strReault hasPrefix:@"17951"])// 去掉号码前面加的"17951"
        {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
        else if ([strReault hasPrefix:@"17911"])// 去掉号码前面加的"17911"
        {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
    }
    
    strReault = [self replaceSpecialCharacterInPhoneNumber:strReault];
    
    return strReault;
}

/**
 *  @brief  是否合法的手机号码
 *
 *  @param strPhoneNum 需要判断的手机号码
 *
 *  @return yes表示合法，no表示不合法
 */
- (BOOL)isMobileNumber:(NSString *)strPhoneNum
{
    /*
     判断规则
     1.为11位数字
     2.以1开头
     3.连续数字不会超过6位,例如：不包含123456、23456这样的连续数字
     4.同样数字连续不能出现6次 例如：不包含111111、222222、333333、444444
     */
    
    //判断位数
    if (11 != [strPhoneNum length])
    {
        return NO;
    }
    
    //首位是否为1
    if (![strPhoneNum hasPrefix:@"1"])
    {
        return NO;
    }
    
    char theSameNum = [strPhoneNum characterAtIndex:0];
    int  sameCount = 1;
    int countinueCount = 1;
    int lastResult = 0;
    
    for (int i = 1; i < [strPhoneNum length]; ++i)
    {
        char c = [strPhoneNum characterAtIndex:i];
        
        //判断是否为数字
        if (c < '0' || c > '9')
        {
            return NO;
        }
        
        //判断相同数字
        if (c == theSameNum)
        {
            ++sameCount;
            if (sameCount >= 6)
            {
                return NO;
            }
        }
        else
        {
            sameCount = 1;
            theSameNum = c;
        }
        
        //判断连续数字
        int result = c - [strPhoneNum characterAtIndex:i - 1];
        
        //前后两个数字相差1，才为连续数字
        if (result == 1 || result == -1)
        {
            if (lastResult != result) //若上次两个相连数字的差不等于本次两个相连数字的差，表示重新开始计算，加入本次判断的数字，连续数字个数为2
            {
                lastResult = result;
                countinueCount = 2;
            }
            else if(lastResult == result) //若上次两个相连数字的差等于本次两个相连数字的差，是连续数字，连续数字个数加1
            {
                ++countinueCount;
            }
        }
        else //前后两个数字相差不为1，不连续，重新开始计算，重置上次两个相连的数字的差为0，连续数字的个数为1
        {
            lastResult = 0;
            countinueCount = 1;
        }
        
        if (countinueCount >= 6)
        {
            return NO;
        }
    }
    
    return YES;
}

/**
 *  @brief  是否合法的手机号码
 *
 *  @param aStr 需要判断的字符换
 *
 *  @return yes表示合法，no表示不合法
 */
- (BOOL)isPhoneNumber:(NSString *)aStr
{
    if (0 != [aStr length])
    {
        NSString *strPhoneNum = [self dealWithPhoneNumber:aStr isChineAccount:YES];
        return [self isMobileNumber:strPhoneNum];
    }
    
    return NO;
}

@end
