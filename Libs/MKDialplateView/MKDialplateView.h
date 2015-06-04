//
//  MKDialplateView.h
//  MKDialplateView
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DialplateKeyboardDelegate;

@interface MKDialplateView : UIView

//代理
@property (nonatomic,weak) id<DialplateKeyboardDelegate>delegate;

//数字键盘
@property (nonatomic,strong) UIView *numberKeypadView;

//底部拨号按钮
@property (nonatomic,strong) UIView *dialplateBottomView;



/**
 *  @brief  初始化拨号键盘
 *
 *  @param position 拨号键盘的位置,键盘高度固定为236
 *
 *  @return 拨号键盘对象
 */
- (MKDialplateView *)initWithPosition:(CGPoint)position;

/**
 *  @brief  显示拨号键盘
 */
- (void)showDialplate;

/**
 *  @brief  隐藏拨号键盘
 */
- (void)hideDialplate;

@end

@protocol DialplateKeyboardDelegate <NSObject>
/**
 *  @brief  点击数字键盘
 *
 *  @param number 输入按钮的索引
 */
- (void) DialplateViewNumberInput:(NSInteger)number;

/**
 *  @brief  长按按钮
 */
- (void) DialplateViewLongPress;

/**
 *  @brief  点击拨号按钮
 */
- (void) DialplateViewDialButtonClicked;

/**
 *  @brief  删除按钮操作
 *
 *  @param btn
 */
- (void) DialnumberKeyboardBackspace:(UIButton *)btn;

@end
