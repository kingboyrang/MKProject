//
//  ShowContactSectionView.h
//  WldhMini
//
//  Created by ddm on 6/6/14.
//  Copyright (c) 2014 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowContactSectionView : UIScrollView{
    NSInteger _selectIndex;
    NSMutableArray *labelArr;
}

@property (nonatomic, strong) NSArray *sectionList;

- (void)selectSection:(NSInteger)index;

@end
