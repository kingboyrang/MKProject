//
//  ConfigSettingHandler.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-21.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  设置管理
 */
@interface ConfigSettingHandler : NSObject

/**
 *  按键音设置
 *
 *  @param on YES开，否则关
 */
+ (void)setKeyPressSoundOn:(BOOL)on;

/**
 *  按键音是否开启
 *
 *  @return YES开，否则关
 */
+ (BOOL)isKeyPressSoundOn;

/**
 *  语音提醒设置
 *
 *  @param on YES开，否则关
 */
+ (void)setSpeechRemindOn:(BOOL)on;

/**
 *  取得语音提醒是否开启
 *
 *  @return YES开，否则关
 */
+ (BOOL)isSpeechRemindOn;

/**
 *  wifi下回拨设置
 *
 *  @param on YES开，否则关
 */
+ (void)setWiFiCallBackOn:(BOOL)on;

/**
 *  取得wifi下是否为回拨
 *
 *  @return YES是，否则不回拨
 */
+ (BOOL)isWiFiCallBackOn;

/**
 *  3g4g下回拨设置
 *
 *  @param on YES开，否则关
 */
+ (void)set3G4GCallBackOn:(BOOL)on;

/**
 *  取得3g4g下是否为回拨
 *
 *  @return YES是，否则不回拨
 */
+ (BOOL)is3G4GCallBackOn;

@end
