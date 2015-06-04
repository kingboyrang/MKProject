//
//  FilesOperatoion.h
//  CZBaseLib
//  文件操作相关
//  Created by chenzhihao on 15-5-11.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
   FileDirectoryDocumentType=0,  //Document目录
   FileDirectoryCacheType,       //Cache目录
   FileDirectoryTempType        //临时目录
}FileDirectoryType;

@interface CZFilesOperatoion : NSObject

/**
 *  取得文件路径
 *  @param fileType 文件类型
 *  @return         取得文件路径
 */
+ (NSString*)getFilePathWithType:(FileDirectoryType)fileType;

/**
 *  在指定的文件路径中创建文件夹
 *  @param path     文件路径
 *  @return         创建是否成功
 */
+ (BOOL)createDirectoryWithPath:(NSString*)path;

/**
 *  在指定的文件路径中创建文件夹
 *  @param path     文件路径
 *  @param name     文件夹名称
 *  @return         创建是否成功
 */
+ (BOOL)createFolderWithPath:(NSString*)path folderName:(NSString*)name;

/**
 *  是否存在文件
 *  @param path     文件路径
 *  @return         存在为YES,否则为NO
 */
+ (BOOL)isFileExist:(NSString*)path;

@end
