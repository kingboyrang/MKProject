//
//  ShowContactSectionView.m
//  WldhMini
//
//  Created by ddm on 6/6/14.
//  Copyright (c) 2014 Guoling. All rights reserved.
//

#import "ShowContactSectionView.h"



#define SectionHigh 55
#define SectionSpace 10
#define SectionWidth 55

#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define kWldhWeiShuoS3 kColorFromRGB(0x595959)
#define kWldhWeiShuoS11 kColorFromRGB(0x969696)

@implementation ShowContactSectionView

#pragma mark - LiftCycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self commonInit];  
    }
    return self;
}

#pragma mark - PrivateMethod

- (void)commonInit{
    self.backgroundColor = [UIColor clearColor];
    [self setShowsVerticalScrollIndicator:NO];
    _selectIndex = -1;
    [self setScrollEnabled:NO];
    labelArr = [NSMutableArray array];
}

- (void)setSectionList:(NSArray *)sectionList{
    _sectionList = sectionList;
    if ([_sectionList count]>0) {
       for (NSInteger i =0;i<_sectionList.count;i++) {
         UILabel *sectionLable = [[UILabel alloc] initWithFrame:CGRectMake(5, (i+5)*(SectionHigh - 13), SectionWidth-10, SectionHigh-10)];
//        UILabel *sectionLable = [[UILabel alloc] initWithFrame:CGRectMake(5, (i+5)*(SectionHigh + SectionSpace), 10, 10)];

            sectionLable.tag = 100+i;
            [sectionLable setText:[_sectionList objectAtIndex:i]];
            [sectionLable setFont:[UIFont systemFontOfSize:20]];
            [sectionLable setTextAlignment:NSTextAlignmentCenter];
            sectionLable.textColor = kWldhWeiShuoS3;
            [self addSubview:sectionLable];
           [labelArr addObject:sectionLable];
        }
    }
    self.contentSize = CGSizeMake(SectionWidth, (SectionHigh+SectionSpace)*(_sectionList.count+9)+SectionHigh);
}

- (void)selectSection:(NSInteger)index{
    // 选中圆圈的label
    UILabel *selectLable = (UILabel*)[self viewWithTag:100+index];
    selectLable.frame = CGRectMake(0, (index+5)*(SectionHigh - 13) + 10 , SectionWidth, SectionHigh);
    [selectLable setFont:[UIFont systemFontOfSize:25]];
    selectLable.backgroundColor = kWldhWeiShuoS11;
    selectLable.layer.cornerRadius = 28;
    selectLable.alpha = 0.65;
    selectLable.layer.masksToBounds = YES;
    selectLable.textColor = [UIColor whiteColor];
    if (_selectIndex > -1 && _selectIndex!=index) {
        UILabel *lastSelectLable = (UILabel*)[self viewWithTag:100+_selectIndex];
        lastSelectLable.frame = CGRectMake(5, (_selectIndex+5)*(SectionHigh - 13), SectionWidth-10, SectionHigh-10);
        [lastSelectLable setFont:[UIFont systemFontOfSize:20]];
        [lastSelectLable setTextColor:kWldhWeiShuoS3];
        lastSelectLable.backgroundColor = [UIColor clearColor];
        
        for (int i = 0; i < index; i ++) {
            UILabel *templabel = (UILabel *)[self viewWithTag:100+i];
            CGRect rect1 = CGRectMake(5, (i+5)*(SectionHigh - 13), SectionWidth-10, SectionHigh-10);
            templabel.frame = rect1;
        }
        
        for (int i = index + 1; i < _sectionList.count; i ++)
        {
            UILabel *templabel = (UILabel *)[self viewWithTag:100+i];
            CGRect rect1 = CGRectMake(5, (i+5)*(SectionHigh - 13) + 30, SectionWidth-10, SectionHigh-10);
            templabel.frame = rect1;
        }
    }

    _selectIndex = index;
    for (NSInteger i=index; i>-1; i--) {
        UILabel *SectionLable = (UILabel*)[self viewWithTag:100+i];
        SectionLable.alpha = 1.0-(index-i)*0.2;
    }
    for (NSInteger i=index; i<_sectionList.count; i++) {
        UILabel *SectionLable = (UILabel*)[self viewWithTag:100+i];
        SectionLable.alpha = 1.0-(i-index)*0.2;
    }
    [self scrollRectToIndex:index];
}

- (void)scrollRectToIndex:(NSInteger)index{
        self.contentOffset = CGPointMake(0, (SectionHigh- 13)*(index+1.5));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
