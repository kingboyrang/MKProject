//
//  Utils.m
//  MKFrameworkDemo
//
//  Created by chenzhihao on 15-5-18.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "ContactUtils.h"
#import "PhoneInfo.h"
#import "ContactManager.h"

@implementation ContactUtils

/**
 *  @brief  设置当前国家区号
 */
+ (void)setCurrentCountryCode
{
    MCCType currentCountryType = [PhoneInfo sharedInstance].simCardType;
    
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    
    if(![us objectForKey:@"kCurrentCountryCode"]
       ||([us objectForKey:@"kCurrentCountryCode"]
          &&[[us objectForKey:@"kCurrentCountryCode"] length]<1))
    {
        //初始化国家区号
        if(MCC_CHINA == currentCountryType)
        {
            [us setObject:@"+86" forKey:@"kCurrentCountryCode"];
            [us setObject:@"中国" forKey:@"kCurrentCountryName"];
            [us setBool:YES forKey:@"kIsChinaAcount"];
        }
        else
        {
            [us setObject:@"+1" forKey:@"kCurrentCountryCode"];
            [us setObject:@"美国" forKey:@"kCurrentCountryName"];
            [us setBool:NO forKey:@"kIsChinaAcount"];
        }
    }
    [us synchronize];
}

/**
 *  @brief  获取当前国家区号
 *
 *  @return 国家区号
 */
+ (NSString *)getCurrentCountryCode
{
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    NSString *countryCode = [us objectForKey:@"kCurrentCountryCode"];
    if (countryCode && countryCode.length>0) {
        return countryCode;
    }
    return nil;
}

/**
 *  @brief  判断是否是大陆用户
 *
 *  @return YES表示是大陆用户，NO表示非大陆用户
 */
+ (BOOL)isInland
{
    if ([PhoneInfo sharedInstance].simCardType == MCC_CHINA)
        return YES;
    else
        return NO;
}

/**
 *  @brief  加载联系人归属地文件路径
 */
+ (NSString *)getContactAttributionPath
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MKContactResource" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    //用对象mainBundle获取图片路径
    NSString *filePath = [bundle pathForResource:@"upbkAtt" ofType:@"dat"];
    return filePath;
}

+ (NSString *)formatPhoneNumber:(NSString *)phone
{
    //去悼特殊字符
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:
                                              
                                              @"[^0-9]+" options:0 error:nil];
    
    phone  = [regularExpression stringByReplacingMatchesInString:phone options:0 range:NSMakeRange(0, phone.length) withTemplate:@""];
    //0开头的电话号码判断
    if ([phone hasPrefix:@"01"]&&![phone hasPrefix:@"010"]&&[phone length]==12) {
        phone = [phone substringFromIndex:1];
    }
    //0086 086 +86 86开头的手机号码
    if ([phone hasPrefix:@"86"]||[phone hasPrefix:@"+86"] || [phone hasPrefix:@"086"] || [phone hasPrefix:@"0086"]) {
        if([phone hasPrefix:@"86"]){
            phone = [phone substringFromIndex:2];
        }
        if ([phone hasPrefix:@"+86"] || [phone hasPrefix:@"086"] ) {
            phone = [phone substringFromIndex:3];
        }
        if ([phone hasPrefix:@"0086"] ) {
            phone = [phone substringFromIndex:4];
        }
    }
    return phone;
}

/**
 *  @brief  为电话号码加上国家码
 *
 *  @param phoneNumber 电话号码
 *  @param countryCode 00开头的国家吗(如:0086)
 *
 *  @return 处理后的电话号码
 */
+ (NSString *)addCountryCodeForPhoneNumber:(NSString *)phoneNumber countryCode:(NSString *)countryCode
{
    if ([phoneNumber length] == 0 || [countryCode length] == 0)
    {
        return phoneNumber;
    }
    
    NSString *codeStr = [NSString stringWithFormat:@"%@",countryCode];
    if ([codeStr hasPrefix:@"+"])
    {
        codeStr = [codeStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"00"];
    }
    
    //先去掉该电话号码的特殊字符
    NSString *noCountryCodeNum = [self deleteCountryCodeFromPhoneNumber:phoneNumber countryCode:codeStr];
    
    if (0 != [noCountryCodeNum length])
    {
        if (![noCountryCodeNum hasPrefix:@"00"]) //未加上国家吗
        {
            return [NSString stringWithFormat:@"%@%@",codeStr,noCountryCodeNum];
        }
        else //已加上了国家码
        {
            return noCountryCodeNum;
        }
    }
    return phoneNumber;
}

/**
 *  @brief  去掉电话号码中的特殊字符
 *
 *  @param phoneNumber 电话号码
 *  @param countryCode 00开头的国家吗(如:0086)
 *
 *  @return 处理后的电话号码
 */
+ (NSString *)deleteCountryCodeFromPhoneNumber:(NSString *)phoneNumber countryCode:(NSString *)countryCode
{
    if ([countryCode length] == 0 || [phoneNumber length] == 0)
    {
        return phoneNumber;
    }
    
    NSString *codeStr = [NSString stringWithFormat:@"%@",countryCode];
    if ([codeStr hasPrefix:@"+"])
    {
        codeStr = [codeStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"00"];
    }
    
    BOOL isChinese = [codeStr isEqualToString:@"0086"];
    
    NSString *aStr = [NSString stringWithFormat:@"%@",phoneNumber];
    
    // 去掉空格
    aStr = [aStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 去掉'-'
    aStr = [aStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    // 去掉'('和')'
    aStr = [aStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    aStr = [aStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    //去掉"."和" "
    aStr  = [aStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    aStr  = [aStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([aStr hasPrefix:@"+"])
    {
        //将前面的+替换成00
        for (int i = 0; i < [aStr length]; ++i)
        {
            NSString *oneStr = [aStr substringWithRange:NSMakeRange(i, 1)];
            if (![oneStr isEqualToString:@"+"])
            {
                aStr = [aStr stringByReplacingCharactersInRange:NSMakeRange(0, i) withString:@"00"];
                break;
            }
        }
    }
    else if([aStr hasPrefix:@"000"])
    {
        //将前面多余的0去掉
        // chenzhihao 20150107 解决按3个0卡死的问题
        for (int i = 2; i < [aStr length]; i++)
        {
            NSString *oneStr = [aStr substringWithRange:NSMakeRange(i, 1)];
            if (![oneStr isEqualToString:@"0"])
            {
                aStr = [aStr stringByReplacingCharactersInRange:NSMakeRange(0, i-2) withString:@""];
            }
        }
    }
    
    if (isChinese) //中国区号码
    {
        //去掉国家吗
        if ([aStr hasPrefix:codeStr])
        {
            aStr = [aStr stringByReplacingCharactersInRange:NSMakeRange(0, [codeStr length]) withString:@""];
        }
        
        // 去掉号码前面加的“12593”
        if ([aStr hasPrefix:@"12593"])
        {
            aStr = [aStr stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
        
        // 去掉号码前面加的“17951”
        if ([aStr hasPrefix:@"17951"])
        {
            aStr = [aStr stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
        
        // 去掉号码前面加的“17911”
        if ([aStr hasPrefix:@"17911"])
        {
            aStr = [aStr stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
    }
    else
    {
        //去掉国家吗
        if ([aStr hasPrefix:codeStr])
        {
            aStr = [aStr stringByReplacingCharactersInRange:NSMakeRange(0, [codeStr length]) withString:@""];
        }
    }
    
    return aStr;
}

+ (NSString *)getPlaceByPhone:(NSString *)phone
{
    NSString *ret = [[ContactManager shareInstance] phoneAttributionWithPhoneNumber:phone countryCode:[ContactUtils getCurrentCountryCode]];
    return (ret==nil || [ret isEqualToString:@""] || ret.length==0) ? @"未知" :ret ;
}

+ (NSString *)getContactNameByPhone:(NSString *)phone
{
    NSString *calleeName = [[[ContactManager shareInstance] contactInfoWithPhone:phone] getContactFullName];
    return (calleeName==nil || [calleeName isEqualToString:@""] || calleeName.length==0) ? @"未知" :calleeName ;
}

/**
 *  @brief  插入通话记录
 */
+ (void)insertOneCallRecord:(NSString *)phone
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    ContactRecordNode *oneRecord = [[ContactRecordNode alloc] init];
    ContactNode *node = [[ContactManager shareInstance] contactInfoWithPhone:phone];
    oneRecord.contactID = node.contactID;
    oneRecord.phoneNum = phone;
    oneRecord.recordTotalTime = 0;     //通话时长
    [oneRecord dateStringFromDate:startDate];    //通话时间
    oneRecord.recordType = 2;  //通话类型
    
    //处理呼叫号码
    NSString  *countryCode = [ContactUtils getCurrentCountryCode];
    
    oneRecord.phoneNum = [ContactUtils deleteCountryCodeFromPhoneNumber:phone
                                                            countryCode:countryCode];
    
    NSLog(@"通话开始时间:%@_%@",oneRecord.recordDateString,startDate);
    
    if ([[ContactManager shareInstance].myRecordEngine insertOneRecord:oneRecord])
    {
        NSArray *aList = [[ContactManager shareInstance].myRecordEngine allRecord];
        if ([aList count] > 0)
        {
            ContactRecordNode *resultRecord = [aList objectAtIndex:0];
            if (resultRecord && [resultRecord isKindOfClass:[ContactRecordNode class]])
            {
                //发送通知刷新通话记录
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CallRecordRefresh"
                                                                    object:nil
                                                                  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                            resultRecord,@"Record",
                                                                            nil]];
            }
        }
    }
}

@end
