//
//  CZRequestSign.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-13.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZRequestSign : NSObject
/**
 *  默认值为1
 */
@property (nonatomic,strong) NSString *agwAn;
/**
 *  默认值为1
 */
@property (nonatomic,strong) NSString *agwKn;
/**
 *  默认值为空字符串
 */
@property (nonatomic,strong) NSString *agwTK;
/**
 *  用户登陆密码
 */
@property (nonatomic,strong) NSString *password;

/**
 *  取得签名字符串
 *
 *  @param dic 生成签名所要用到的key/value
 *
 *  @return 取得签名字符串
 */
- (NSString *)GetUrlUidSign:(NSDictionary *)dic;
@end

