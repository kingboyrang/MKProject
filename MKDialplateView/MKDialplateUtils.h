//
//  MKDialplateUtils.h
//  MKDialplateView
//
//  Created by chenzhihao on 15-5-21.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MKDialplateUtils : NSObject

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
 *  @brief  获取颜色生成的图片
 *
 *  @param color 颜色值
 *
 *  @return UIImage对象
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  @brief  去掉手机号码中的特殊字符
 *
 *  @param phoneNum 传入的手机号码
 *
 *  @return 替换后的手机号码
 */
+ (NSString *)replaceSpecialCharacterInPhoneNumber:(NSString *)phoneNum;

/**
 *  @brief  字符串是否为纯数字
 *
 *  @param text 需要判断是字符串
 *
 *  @return YES表示是纯数字，NO为非纯数字
 */
+ (BOOL)textIsPureDigital:(NSString *)text;

/**
 *  @brief  格式化手机号码。去掉+86 86 0086等
 *
 *  @param phoneNumber 需要处理的手机号码
 *
 *  @return 处理后的手机号码
 */
+ (NSString *)formatPhoneNumber:(NSString *)phoneNumber;

@end
