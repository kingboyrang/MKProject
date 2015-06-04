//
//  MyLog.m
//  CZBaseLib
//
//  Created by chenzhihao on 15-5-11.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "CZMyLog.h"
#import "CZFilesOperatoion.h"
#import "NSDate+CZExtend.h"
#define kCZWriteLogEnableKey @"kCZWriteLogEnableKey"

@implementation CZMyLog

/**
 *  日志的启用与关闭
 *  @param enable 启用YES，关闭NO
 */
+ (void)setWriteLogEnable:(BOOL)enable{
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:kCZWriteLogEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  判断是否可以写日志
 */
+ (BOOL)isWriteLogEnable{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kCZWriteLogEnableKey]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:kCZWriteLogEnableKey];
    }
    return NO;
}

/**
 *  写日志
 *  @param content 日志内容
 */
+ (void)writeLog:(NSString*)content{
    if (![self isWriteLogEnable])return;
    NSString *datetime=[[NSDate date] stringWithFormat:@"yyyyMMdd"];
    NSString *name=[NSString stringWithFormat:@"%@.txt",datetime];
    NSString *filePath=[[self getLogsPath] stringByAppendingPathComponent:name];
    
    NSMutableString *logs=[NSMutableString stringWithString:@""];
    [logs appendFormat:@"\n-------------%@-----------\n",[NSDate date]];
    [logs appendString:content];
    [logs appendString:@"\n"];
    
    if (![CZFilesOperatoion isFileExist:filePath]) {
        [logs writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        NSFileHandle  *outFile;
        NSData *buffer;
        outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
        if(outFile == nil)
        {
            NSLog(@"Open of file for writing failed");
        }
        //找到并定位到outFile的末尾位置(在此后追加文件)
        [outFile seekToEndOfFile];
        //读取inFile并且将其内容写到outFile中
        NSString *bs = [NSString stringWithFormat:@"%@",logs];
        buffer = [bs dataUsingEncoding:NSUTF8StringEncoding];
        [outFile writeData:buffer];
        //关闭读写文件  
        [outFile closeFile];
    }
}

/**
 *  取得当天的日志文件路径
 *
 */
+ (NSString*)getCurrentDayLogFilePath{
    NSString *datetime=[[NSDate date] stringWithFormat:@"yyyyMMdd"];
    NSString *name=[NSString stringWithFormat:@"%@.txt",datetime];
    NSString *filePath=[[self getLogsPath] stringByAppendingPathComponent:name];
    if ([CZFilesOperatoion isFileExist:filePath]){
       return filePath;
    }
    return nil;
}

/**
 *  取得所有日志文件路径
 *
 */
+ (NSArray*)getAllLogFilePaths{
    NSString *path=[self getLogsPath];
    return [self allFilesAtPath:path];
}
/**
 *  删除所有日志
 *
 */
+ (void)removeAllLogs{
    NSString *filePath = [self getLogsPath];
    if ([CZFilesOperatoion isFileExist:filePath]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}
#pragma mark -私有方法
/**
 *  取得日志根目录路径
 *
 *
 *  @return 日志根目录路径
 */
+ (NSString*)getLogsPath{
    NSString *root=[CZFilesOperatoion getFilePathWithType:FileDirectoryDocumentType];
    NSString *path=[root stringByAppendingPathComponent:@"cz_logs"];
    
    if ([CZFilesOperatoion isFileExist:path]) {
        return path;
    }
    if (![CZFilesOperatoion createDirectoryWithPath:path]) {
        NSLog(@"创建目录失败!");
    }
    return path;
}
/**
 *  取得文件夹下的所有文件
 *
 *  @param dirString 文件目录路径
 *
 *  @return 文件列表
 */
+ (NSArray*) allFilesAtPath:(NSString*) dirString {
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    for (NSString* fileName in tempArray) {
        BOOL flag = YES;
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }else{
                NSArray *childs=[self allFilesAtPath:fullPath];
                if (childs&&[childs count]>0) {
                    [array addObjectsFromArray:childs];
                }
            }
        }
        
    }
    return array;
}
@end
