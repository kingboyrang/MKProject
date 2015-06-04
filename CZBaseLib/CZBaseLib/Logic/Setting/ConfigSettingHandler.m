//
//  ConfigSettingHandler.m
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-21.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "ConfigSettingHandler.h"
#import "ConfigDefineKey.h"

@implementation ConfigSettingHandler
/**
 *  按键音设置
 *
 *  @param status YES开，否则关
 */
+ (void)setKeyPressSoundOn:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kCZKeyPressSoundOnOff];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  按键音是否开启
 *
 *  @return YES开，否则关
 */
+ (BOOL)isKeyPressSoundOn{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:kCZKeyPressSoundOnOff]) {
        return [userDefault boolForKey:kCZKeyPressSoundOnOff];
    }
    return NO;
}

/**
 *  语音提醒设置
 *
 *  @param status YES开，否则关
 */
+ (void)setSpeechRemindOn:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kCZSpeechRemindOnOff];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  取得语音提醒是否开启
 *
 *  @return YES开，否则关
 */
+ (BOOL)isSpeechRemindOn{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:kCZSpeechRemindOnOff]) {
        return [userDefault boolForKey:kCZSpeechRemindOnOff];
    }
    return NO;
}

/**
 *  wifi下回拨设置
 *
 *  @param on YES开，否则关
 */
+ (void)setWiFiCallBackOn:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kCZWiFiCallBackOnOff];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  取得wifi下是否为回拨
 *
 *  @return YES是，否则不回拨
 */
+ (BOOL)isWiFiCallBackOn{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:kCZWiFiCallBackOnOff]) {
        return [userDefault boolForKey:kCZWiFiCallBackOnOff];
    }
    return NO;
}

/**
 *  3g4g下回拨设置
 *
 *  @param on YES开，否则关
 */
+ (void)set3G4GCallBackOn:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kCZ3G4GCallBackOnOff];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  取得3g4g下是否为回拨
 *
 *  @return YES是，否则不回拨
 */
+ (BOOL)is3G4GCallBackOn{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:kCZ3G4GCallBackOnOff]) {
        return [userDefault boolForKey:kCZ3G4GCallBackOnOff];
    }
    return NO;
}
@end
