//
//  RechargeNode.m
//  MKRecharegSetting
//
//  Created by wulanzhou-mini on 15-5-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "RechargeNode.h"
@implementation RechargeNode

- (NSString*)priceToStringText{
    NSString *ext=@"";
    if ([self.price intValue]%100>0) {
        ext=[NSString stringWithFormat:@".%d",[self.price intValue]%100];
        NSRange range=[ext rangeOfString:@"0" options:NSBackwardsSearch];
        while (range.location!=NSNotFound) {
            ext=[ext substringWithRange:NSMakeRange(0, range.length+1)];
            range=[ext rangeOfString:@"0" options:NSBackwardsSearch];
        }
    }
    NSString * pstr = [NSString stringWithFormat:@"￥%d%@" ,[self.price intValue]/100,ext];
    return pstr;
}
- (NSString*)moneyStr{
    NSString *ext=@"";
    if ([self.price intValue]%100>0) {
        ext=[NSString stringWithFormat:@".%d",[self.price intValue]%100];
        NSRange range=[ext rangeOfString:@"0" options:NSBackwardsSearch];
        while (range.location!=NSNotFound) {
            ext=[ext substringWithRange:NSMakeRange(0, range.length+1)];
            range=[ext rangeOfString:@"0" options:NSBackwardsSearch];
        }
    }
    NSString * pstr = [NSString stringWithFormat:@"%d%@" ,[self.price intValue]/100,ext];
    return pstr;
}
@end
