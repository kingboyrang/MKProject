//
//  MKCallRecordUtils.m
//  MKCallRecord
//  通话记录工具类
//  Created by chenzhihao on 15-5-21.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKCallRecordUtils.h"

#import "ContactManager.h"
#import "ContactUtils.h"
#import "ContactNode.h"

static NSDateFormatter *stat_wldhDateFormatter = nil;

@implementation MKCallRecordUtils

/**
 *  @brief  获得资源文件bundle的图片
 *
 *  @param imgName 图片名字
 *  @param type    图片类型
 *
 *  @return UIImage对象
 */
+ (UIImage *)getImageFromResourceBundleWithName:(NSString *)imgName type:(NSString *)type
{
    //定义一个NSBundle对象获取得到应用程序的main bundle
    //    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MKCallRecordResources" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    //用对象mainBundle获取图片路径
    NSString *imagePath = [bundle pathForResource:imgName ofType:type];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (BOOL)isTimeStringToday:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([today isEqualToDate:otherDate]) {
        return YES;
    }
    
    return NO;
}

+ (NSDate *)dateFromString:(NSString *)dateStr withFormater:(NSString *)formater
{
    if ([dateStr length] == 0 || 0 == [formater length])
    {
        return nil;
    }
    
    @synchronized(self)
    {
        if (stat_wldhDateFormatter == nil)
        {
            stat_wldhDateFormatter = [[NSDateFormatter alloc] init];
        }
        
        [stat_wldhDateFormatter setDateFormat:formater];
        return [stat_wldhDateFormatter dateFromString:dateStr];
    }
}

+ (NSString *)getDateTextFromDate:(NSDate *)date withFormater:(NSString *)formater
{
    if (date == nil || 0 == [formater length])
    {
        return @"";
    }
    
    @synchronized(self)
    {
        if (stat_wldhDateFormatter == nil)
        {
            stat_wldhDateFormatter = [[NSDateFormatter alloc] init];
        }
        
        [stat_wldhDateFormatter setDateFormat:formater];
        return [stat_wldhDateFormatter stringFromDate:date];
    }
}

//获取时间展示,当天显示HH:mm 昨天、前天显示“昨天”或“前天”，前天以前当年显示MM.dd,不是当年显示yyyy-MM-dd
//输入参数：当期日期字符串，格式为yyyy-MM-dd:HH:mm:ss
+ (NSString *)getTimeShowFormaterString:(NSString *)timeStr
{
    NSDate *aDate =[MKCallRecordUtils dateFromString:timeStr withFormater:@"yyyy-MM-dd:HH:mm:ss"];
    if (nil == aDate)
    {
        return timeStr;
    }
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comps = [cal components:unitFlags fromDate:aDate];
    
    
    NSDateComponents *curComps = [cal components:unitFlags fromDate:[NSDate date]];
    
    if ([curComps year] == [comps year]) //当年
    {
        if ([curComps month] == [comps month]) //当月
        {
            NSInteger ret = [curComps day] - [comps day];
            if (ret == 0) //当日
            {
                return [MKCallRecordUtils getDateTextFromDate:aDate withFormater:@"HH:mm"];
            }
            else if(ret == 1) //昨天
            {
                return @"昨天";
            }
            else if (ret == 2)
            {
                return @"前天";
            }
            else
            {
                return [MKCallRecordUtils getDateTextFromDate:aDate withFormater:@"MM/dd"];
            }
        }
        else //不在同一个月
        {
            NSDate *yesterDay = [[NSDate date] dateByAddingTimeInterval:-24 * 3600];
            NSDateComponents *yesterComps = [cal components:unitFlags fromDate:yesterDay];
            if ([yesterComps day] == [comps day]) //昨天
            {
                return @"昨天";
            }
            else if ([yesterComps day] - [comps day] == 1) //前天
            {
                return @"前天";
            }
            else
            {
                return [MKCallRecordUtils getDateTextFromDate:aDate withFormater:@"MM/dd"];
            }
        }
    }
    else //不是当年，返回yyyy-MM-dd
    {
        NSString *str1=[MKCallRecordUtils getDateTextFromDate:aDate withFormater:@"MM/dd"];
        return [NSString stringWithFormat:@"%ld/%@",[comps year]-2000,str1];
        //return [WldhUtils getDateTextFromDate:aDate withFormater:@"yyyy/MM/dd"];
    }
    
    return timeStr;
}

/*
 功能：获取时间展示,当天显示HH:mm 昨天、前天显示“昨天HH:mm”或“前天HH:mm”，前天以前当年显示MM月dd日HH:mm,不是当年显示yyyy年MM月dd日
 输入参数：当期日期字符串，格式为yyyy-MM-dd:HH:mm:ss
 返回值： 当前网络状态
 */
+ (NSString *)getRecordShowFormaterString:(NSString *)timeStr
{
    NSDate *aDate = [MKCallRecordUtils dateFromString:timeStr withFormater:@"yyyy-MM-dd:HH:mm:ss"];
    if (nil == aDate)
    {
        return timeStr;
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comps = [cal components:unitFlags fromDate:aDate];
    
    NSDateComponents *curComps = [cal components:unitFlags fromDate:[NSDate date]];
    
    if ([curComps year] == [comps year]) //当年
    {
        NSString *aStr = [MKCallRecordUtils getDateTextFromDate:aDate withFormater:@"HH:mm"];
        if ([curComps month] == [comps month]) //当月
        {
            NSInteger ret = [curComps day] - [comps day];
            if (ret == 0) //当日
            {
                return aStr;
            }
            else if(ret == 1) //昨天
            {
                return [NSString stringWithFormat:@"昨天%@",aStr];
            }
            else if (ret == 2)
            {
                return [NSString stringWithFormat:@"前天%@",aStr];
            }
            else
            {
                return [MKCallRecordUtils getDateTextFromDate:aDate withFormater:@"MM月dd日HH:mm"];
            }
        }
        else //不在同一个月
        {
            NSDate *yesterDay = [[NSDate date] dateByAddingTimeInterval:-24 * 3600];
            NSDateComponents *yesterComps = [cal components:unitFlags fromDate:yesterDay];
            if ([yesterComps day] == [comps day]) //昨天
            {
                return [NSString stringWithFormat:@"昨天%@",aStr];
            }
            else if ([yesterComps day] - [comps day] == 1) //前天
            {
                return [NSString stringWithFormat:@"前天%@",aStr];
            }
            else
            {
                return [MKCallRecordUtils getDateTextFromDate:aDate withFormater:@"MM月dd日HH:mm"];
            }
        }
    }
    else //不是当年，返回yyyy-MM-dd
    {
        return [MKCallRecordUtils getDateTextFromDate:aDate withFormater:@"yyyy年MM月dd日"];
    }
    
    return timeStr;
}

+ (NSString *)dialDate:(NSString *)date
{
    if (!date)
        return @"";
    
    NSArray *fullDateArray = [date componentsSeparatedByString:@":"];
    NSString *yearMonthDay = [fullDateArray objectAtIndex:0];
    NSString *hour = [NSString stringWithFormat:@"%@", fullDateArray[1]];
    NSString *minute = [NSString stringWithFormat:@"%@", fullDateArray[2]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd:HH:mm:ss"];
    
    NSDate * today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate * refDate = [formatter dateFromString:date];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString]) {
        return [NSString stringWithFormat:@"%@:%@", hour, minute];
        
    } else if ([refDateString isEqualToString:yesterdayString]) {
        return [NSString stringWithFormat:@"昨天%@:%@", hour, minute];
        
    } else {
        return [NSString stringWithFormat:@"%@", yearMonthDay];
    }
}

/**
 *  @brief  获取UILabel的动态长度
 *
 *  @param str  显示在Label上的字符串
 *  @param font 字符串字体
 *
 *  @return Label的长度
 */
+ (CGFloat)getLabelLength:(NSString *)str font:(UIFont *)font;
{
    CGFloat length = 0.0;
    NSDictionary *attr = @{NSFontAttributeName: font};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(120, 1000)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attr
                                    context:nil];
    length = rect.size.width;
    return length;
}

+ (NSString *)getPlaceByPhone:(NSString *)phone
{
    NSString *ret = [[ContactManager shareInstance] phoneAttributionWithPhoneNumber:phone countryCode:[ContactUtils getCurrentCountryCode]];
    return (ret==nil || [ret isEqualToString:@""] || ret.length==0) ? @"未知" :ret ;
}

+ (void)insertOneCallRecord:(RecordMegerNode *)record
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    ContactRecordNode *oneRecord = [[ContactRecordNode alloc] init];
    ContactNode *node = [[ContactManager shareInstance] contactInfoWithPhone:record.phoneNumber];
    oneRecord.contactID = node.contactID;
    oneRecord.phoneNum = record.phoneNumber;
    oneRecord.recordTotalTime = 0;     //通话时长
    [oneRecord dateStringFromDate:startDate];    //通话时间
    oneRecord.recordType = 2;  //通话类型
    
    //处理呼叫号码
    NSString  *countryCode = [ContactUtils getCurrentCountryCode];
    
    oneRecord.phoneNum = [ContactUtils deleteCountryCodeFromPhoneNumber:record.phoneNumber
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
