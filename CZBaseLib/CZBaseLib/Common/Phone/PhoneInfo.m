//
//  PhoneInfo.m
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-18.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "PhoneInfo.h"
#import <UIKit/UIKit.h>
#import "UIDevice+CZExtend.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "KeychainItemWrapper.h"
#import "OpenUDID.h"
@implementation PhoneInfo

/**
 *  设备唯一的标识符
 */
- (NSString*)uniqueIdentifier{
    NSString *udid = [[NSUserDefaults standardUserDefaults] objectForKey:@"cz_config_deviceId"];
    if (udid.length > 0) {
        return udid;
    }
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"UDID" accessGroup:nil];
    udid = [wrapper objectForKey:(__bridge id)(kSecValueData)];
    if (udid.length > 0) {
        return udid;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
        // iOS6及以下版本
        udid = [OpenUDID value];
    } else {
        udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    [wrapper setObject:udid forKey:(__bridge id)(kSecValueData)];
    [[NSUserDefaults standardUserDefaults] setObject:udid forKey:@"cz_config_deviceId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return udid;
}

/**
 *  手机名称(设备名称)
 */
- (NSString*)phoneName{
    return [[UIDevice currentDevice] name];
}
/**
 *  手机类型
 */
- (NSString*)phoneMode{
    NSString *str = [[UIDevice currentDevice] hardwareSimpleDescription];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    return str;
}
/**
 *  手机当前网络类型
 */
- (NSString*)phoneNetMode{
    NSString *strNetMode = @"";
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable) {
        strNetMode = @"wifi";
    } else if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
        strNetMode = @"2g";
    }
    return strNetMode;
}

/**
 *  手机当前网络类型
 */
- (PhoneNetType)phoneNetType{
    PhoneNetType nPhoneNetType = PNT_UNKNOWN;
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable)
    {
        nPhoneNetType = PNT_WIFI;
    }
    else if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
    {
        nPhoneNetType = PNT_2G3G;
    }
    return nPhoneNetType;
}

/**
 *  SIM卡运营商(cmcc ：中国移动，cu ：中国联通 ct：中国电信)
 */
- (NSString*)simOperator{
    NSString *strMobileType = nil;
    
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    NSString *mcc_mnc = [NSString stringWithFormat: @"%@%@", mcc, mnc];
    
    if([mcc_mnc isEqualToString: @"46000"] || [mcc_mnc isEqualToString: @"46002"])  //移动
    {
        strMobileType = @"cmcc";
    }
    else if([mcc_mnc isEqualToString: @"46001"])    //联通
    {
        strMobileType = @"cu";
    }
    else if([mcc_mnc isEqualToString: @"46003"])    //电信
    {
        strMobileType = @"ct";
    }
    
    return strMobileType;
}
/**
 *  手机卡类型
 */
- (MCCType)simCardType{
    MCCType currentMccType = MCC_AMERICA;
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    NSString *mcc = [carrier mobileCountryCode];
    if (mcc.length == 0) {
        //return MCC_AMERICA;
        return MCC_CHINA;
    }
    if([mcc isEqualToString: @"460"]) {
        currentMccType = MCC_CHINA;
    }
    if([mcc isEqualToString: @"460"]) {
        currentMccType = MCC_CHINA;
    } else {
        //非中国区的,再判断运营商
        NSString *carrierName = [carrier carrierName];
        if (carrierName) {
            NSRange range = [carrierName rangeOfString:@"移动"];
            if (range.length > 0) {
                currentMccType = MCC_CHINA;
            } else {
                range = [carrierName rangeOfString:@"联通"];
                if (range.length > 0) {
                    currentMccType = MCC_CHINA;
                } else {
                    range = [carrierName rangeOfString:@"电信"];
                    if (range.length > 0) {
                        currentMccType = MCC_CHINA;
                    } else
                    {
                        currentMccType = MCC_AMERICA;
                    }
                }
            }
        }
        else
        {
            currentMccType = MCC_AMERICA;
        }
        
    }
    return currentMccType;
}

/**
 *  单例
 */
+ (PhoneInfo*)sharedInstance
{
    static dispatch_once_t  onceToken;
    static PhoneInfo * sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[PhoneInfo alloc] init];
    });
    return sSharedInstance;
}
@end
