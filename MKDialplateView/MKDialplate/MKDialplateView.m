//
//  MKDialplateView.m
//  MKDialplateView
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKDialplateView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MKDialplateUtils.h"
#import "ConfigSettingHandler.h"

#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation MKDialplateView
{
    NSInteger index;
    CGFloat keyboardPositionY;
}

/**
 *  @brief  创建拨号盘的按钮
 *
 *  @param x        行号
 *  @param y        列好
 *  @param indexnum 用于寻找按钮的序列号
 *
 *  @return 按钮对象
 */
-(UIButton *)creatButtonWithX:(NSInteger)x Y:(NSInteger)y Indexnum:(NSInteger)indexnum
{
    UIButton *button;
    //
    CGFloat frameX;
    CGFloat frameY;
    CGFloat btnWidth;
    CGFloat btnHeight;
    
    //320分3列，中间为107两边为106
//    btnWidth = (0==y%2) ? 107.0:106.0;
    btnWidth = [UIScreen mainScreen].bounds.size.width /3;
    btnHeight = 59.0;
    
    //X坐标
    switch (y)
    {
        case 0:
            frameX = 0.0;
            break;
        case 1:
            frameX = btnWidth;
            break;
        case 2:
            frameX = btnWidth *2;
            break;
        default:
            break;
    }
    //Y坐标
    if (x == 0) {
        frameY = 0;
    } else
    {
        frameY = 59*x;
    }
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, btnWidth, btnHeight)];
    //设置背景图片 普通和高亮
    NSString *nor = [NSString stringWithFormat:@"dialplate_key_%ld_nor",(long)indexnum];
    [button setImage:[MKDialplateUtils getImageFromResourceBundleWithName:nor type:@"png"] forState:UIControlStateNormal];
    UIImage *bgImage = [MKDialplateUtils imageWithColor:[UIColor whiteColor]];
    
    UIColor * highlightColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15];
    UIImage *imagehighlight = [MKDialplateUtils imageWithColor:highlightColor];
    
    
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    [button setBackgroundImage:imagehighlight forState:UIControlStateHighlighted];
    button.tag = indexnum; //1-12
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //如果是删除按钮 tag==12情况,增加长按事件
    if (button.tag == 12) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 1.0; //定义按的时间
        [button addGestureRecognizer:longPress];
    }
    
    //添加按键音
    [button addTarget:self action:@selector(playSystemSound) forControlEvents:UIControlEventTouchDown];
    
    return button;
}

/**
 *  @brief  按钮点击事件，由代理实现
 *
 *  @param sender 被点击的按钮
 */
- (void)clickButton:(UIButton *)sender
{
    if(sender.tag == 12)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(DialnumberKeyboardBackspace:)])
        {
            [self.delegate DialnumberKeyboardBackspace:sender];
        }
    }
    else
    {
        NSInteger num;
        if (sender.tag == 11)
            num =0;
        else
            num = sender.tag;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DialplateViewNumberInput:)]) {
            [self.delegate DialplateViewNumberInput:num];
        }
    }
}

/**
 *  @brief 按钮长按事件，由代理实现
 *
 *  @param gestureRecognizer
 */
- (void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DialplateViewLongPress)])
        {
            [self.delegate DialplateViewLongPress];
        }
    }
}

/**
 *  @brief  拨号按钮事件，由代理实现
 *
 *  @param sender 拨号按钮
 */
- (void)call:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DialplateViewDialButtonClicked)]) {
        [self.delegate DialplateViewDialButtonClicked];
    }
}


/**
 *  @brief  初始化拨号键盘
 *
 *  @param position 拨号键盘的位置，大小是固定的
 *
 *  @return 拨号键盘对象
 */
- (MKDialplateView *)initWithPosition:(CGPoint)position
{
    if (self = [super initWithFrame:CGRectMake(position.x, position.y, [UIScreen mainScreen].bounds.size.width, 285)])
    {
        self.numberKeypadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 236)];
        self.numberKeypadView.backgroundColor = [UIColor whiteColor];
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                index++;
                UIButton *button = [self creatButtonWithX:i Y:j Indexnum:index];
                [self.numberKeypadView addSubview:button];
            }
        }
        [self addSubview:self.numberKeypadView];
        
        self.dialplateBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 236, [UIScreen mainScreen].bounds.size.width, 49)];
        self.dialplateBottomView.backgroundColor = [UIColor whiteColor];
        
        //拨打按钮
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [callBtn.layer setMasksToBounds:YES];
        [callBtn.layer setCornerRadius:5.0];
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        callBtn.frame = CGRectMake((screenWidth-155)*0.5, 5, 155, 38);
        UIImage *callBtnNor = [MKDialplateUtils imageWithColor:kColorFromRGB(0x06bf04)];
        UIImage *callBtnDown = [MKDialplateUtils imageWithColor:kColorFromRGB(0x029d00)];
        [callBtn setBackgroundImage:callBtnNor forState:UIControlStateNormal];
        [callBtn setBackgroundImage:callBtnDown forState:UIControlStateHighlighted];
        [callBtn setTitle:@"呼叫" forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        [self.dialplateBottomView addSubview:callBtn];
        
        //view上方的线条
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        line1.backgroundColor = color;
        [self.dialplateBottomView addSubview:line1];
        
        [self addSubview:self.dialplateBottomView];
    }
    return self;
}

/**
 *  @brief  显示拨号键盘
 */
- (void)showDialplate
{
    if (self.hidden) {
        CGRect platekeyboardframe = self.frame;
        platekeyboardframe.origin.y -= platekeyboardframe.size.height;
        self.hidden = NO;
        [UIView animateWithDuration:0.25f animations:^{
            self.frame = platekeyboardframe;
        }];
    }
}

/**
 *  @brief  隐藏拨号键盘
 */
- (void)hideDialplate
{
    if (!self.hidden) {
        CGRect temp = self.frame;
        temp.origin.y += temp.size.height;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = temp;
        }completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

/**
 *  @brief  播放系统按键音
 */
- (void)playSystemSound
{
    if(![ConfigSettingHandler isKeyPressSoundOn])
        return;
    
    SystemSoundID sID;
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
    {
        sID = 1109;
    }
    else
    {
        sID = 1201;
    }
    AudioServicesPlaySystemSound(sID);
}

@end
