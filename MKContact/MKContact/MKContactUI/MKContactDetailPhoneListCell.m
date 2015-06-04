//
//  MKContactDetailPhoneListCell.m
//  MKContact
//
//  Created by chenzhihao on 15-5-20.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKContactDetailPhoneListCell.h"
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
@implementation MKContactDetailPhoneListCell

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
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MKContactResource" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    //用对象mainBundle获取图片路径
    NSString *imagePath = [bundle pathForResource:imgName ofType:type];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    return image;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.phoneNumLab = [[UILabel alloc] initWithFrame:CGRectMake(33, 12, 160, 21)];
        self.phoneNumLab.textAlignment = NSTextAlignmentLeft;
        self.phoneNumLab.textColor = [UIColor blackColor];
        self.phoneNumLab.font = [UIFont systemFontOfSize:18.0];
        self.phoneNumLab.backgroundColor = [UIColor clearColor];
        
        self.phoneOnwerLab = [[UILabel alloc] initWithFrame:CGRectMake(33, 35, 160, 21)];
        self.phoneOnwerLab.textAlignment = NSTextAlignmentLeft;
        self.phoneOnwerLab.textColor = [UIColor lightGrayColor];
        self.phoneOnwerLab.font = [UIFont systemFontOfSize:13.0];
        self.phoneOnwerLab.backgroundColor = [UIColor clearColor];
        
        self.callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.callBtn.frame = CGRectMake(kScreenWidth-60, 15, 30, 30);
        self.callBtn.backgroundColor = [UIColor clearColor];
        [self.callBtn setBackgroundImage:[self getImageFromResourceBundleWithName:@"dial" type:@"png"] forState:UIControlStateNormal];
        
        [self addSubview:self.phoneNumLab];
        [self addSubview:self.phoneOnwerLab];
        [self addSubview:self.callBtn];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
