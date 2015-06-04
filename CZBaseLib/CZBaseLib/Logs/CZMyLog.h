//
//  MyLog.h
//  CZBaseLib
//  打印日志
//  Created by chenzhihao on 15-5-11.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CZMyLog : NSObject

/**
 *  日志的启用与关闭
 *  @param enable 启用YES，关闭NO
 */
+ (void)setWriteLogEnable:(BOOL)enable;

/**
 *  判断是否可以写日志
 */
+ (BOOL)isWriteLogEnable;

/**
 *  写日志
 *  @param content 日志内容
 */
+ (void)writeLog:(NSString*)content;

/**
 *  取得当天的日志文件路径
 *
 */
+ (NSString*)getCurrentDayLogFilePath;

/**
 *  取得所有日志文件路径
 *
 */
+ (NSArray*)getAllLogFilePaths;

/**
 *  删除所有日志
 *
 */
+ (void)removeAllLogs;
@end
