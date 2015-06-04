//
//  ServiceQueue.m
//  URLConnectionServicesDemo
//
//  Created by aJia on 2014/3/11.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "ServiceOperationQueue.h"

@interface ServiceOperationQueue ()
@property (readwrite, nonatomic, copy) SOQFinishBlock finishBlock;
@property (readwrite, nonatomic, copy) SOQCompleteBlock completeBlock;
@end

@implementation ServiceOperationQueue
@synthesize items=items_;
- (void)dealloc{
    if (items_) {
        [items_ release],items_=nil;
    }
    [self cancelAllOperations];
    if (self.operations&&[self.operations count]>0) {
        for (id op in self.operations) {
            if ([op isKindOfClass:[ServiceOperation class]]) {
                ServiceOperation *operation=(ServiceOperation*)op;
                [operation removeObserver:self forKeyPath:@"isFinished"];
            }
            
        }
    }
    [super dealloc];
}
- (id)init{
    if (self=[super init]) {
        self.showNetworkActivityIndicator=YES;
        self.maxConcurrentOperationCount=10;
        items_=[[NSMutableArray alloc] init];
        finished_=NO;
        operTotal_=0;
    }
    return self;
}
- (BOOL)isFinished
{
    return finished_;
}
-(void)addOperation:(NSOperation *)op
{
    if ([op isKindOfClass:[ServiceOperation class]]) {
        NSLog(@"prev _item count =%lu",(unsigned long)items_.count);
        ServiceOperation *operation=(ServiceOperation*)op;
        NSLog(@"ServiceOperation url =%@",[[operation.request URL] absoluteString]);
        [operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
        /** **/
        if ([operation isFinished]) {
            [self handleOperation:operation];
            return;
        }
       
        
    }
    if (![self.operations containsObject:op]) {
        [super addOperation:op];
        operTotal_=[self.operations count];
    }
   
}
- (void)setFinishBlock:(SOQFinishBlock)afinishBlock{
    if (_finishBlock!=afinishBlock) {
        [_finishBlock release];
        _finishBlock=[afinishBlock copy];
    }
}
- (void)setCompleteBlock:(SOQCompleteBlock)acompleteBlock{
    if (_completeBlock!=acompleteBlock) {
        [_completeBlock release];
        _completeBlock=[acompleteBlock copy];
    }
}
- (void)reset{
    if (items_&&[items_ count]>0) {
        [items_ removeAllObjects];
    }
    [self cancelAllOperations];
    if (self.operations&&[self.operations count]>0) {
        for (id op in self.operations) {
            if ([op isKindOfClass:[ServiceOperation class]]) {
                ServiceOperation *operation=(ServiceOperation*)op;
                [operation removeObserver:self forKeyPath:@"isFinished"];
            }
            
        }
    }
    [self setSuspended:NO];
    [self willChangeValueForKey:@"isFinished"];
    finished_  = NO;
    [self didChangeValueForKey:@"isFinished"];
    
    if (self.showNetworkActivityIndicator) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (self.showNetworkActivityIndicator) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(self.operations.count>0)];
    }
    //表示其中一个请求完成
    if ([object isKindOfClass:[ServiceOperation class]]&&[keyPath isEqualToString:@"isFinished"]) {
        ServiceOperation *operation=(ServiceOperation*)object;
        [self handleOperation:operation];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)handleOperation:(ServiceOperation*)operation{
    if (!items_) {
        items_=[[NSMutableArray alloc] init];
    }
    [items_ addObject:operation];
    if (self.finishBlock) {
        self.finishBlock(operation);
    }
    [operation removeObserver:self forKeyPath:@"isFinished"];
  
    //表示所有请求完成
    if (operTotal_==[items_ count]) {
        [self setSuspended:YES];
        [self willChangeValueForKey:@"isFinished"];
        finished_  = YES;
        [self didChangeValueForKey:@"isFinished"];
        if (self.completeBlock) {
            self.completeBlock();
        }
    }
}
@end
