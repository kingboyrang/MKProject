//
//  CallRecordDetailListCell.m
//  MKCallRecord
//  通话详情列表的cell
//  Created by chenzhihao on 15-5-21.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKCallRecordDetailListCell.h"
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
@implementation MKCallRecordDetailListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.recordTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 11, 130, 18)];
        self.recordTimeLabel.backgroundColor = [UIColor clearColor];
        self.recordTimeLabel.textColor =   [UIColor lightGrayColor];
        self.recordTimeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.recordTimeLabel];
        
        self.recordTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(156, 11, 75, 18)];
        self.recordTypeLabel.backgroundColor = [UIColor clearColor];
        self.recordTypeLabel.textColor = [UIColor lightGrayColor];
        self.recordTypeLabel.font = [UIFont systemFontOfSize:14.0];
        self.recordTypeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.recordTypeLabel];
        
        self.recordStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-75, 11, 75, 18)];
        self.recordStatusLabel.backgroundColor = [UIColor clearColor];
        self.recordStatusLabel.textColor = [UIColor lightGrayColor];
        self.recordStatusLabel.textAlignment = NSTextAlignmentCenter;
        self.recordStatusLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.recordStatusLabel];
        
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
