//
//  NSDate+CZExtend.h
//  DateHelper
//
//  Created by wulanzhou on 15-5-15.
//  Copyright (c) 2015年 rang. All rights reserved.
//
/***
 3、iOS-NSDateFormatter 格式说明：
 
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份缩写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 缩写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 
 常用日期结构：
 yyyy-MM-dd HH:mm:ss.SSS
 yyyy-MM-dd HH:mm:ss
 yyyy-MM-dd
 MM dd yyyy
 ***/

#import <Foundation/Foundation.h>

struct TKDateInformation {
	int day;
	int month;
	int year;
	
	int weekday;
	
	int minute;
	int hour;
	int second;
	
};
typedef struct TKDateInformation TKDateInformation;

@interface NSDate (CZExtend)
/**
 *  取得今天是星期几
 *
 *  @return 取得今天是星期几(由1-7)
 */
-(NSInteger)dayOfWeek;

/**
 *  取得每月有多少天
 *
 *  @return 每月天数
 */
-(NSInteger)monthOfDay;

/**
 *  取得当前月第一天
 *
 *  @return 当前月第一天日期
 */
- (NSDate *)monthFirstDay;

/**
 *  取得当前月最后一天日期
 *
 *  @return 当前月最后一天日期
 */
- (NSDate *)monthLastDay;

/**
 *  本周开始日期
 *
 *  @return 本周开始日期
 */
-(NSDate*)beginningOfWeek;

/**
 *  本周结束日期
 *
 *  @return 本周结束日期
 */
- (NSDate *)endOfWeek;

/**
 *  日期添加几月
 *  @param month 添加几个月
 *  @return      日期添加几月的时间
 */
-(NSDate*)dateByAddingMonths:(NSInteger)month;

/**
 *  日期添加几天
 *  @param day   添加的天数
 *  @return      日期添加几天的时间
 */
-(NSDate*)dateByAddingDays:(NSInteger)day;

/**
 *  日期添加几分钟
 *  @param minute 添加几个分钟
 *  @return       日期添加几天的时间
 */
-(NSDate*)dateByAddingMinutes:(NSInteger)minute;

/**
 *  日期格式化成字符串
 *  @param format 日期格式化结构(如yyyy-MM-dd)
 *  @return       格式化的日期字符串
 */
- (NSString *)stringWithFormat:(NSString *)format;

/**
 *  字符串转换成时间
 *  @param string 字符串时间
 *  @param format 日期格式化结构(如yyyy-MM-dd)
 *  @return       NSDate
 */
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

/**
 *  日期转换成字符串
 *  @param date   NSDate
 *  @param string 日期格式化结构(如yyyy-MM-dd)
 *  @return       日期字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;

/**
 *  将日期转换成台湾民国时间字符串
 *  @param string   日期格式化结构(如yyyy-MM-dd)
 *  @return         日期字符串
 */
-(NSString*)dateToTW:(NSString *)string;

- (TKDateInformation) dateInformation;
- (TKDateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz;
+ (NSDate*) dateFromDateInformation:(TKDateInformation)info;
+ (NSDate*) dateFromDateInformation:(TKDateInformation)info timeZone:(NSTimeZone*)tz;
+ (NSString*) dateInformationDescriptionWithInformation:(TKDateInformation)info;

/**
 *  时间大小比较
 *  @param date     比较的日期
 *  @return         时间大于date返回YES,否则为NO
 */
-(BOOL)compareToDate:(NSDate*)date;
@end
