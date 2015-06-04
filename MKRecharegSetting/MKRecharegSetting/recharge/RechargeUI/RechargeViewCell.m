//
//  WSRechangeCell.m
//  WldhWeishuo
//
//  Created by xiongjie on 14-9-11.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "RechargeViewCell.h"
#import "UIImage+CZExtend.h"
@interface RechargeViewCell ()

@property (nonatomic, assign) SEL action;
@property (nonatomic, strong) id target;

@end

@implementation RechargeViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labName = [[UILabel alloc] initWithFrame:CGRectMake(23, 20, 200, 20)];
        self.labName.backgroundColor = [UIColor clearColor];
        self.labName.text = @"充满100元送200元";
        self.labName.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.labName];
        
        self.chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
            self.chargeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-70-17, 12.5, 70, 35);
        }else{
            self.chargeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-70-25, 12.5, 70, 35);
        }
        
        self.chargeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [self.chargeBtn.layer setMasksToBounds:YES];
        [self.chargeBtn.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
        [self.chargeBtn.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 6/255.0, 191/255.0, 4/255.0, 1 });
        [self.chargeBtn.layer setBorderColor:colorref];//边框颜色
        self.chargeBtn.backgroundColor = [UIColor whiteColor];
        [self.chargeBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
        [self.chargeBtn setTitle:@"￥100" forState:UIControlStateNormal];
        [self.chargeBtn setTitleColor:[UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.chargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.chargeBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.chargeBtn];
       
    }
    return self;
}
/**
-(id) init
{
    self = [super init];
    if (self){
        
    }
    return self;
}
 **/
- (void)buttonEvent:(UIButton *)button
{
    if (self.target && self.action && [self.target respondsToSelector:self.action]) {
       [self.target performSelector:self.action withObject:button];
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
