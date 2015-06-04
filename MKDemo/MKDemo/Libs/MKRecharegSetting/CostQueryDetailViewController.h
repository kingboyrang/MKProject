//
//  WSWebViewViewController.h
//  WldhWeishuo
//
//  Created by lonelysoul on 14-9-12.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecharegeBaseViewController.h"
/**
 *  话单收入与话单查询共用界面
 */
@interface CostQueryDetailViewController : RecharegeBaseViewController<UIWebViewDelegate>

/**
 *  html请求地址
 */
@property (nonatomic,strong) NSString *requestURLString;
/**
 *  是否显示右侧刷新按钮
 */
@property (nonatomic,assign) BOOL showRightRefreshBtn;
/**
 *  webView
 */
@property (nonatomic, strong)  UIWebView *webView;



@end
