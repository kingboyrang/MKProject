//
//  ContactSearchNode.h
//  TDIMDemo
//
//  Created by chenzhihao on 15-1-16.
//  Copyright (c) 2015年 Guoling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactNode.h"
#import "T9ContactRecord.h"

@interface ContactSearchNode : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *number;
@property (nonatomic,strong) NSString *pinYing;
@property (nonatomic,assign) NSRange nameMatchRange;
@property (nonatomic,assign) NSRange numberMatchRange;
@property (nonatomic,assign) NSRange pinYingMatchRange;
@property (nonatomic,strong) T9ContactRecord *contactRecord;
@end
