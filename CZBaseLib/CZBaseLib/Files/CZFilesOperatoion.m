//
//  FilesOperatoion.m
//  CZBaseLib
//
//  Created by chenzhihao on 15-5-11.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "CZFilesOperatoion.h"

@implementation CZFilesOperatoion
/**
 *  取得文件路径
 *  @param fileType 文件类型
 *  @return         取得文件路径
 */
+ (NSString*)getFilePathWithType:(FileDirectoryType)fileType{
    if (fileType==FileDirectoryDocumentType) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
       return  [paths objectAtIndex:0];
    }else if (fileType==FileDirectoryCacheType){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
       return  [paths objectAtIndex:0];
    }else{
       return NSTemporaryDirectory();
    }
}

/**
 *  在指定的文件路径中创建文件夹
 *  @param path     文件路径
 *  @return         创建是否成功
 */
+ (BOOL)createDirectoryWithPath:(NSString*)path{
    BOOL success=YES;
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!(isDir == YES && existed == YES) )
    {
        success=[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return success;
}

/**
 *  在指定的文件路径中创建文件夹
 *  @param path     文件路径
 *  @param name     文件夹名称
 *  @return         创建是否成功
 */
+ (BOOL)createFolderWithPath:(NSString*)path folderName:(NSString*)name{
    NSString *dir=[path stringByAppendingPathComponent:name];
    return [self createDirectoryWithPath:dir];
}

/**
 *  是否存在文件
 *  @param path     文件路径
 *  @return         存在为YES,否则为NO
 */
+ (BOOL)isFileExist:(NSString*)path{
    if (path&&[path length]>0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        return [fileManager fileExistsAtPath:path];
    }
    return NO;
}
@end
