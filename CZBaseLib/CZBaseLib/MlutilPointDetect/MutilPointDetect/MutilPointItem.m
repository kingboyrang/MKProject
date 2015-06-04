//
//  MlutilPointItem.m
//  MultipleAccessDemo
//
//  Created by wulanzhou-mini on 15-4-15.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "MutilPointItem.h"
#import "ServiceOperation.h"
@interface MutilPointItem ()
@property (nonatomic,strong) ServiceOperation  *operation;
@end

@implementation MutilPointItem

- (id)initWithString:(NSString*)urlString{
    if (self=[super init]) {
        self.requestURLString=urlString;
        self.isFinished=NO;
    }
    return self;
}
/**
 *  构造初始化
 *
 *  @param urlString  请求的URL
 *  @param methodName 请求的方法名
 *
 *  @return 获取探入点对象
 */
- (id)initWithString:(NSString*)urlString method:(NSString*)methodName{
    if (self=[super init]) {
        self.requestURLString=urlString;
        self.isFinished=NO;
        self.methodName=methodName;
    }
    return self;
}
- (void)setRequestURLString:(NSString *)urlstring{
    if (_requestURLString!=urlstring) {
        _requestURLString=[self formatURLString:urlstring];
    }
}
- (void)setMethodName:(NSString *)method{
    if (_methodName!=method) {
        _methodName=method;
        self.operation=[[ServiceOperation alloc] initWithURL:[self GetOperationRequestURL]];
    }
}
//self.operation=[[ServiceOperation alloc] initWithURL:[NSURL URLWithString:self.requestURLString]];

- (ServiceOperation*)requestOperation{
    return self.operation;
}
- (NSURL*)GetOperationRequestURL{
    
    NSString *baseURL=self.requestURLString;
    NSRange range = [self.requestURLString rangeOfString:@"/$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        baseURL=[self.requestURLString substringToIndex:self.requestURLString.length-1];
    }

    NSString *method=self.methodName;
    if ([self.methodName hasPrefix:@"/"]) {
        method=[self.methodName substringFromIndex:1];
    }
    NSString *strURL=[NSString stringWithFormat:@"%@/%@",baseURL,method];
    return [NSURL URLWithString:strURL];
}
- (NSString*)formatURLString:(NSString*)urlStr{
    //地址+版本+品牌+version
    if (![urlStr hasPrefix:@"http"]) {
        return [NSString stringWithFormat:@"http://%@",urlStr];
    }
    return urlStr;
}

@end
