//
//  WldhNavigationController.m
//  WldhMini
//
//  Created by mini1 on 14-5-28.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "WldhNavigationController.h"

#define RGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface WldhNavigationController ()

@end

@implementation WldhNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //将原点移动到navigationBar下面,兼容iOS6，因为iOS开始原点从(0,0)开始而不是状态栏下面
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed=YES;
    [self setNavigationBackground];
   
    UIColor *titleColor = [UIColor blackColor];
    UIFont *titleFont = [UIFont boldSystemFontOfSize:18];
    NSDictionary *titleDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               titleColor, NSForegroundColorAttributeName,
                               titleFont, NSFontAttributeName,
                               nil];
    [self.navigationBar setTitleTextAttributes:titleDict];
}

- (void)setNavigationBackground{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationBar setBackgroundImage:[self createImageWithColor:RGB(250, 250, 250)]
                                forBarPosition:UIBarPositionAny
                                    barMetrics:UIBarMetricsDefault];
        [self.navigationBar setTintColor:RGB(238, 238, 238)];
        [self.navigationBar setAlpha:0.2];
        [self.navigationBar setBarTintColor:RGB(249, 249, 249)];
        
    } else {
        [self.navigationBar setTintColor:RGB(238, 238, 238)];
    }
}

- (UIImage*)createImageWithColor:(UIColor*)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
