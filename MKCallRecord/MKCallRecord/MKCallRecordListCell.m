//
//  CallRecordListCell.m
//  MKDemo
//
//  Created by chenzhihao on 15-5-20.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKCallRecordListCell.h"

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kWldhWeiShuoS3 kColorFromRGB(0x595959)

@implementation MKCallRecordListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(17, 13, 160, 20)];
        self.nameLab.backgroundColor = [UIColor clearColor];
        self.nameLab.textColor =   [UIColor blackColor];
        self.nameLab.font = [UIFont systemFontOfSize:17.0];
        [self.contentView addSubview:self.nameLab];
        
        self.placeLab = [[UILabel alloc] initWithFrame:CGRectMake(19, 35, 130, 20)];
        self.placeLab.backgroundColor = [UIColor clearColor];
        self.placeLab.textColor = kWldhWeiShuoS3;
        self.placeLab.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:self.placeLab];
        
        self.recordNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 50, 32)];
        self.recordNumLab.backgroundColor = [UIColor clearColor];
        self.recordNumLab.textColor = [UIColor lightGrayColor];
        self.recordNumLab.textAlignment = NSTextAlignmentLeft;
        self.recordNumLab.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:self.recordNumLab];
        
        self.lastTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-150, 15, 80, 30)];
        self.lastTimeLab.backgroundColor = [UIColor clearColor];
        self.lastTimeLab.textColor = [UIColor lightGrayColor];
        self.lastTimeLab.textAlignment = NSTextAlignmentRight;
        self.lastTimeLab.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.lastTimeLab];
        
        self.recordTypeImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lastTimeLab.frame)+5, 26, 8, 8)];
        self.recordTypeImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.recordTypeImg];
        
        self.operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.operationBtn.frame = CGRectMake(CGRectGetMaxX(self.recordTypeImg.frame), 0, 60, 60);
        self.operationBtn.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.operationBtn];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 17, 60, 25)];
        img.tag = self.operationBtn.tag + 100;
        img.image = [MKCallRecordUtils getImageFromResourceBundleWithName:@"callRecord_detail_normal" type:@"png"];
        [self.operationBtn addSubview:img];
        
        self.accessoryType = UITableViewCellAccessoryNone;
        
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
