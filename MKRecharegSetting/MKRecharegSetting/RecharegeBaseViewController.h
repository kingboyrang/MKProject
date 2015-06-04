//
//  RecharegeBaseViewController.h
//  MKRecharegSetting
//
//  Created by wulanzhou-mini on 15-5-27.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecharegeBaseViewController : UIViewController

/**
 *  按钮正常时的颜色
 *
 *  @return  按钮颜色
 */
- (UIColor*)getButtonNormalColor;

/**
 *  按钮高亮时的颜色
 *
 *  @return 按钮颜色
 */
- (UIColor*)getButtonHighlightedColor;

@end
