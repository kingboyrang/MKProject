//
//  PhoneInfo.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-18.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 手机卡sim类型
 */
typedef enum
{
    MCC_CHINA=0,  //中国
    MCC_AMERICA   //美国
}MCCType;

/**
 电话当前网络类型
 */
typedef enum
{
    PNT_UNKNOWN = 0,    // 未知,无网络
    PNT_WIFI    = 1,    // WIFI
    PNT_2G3G           // 2G/3G
}PhoneNetType;

@interface PhoneInfo : NSObject

/**
 *  设备唯一的标识符
 */
@property (nonatomic,readonly) NSString *uniqueIdentifier;

/**
 *  手机别名(用户定义的名称)
 */
@property (nonatomic,readonly) NSString *phoneName;

/**
 *  手机类型
 */
@property (nonatomic,readonly) NSString *phoneMode;

/**
 *  手机当前网络类型(字符串)
 */
@property (nonatomic,readonly) NSString *phoneNetMode;

/**
 *  手机当前网络类型
 */
@property (nonatomic,readonly) PhoneNetType phoneNetType;

/**
 *  SIM卡运营商(cmcc ：中国移动，cu ：中国联通 ct：中国电信)
 */
@property (nonatomic,readonly) NSString *simOperator;

/**
 *  手机卡类型
 */
@property (nonatomic,assign)   MCCType simCardType;

/**
 *  单例
 */
+ (PhoneInfo*)sharedInstance;
@end
