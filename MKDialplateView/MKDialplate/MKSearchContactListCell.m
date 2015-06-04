//
//  MKSearchContactListCell.m
//  MKDialplateView
//
//  Created by chenzhihao on 15-5-21.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKSearchContactListCell.h"
#import "FontManager.h"
#import "FontLabelStringDrawing.h"
#import "ContactNode.h"


//拨号盘搜索到的联系人部分高亮显示
#define kDialplateSearchContactHilightFont  [UIFont boldSystemFontOfSize:16]
#define kDialplateSearchContactHilightColor [UIColor blackColor]
#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kWldhWeiShuoS5 kColorFromRGB(0x06bf04)

@implementation MKSearchContactListCell
@synthesize contactNameLab;
@synthesize phoneNumberLab;

- (void)dealloc
{
    self.contactNameLab = nil;
    self.phoneNumberLab = nil;
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 名字
        // 名字
        self.contactNameLab = [[[FontLabel alloc] initWithFrame:CGRectMake(15, 11, 120, 32)] autorelease];
        [self.contactNameLab setLineBreakMode:NSLineBreakByTruncatingTail];
        self.contactNameLab.textAlignment = NSTextAlignmentLeft;
        self.contactNameLab.backgroundColor = UIColor.clearColor;
        self.contactNameLab.font = kDialplateSearchContactHilightFont;
        self.contactNameLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.contactNameLab];
        
        // 电话或者名字拼音
        self.phoneNumberLab = [[[FontLabel alloc] initWithFrame:CGRectMake(140, 11, 140, 32)] autorelease];
        [self.phoneNumberLab setLineBreakMode:NSLineBreakByTruncatingTail];
        self.phoneNumberLab.textAlignment = NSTextAlignmentLeft;
        self.phoneNumberLab.backgroundColor = UIColor.clearColor;
        self.phoneNumberLab.font = kDialplateSearchContactHilightFont;
        self.phoneNumberLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.phoneNumberLab];
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

// 判断字符串是否包含汉字
// string : 需要判断的字符串
- (BOOL)isContainChinese:(NSString*)string;
{
    for(int i = 0; i < [string length]; ++i)
    {
        unichar a = [string characterAtIndex:i];
        if(a >= 0x4e00 && a <= 0x9fff)
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)createCustomColorLabe:(T9ContactRecord*)contactRecordA
{
    UIColor *colorHot = kWldhWeiShuoS5;
    
    self.contactNameLab.zAttributedText = nil;
    self.contactNameLab.text = contactRecordA.strName;
    
    ZMutableAttributedString *str = nil;
    int nSearchGroup = contactRecordA.searchGroup;
    if ( (3 == nSearchGroup || 2 == nSearchGroup )
        && contactRecordA.rangeMatch.length > 0 )
    {
        str = [[ZMutableAttributedString alloc] initWithString:contactRecordA.strValue];
        if( contactRecordA.rangeMatch.location + contactRecordA.rangeMatch.length <= str.length )
        {
            [str addAttribute:ZForegroundColorAttributeName value:colorHot range:contactRecordA.rangeMatch];
        }
    }
    else if ( 1 == nSearchGroup && contactRecordA.rangeMatch.length > 0 )
    {
        str = [[ZMutableAttributedString alloc] initWithString:contactRecordA.strValue];
    }
    else if ( 4 == nSearchGroup && contactRecordA.rangeMatch.length > 0 )
    {
        str = [[ZMutableAttributedString alloc] initWithString:contactRecordA.strPinyinOfAcronym];
        NSString *strAcronym = contactRecordA.strValue;
        NSString *strPinyin = contactRecordA.strPinyinOfAcronym;
        NSInteger nextSearchBeginIndex = 0;
        for (NSInteger index = contactRecordA.rangeMatch.location;
             index < contactRecordA.rangeMatch.location + contactRecordA.rangeMatch.length;
             ++index)
        {
            NSRange tmpRange = [strPinyin rangeOfString:[strAcronym substringWithRange:NSMakeRange( index, 1)]
                                                options:NSCaseInsensitiveSearch
                                                  range:NSMakeRange(nextSearchBeginIndex,
                                                                    [strPinyin length] - nextSearchBeginIndex)];
            nextSearchBeginIndex = tmpRange.location + 1;
            if ( tmpRange.location != NSNotFound )
            {
                [str addAttribute:ZForegroundColorAttributeName value:colorHot range:tmpRange];
                tmpRange.location = NSNotFound;
            }
            else
            {
                break;
            }
        }
    }
    else
    {
        str = [[ZMutableAttributedString alloc] initWithString:contactRecordA.strValue];
    }
    
    if( str )
    {
        self.phoneNumberLab.zAttributedText = str;
        [str release];
    }
}

@end
