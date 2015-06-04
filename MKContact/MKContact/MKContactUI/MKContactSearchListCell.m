//
//  MKContactSearchListCell.m
//  TDIMDemo
//
//  Created by chenzhihao on 15-1-13.
//  Copyright (c) 2015年 Guoling. All rights reserved.
//

#import "MKContactSearchListCell.h"

@implementation MKContactSearchListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.headerImg.layer.cornerRadius = 5;
        self.headerImg.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerImg];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImg.frame)+3, 10, 150, 24)];
        [self.contentView addSubview:self.nameLabel];
        
        self.pingYingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+3, 14, 80, 20)];
        self.pingYingLabel.hidden = YES;
        self.pingYingLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.pingYingLabel];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImg.frame)+3, CGRectGetMaxY(self.nameLabel.frame), 180, 20)];
        self.numberLabel.font = [UIFont systemFontOfSize:15];
        self.numberLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.numberLabel];
        
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
