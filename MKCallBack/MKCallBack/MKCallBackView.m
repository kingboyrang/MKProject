//
//  MKCallBackView.m
//  MKCallBack
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKCallBackView.h"

@interface MKCallBackView ()
//显示背景的图片
@property (nonatomic,strong) UIImageView *bgImageView;
//显示被叫人姓名的Label
@property (nonatomic,strong) UILabel *calleeNameLabel;
//显示被叫人号码+归属地的label[self.view removeFromSuperview];
@property (nonatomic,strong) UILabel *calleeNumberAndPlaceLabel;
//显示vip图标的图片
@property (nonatomic,strong) UIImageView *vipImageView;
//返回等待按钮
@property (nonatomic,strong) UIButton *backToWaitButton;
//提示Label  系统正在回拨到...
@property (nonatomic,strong) UILabel *tipLabel;
@end

@implementation MKCallBackView

/**
 *  @brief  获得资源文件bundle的图片
 *
 *  @param imgName 图片名字
 *  @param type    图片类型
 *
 *  @return UIImage对象
 */
- (UIImage *)getImageFromResourceBundleWithName:(NSString *)imgName type:(NSString *)type;
{
    //定义一个NSBundle对象获取得到应用程序的main bundle
    //    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MKCallBackResources" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    //用对象mainBundle获取图片路径
    NSString *imagePath = [bundle pathForResource:imgName ofType:type];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    return image;
}

/**
 *  @brief  创建callbackview对象
 *
 *  @return callbackview对象
 */
- (instancetype)initWithFrame:(CGRect)frame calleeName:(NSString *)calleeName calleeNumber:(NSString *)calleeNumber calleePlace:(NSString *)calleePlace callerNumber:(NSString *)callerNumber isVipUser:(BOOL)flag
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        self.backgroundColor = [UIColor whiteColor];
        
        //背景图片
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*0.67)];
        self.bgImageView.image = (screenHeight==480)?[self getImageFromResourceBundleWithName:@"directbg960" type:@"png"]:[self getImageFromResourceBundleWithName:@"directbg1136" type:@"png"];
        [self addSubview:self.bgImageView];
        
        //浮层图片
        UIImageView *floatImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, self.bgImageView.frame.size.height*0.5)];
        floatImage.image = [self getImageFromResourceBundleWithName:@"floatImage" type:@"png"];
        [self addSubview:floatImage];
        
        //被叫人姓名
        self.calleeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 0, 31)];
        self.calleeNameLabel.textAlignment = NSTextAlignmentCenter;
        self.calleeNameLabel.textColor = [UIColor whiteColor];
        self.calleeNameLabel.font = [UIFont boldSystemFontOfSize:22.0];
        if (calleeName && calleeName.length>0) {
            self.calleeNameLabel.text = calleeName;
        } else {
            self.calleeNameLabel.text = calleeNumber;
        }
        
        //获取被叫人名字的长度
        CGFloat calleeNameLength = [self.calleeNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.calleeNameLabel.frame.size.height)
                                                                           options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName:self.calleeNameLabel.font}
                                                                           context:nil].size.width;
        //重新设置frame
        CGRect rect = self.calleeNameLabel.frame;
        rect.origin.x = (screenWidth-calleeNameLength)*0.5;
        if (screenHeight>480) {
            rect.origin.y += 20;
        }
        rect.size.width = calleeNameLength;
        [self.calleeNameLabel setFrame:rect];
        [self addSubview:self.calleeNameLabel];
        
        //vip图标
        self.vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.calleeNameLabel.frame), CGRectGetMinY(self.calleeNameLabel.frame)+5, 23, 21)];
        self.vipImageView.image = [self getImageFromResourceBundleWithName:@"ws_v_logo_2" type:@"png"];
        [self addSubview:self.vipImageView];
        if (!flag) {
            self.vipImageView.hidden = YES;
        }
        
        //被叫人电话号码和归属地
        self.calleeNumberAndPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.calleeNameLabel.frame)+12,
                                                                                   (screenWidth-20*0.5), 21)];
        self.calleeNumberAndPlaceLabel.textAlignment = NSTextAlignmentCenter;
        self.calleeNumberAndPlaceLabel.textColor = [UIColor whiteColor];
        self.calleeNumberAndPlaceLabel.font = [UIFont systemFontOfSize:16.0];
        self.calleeNumberAndPlaceLabel.text = [NSString stringWithFormat:@"%@  %@",calleeNumber,calleePlace];
        [self addSubview:self.calleeNumberAndPlaceLabel];
        
        //接听提示
        NSString *tipString = [NSString stringWithFormat:@"系统正在回拨到%@请注意接听", callerNumber];
        //主叫人电话号码高亮
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:tipString];
        if (callerNumber.length>0) {
            [string addAttribute:NSForegroundColorAttributeName
                           value:[UIColor greenColor]
                           range:[tipString rangeOfString:callerNumber]];
        }
        
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth-224)*0.5, CGRectGetMaxY(self.bgImageView.frame)+18, 224, 64)];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.font = [UIFont systemFontOfSize:17.0];
        self.tipLabel.numberOfLines = 0;
        [self.tipLabel setAttributedText:string];
        [self addSubview:self.tipLabel];
        
        //返回等待按钮
        self.backToWaitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backToWaitButton.frame = CGRectMake((screenWidth-120)*0.5, CGRectGetMaxY(self.tipLabel.frame)+18, 120, 44);
        [self.backToWaitButton setTitle:@"返回等待" forState:UIControlStateNormal];
        self.backToWaitButton.backgroundColor = [UIColor colorWithRed:28/255.0 green:150/255.0 blue:20/255.0 alpha:1.0];
        self.backToWaitButton.layer.cornerRadius = 20;
        self.backToWaitButton.layer.masksToBounds = YES;
        [self.backToWaitButton addTarget:self action:@selector(backToWait:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backToWaitButton];
        
        return self;
    }
    return nil;
}

- (void)backToWait:(UIButton *)sender
{
    [self removeFromSuperview];
}

@end
