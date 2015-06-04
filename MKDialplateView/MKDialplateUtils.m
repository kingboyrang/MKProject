//
//  MKDialplateUtils.m
//  MKDialplateView
//
//  Created by chenzhihao on 15-5-21.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKDialplateUtils.h"

@implementation MKDialplateUtils

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
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MKDialplateSources" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    //用对象mainBundle获取图片路径
    NSString *imagePath = [bundle pathForResource:imgName ofType:type];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    return image;
}

/**
 *  @brief  获取颜色生成的图片
 *
 *  @param color 颜色值
 *
 *  @return UIImage对象
 */
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

/**
 *  @brief  去掉手机号码中的特殊字符
 *
 *  @param phoneNum 传入的手机号码
 *
 *  @return 替换后的手机号码
 */
+ (NSString *)replaceSpecialCharacterInPhoneNumber:(NSString *)phoneNum
{
    if (0 == [phoneNum length])
    {
        return @"";
    }
    
    NSString *str = [NSString stringWithFormat:@"%@",phoneNum];
    
    str  = [str stringByReplacingOccurrencesOfString:@"!" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"*" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"'" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@";" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"&" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"=" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"$" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"/" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"?" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"%" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"#" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"[" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    str  = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 去掉'-'
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return str;
}

/**
 *  @brief  字符串是否为纯数字
 *
 *  @param text 需要判断是字符串
 *
 *  @return YES表示是纯数字，NO为非纯数字
 */
+ (BOOL)textIsPureDigital:(NSString *)text
{
    NSScanner *scan = [NSScanner scannerWithString:text];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)formatPhoneNumber:(NSString *)phoneNumber
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:
                                              
                                              @"[^0-9]+" options:0 error:nil];
    
    phoneNumber = [regularExpression stringByReplacingMatchesInString:phoneNumber options:0 range:NSMakeRange(0, phoneNumber.length) withTemplate:@""];
    //0开头的电话号码判断
    if ([phoneNumber hasPrefix:@"01"]&&![phoneNumber hasPrefix:@"010"]&&[phoneNumber length]==12) {
        phoneNumber =[phoneNumber substringFromIndex:1];
    }
    //0086 086 +86 86开头的手机号码
    if ([phoneNumber hasPrefix:@"86"]||[phoneNumber hasPrefix:@"+86"] || [phoneNumber hasPrefix:@"086"] || [phoneNumber hasPrefix:@"0086"]) {
        if([phoneNumber hasPrefix:@"86"]){
            phoneNumber = [phoneNumber substringFromIndex:2];
        }
        if ([phoneNumber hasPrefix:@"+86"] || [phoneNumber hasPrefix:@"086"] ) {
            phoneNumber = [phoneNumber substringFromIndex:3];
        }
        if ([phoneNumber hasPrefix:@"0086"] ) {
            phoneNumber = [phoneNumber substringFromIndex:4];
        }
    }
    return phoneNumber;
}

@end
