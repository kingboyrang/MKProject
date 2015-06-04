//
//  WSPromptHUD.m
//
//  Created by lonelysoul on 14-8-29.
//  Copyright (c) 2013年 Guoling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WSPromptHUD : UIView
{
    CGColorRef bgcolor_;
    NSString *info_;
    CGSize fontSize_;
}
/**
 *  显示提示信息
 *
 *  @param view 父视图
 *  @param str  提示文字
 *  @param flag 是否居中
 */
+ (void)showInView:(UIView *)view info:(NSString *)str isCenter:(BOOL)flag;

@end
