//
//  MKCallRecordUtils.h
//  MKCallRecord
//
//  Created by chenzhihao on 15-5-21.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RecordMegerNode.h"

@interface MKCallRecordUtils : NSObject

/**
 *  @brief  获得资源文件bundle的图片
 *
 *  @param imgName 图片名字
 *  @param type    图片类型
 *
 *  @return UIImage对象
 */
+ (UIImage *)getImageFromResourceBundleWithName:(NSString *)imgName type:(NSString *)type;

/**
 *  @brief  颜色生成图片
 *
 *  @param color 颜色值
 *
 *  @return UIImage对象
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  @brief  判断时间字符串是否当天
 *
 *  @param date 日期
 *
 *  @return yes表示是当前，no表示不是
 */
+ (BOOL)isTimeStringToday:(NSDate *)date;

/**
 *  @brief  获取时间展示,当天显示HH:mm 昨天、前天显示“昨天”或“前天”，前天以前当年显示MM.dd,不是当年显示yyyy-MM-dd
 *
 *  @param timeStr 当期日期字符串，格式为yyyy-MM-dd:HH:mm:ss
 *
 *  @return 当前日期
 */
+ (NSString *)getTimeShowFormaterString:(NSString *)timeStr;

/**
 *  @brief  获取时间展示,当天显示HH:mm 昨天、前天显示“昨天HH:mm”或“前天HH:mm”，前天以前当年显示MM月dd日HH:mm,不是当年显示yyyy年MM月dd日
 *
 *  @param timeStr 当期日期字符串，格式为yyyy-MM-dd:HH:mm:ss
 *
 *  @return 当前日期
 */
+ (NSString *)getRecordShowFormaterString:(NSString *)timeStr;


/**
 *  @brief  根据传入的时间字符串，返回今天、昨天、某年某月某日时间
 *
 *  @param date 日期字符串
 *
 *  @return 返回今天、昨天、某年某月某日时间
 */
+ (NSString *)dialDate:(NSString *)date;

/**
 *  @brief  获取UILabel的动态长度
 *
 *  @param str  显示在Label上的字符串
 *  @param font 字符串字体
 *
 *  @return Label的长度
 */
+ (CGFloat)getLabelLength:(NSString *)str font:(UIFont *)font;

/**
 *  @brief  获取归属地
 *
 *  @param phone 手机号码
 *
 *  @return 归属地
 */
+ (NSString *)getPlaceByPhone:(NSString *)phone;

/**
 *  @brief  插入一条通话记录
 *
 *  @param node 需要插入的通话记录
 */
+ (void)insertOneCallRecord:(RecordMegerNode *)record;
@end
