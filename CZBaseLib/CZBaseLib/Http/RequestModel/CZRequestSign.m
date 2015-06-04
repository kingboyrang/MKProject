//
//  CZRequestSign.m
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-13.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "CZRequestSign.h"
#import "codes.h"
#import "Md5Encrypt.h"

@implementation CZRequestSign

-(id)init{
    if (self=[super init]) {
        self.password=@"";
        self.agwAn=@"1";
        self.agwKn=@"1";
        self.agwTK=@"";
    }
    return self;
}

- (NSString *)GetUrlUidSign:(NSDictionary *)dic{
    NSArray *keys = [dic allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSString *strURLSign = @"";
    
    for (NSString *categoryId in sortedArray)
    {
        strURLSign = [NSString stringWithFormat:@"%@%@=%@", strURLSign, categoryId, [dic objectForKey:categoryId]];
    }
    
    //参加sign计算的末尾拼接md5密码
    NSString *strPwd = @"";
    if(self.password&&[self.password length] > 0)
    {
        strPwd = [Md5Encrypt md5:self.password];
    }
    
    strURLSign = [NSString stringWithFormat:@"%@%@", strURLSign, strPwd];
    
    //获取认证签名所需的参数
    char *src = (char *)[strURLSign UTF8String];
    int srclen = 0;
    if(src)
    {
        srclen = (int)strlen(src);
    }
    
    char *keystr = NULL;
    int keylen = 0;
    if([self.agwTK length] > 0)
    {
        keystr = (char *)[self.agwTK UTF8String];
        keylen = (int)strlen(keystr);
    }
    
    int deType = [self.agwAn intValue];
    int keyType = [self.agwKn intValue];
    
    char *buff = KcDecode(src, keystr, srclen, deType, keyType, keylen);
    
    strURLSign = [NSString stringWithUTF8String:buff];
    
    return strURLSign;
}
@end
