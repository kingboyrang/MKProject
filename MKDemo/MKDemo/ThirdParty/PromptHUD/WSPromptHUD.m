//
//  WSPromptHUD.m
//
//  Created by lonelysoul on 14-8-29.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "WSPromptHUD.h"

#define kHUDFontSize                16
#define kHUDMaxConstrainedSize      CGSizeMake(200, 100)

@implementation WSPromptHUD


// 画出圆角矩形背景
static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) { 
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context); 
    CGContextTranslateCTM (context, CGRectGetMinX(rect), 
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight); 
    fw = CGRectGetWidth (rect) / ovalWidth; 
    fh = CGRectGetHeight (rect) / ovalHeight; 
    CGContextMoveToPoint(context, fw, fh/2); 
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); 
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); 
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); 
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); 
    CGContextClosePath(context); 
    CGContextRestoreGState(context); 
}

- (id)initWithFrame:(CGRect)frame info:(NSString*)info{
    CGRect viewR = CGRectMake(0, 0, frame.size.width*1.2, frame.size.height*1.6);
    self = [super initWithFrame:viewR];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        bgcolor_ = [UIColor blackColor].CGColor;
        if (info == nil)
            info_ = @"Oops o_o";
        else
            info_ = [[NSString alloc] initWithString:info];
        fontSize_ = frame.size;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 背景0.8透明度
    CGContextSetAlpha(context, .9);
    addRoundedRectToPath(context, rect, 4.0f, 4.0f);
    CGContextSetFillColorWithColor(context, bgcolor_);
    CGContextFillPath(context);
    
    // 文字1.0透明度
    CGContextSetAlpha(context, 1.0);
//    CGContextSetShadowWithColor(context, CGSizeMake(0, -1), 1, [[UIColor whiteColor] CGColor]);// 设置字体阴影
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    float x = (rect.size.width - fontSize_.width) / 2.0;
    float y = (rect.size.height - fontSize_.height) / 2.0;
    CGRect r = CGRectMake(x, y, fontSize_.width, fontSize_.height);
//    [info_ drawInRect:r withFont:[UIFont systemFontOfSize:kHUDFontSize] lineBreakMode:NSLineBreakByWordWrapping];
    [info_ drawInRect:r
       withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kHUDFontSize],
                        NSForegroundColorAttributeName:[UIColor whiteColor],}];
}

// 从上层视图移除并释放
- (void)remove{
    [self removeFromSuperview];
}

// 渐变消失
- (void)fadeAway{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5f];
    self.alpha = 0.0;
    [UIView commitAnimations];
    [self performSelector:@selector(remove) withObject:nil afterDelay:1.5f];
}

+ (void)showInView:(UIView *)view info:(NSString *)str isCenter:(BOOL)flag
{
    if (str == nil)
        return;
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:kHUDFontSize]
                   constrainedToSize:kHUDMaxConstrainedSize];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    WSPromptHUD *alert = [[WSPromptHUD alloc] initWithFrame:frame info:str];
    alert.center = CGPointMake(view.center.x, flag == YES ? (view.center.y) : view.frame.size.height - 80);
    alert.alpha = 0;
    [view addSubview:alert];
    [view bringSubviewToFront:alert];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3f];
    alert.alpha = 1.0;
    [UIView commitAnimations];
    
    [alert performSelector:@selector(fadeAway) withObject:nil afterDelay:1];
}

@end
