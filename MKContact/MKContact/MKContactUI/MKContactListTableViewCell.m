//
//  MKContactListTableViewCell.m
//  MKContact
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKContactListTableViewCell.h"

@implementation MKContactListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _contactHeader = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 44, 45)];
        _contactHeader.layer.cornerRadius = 5;
        _contactHeader.layer.masksToBounds = YES;
        [self.contentView addSubview:_contactHeader];
        
        _contactNameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_contactHeader.frame)+8, 16, 180, 28)];
        _contactNameLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _contactNameLable.backgroundColor = [UIColor clearColor];
        _contactNameLable.clearsContextBeforeDrawing = NO;
        _contactNameLable.font = [UIFont boldSystemFontOfSize:17.f];
        [self.contentView addSubview:_contactNameLable];
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
