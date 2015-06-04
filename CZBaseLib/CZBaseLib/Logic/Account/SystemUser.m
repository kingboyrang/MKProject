//
//  SystemUser.m
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-22.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "SystemUser.h"
#import "CacheDataUtil.h"
#import "CZRequestHandler.h"
#define kCZSystemUserCacheKey @"kCZSystemUserCacheKey"

@implementation SystemUser

- (id)init{
    if (self=[super init]) {
        self.name=@"";
        self.phone=@"";
        self.userId=@"";
        self.password=@"";
        self.isLogin=NO;
    }
    return self;
}

+ (SystemUser*)shareInstance{
    SystemUser *config=[CacheDataUtil unarchiveValueForKey:kCZSystemUserCacheKey];
    if (config==nil) {
         config=[[SystemUser alloc] init];
    }
    return config;
}



/**
 *  用户信息保存
 */
- (void)saveUser{    
    [CacheDataUtil setValueArchiver:self forKey:kCZSystemUserCacheKey];
    if (self.userId&&[self.userId length]>0&&self.password&&[self.password length]>0) {
        [CZRequestHandler setUserId:self.userId password:self.password];
    }
}

/**
 *  用户信息删除
 */
- (void)removeUser{
    [CacheDataUtil removeForKey:kCZSystemUserCacheKey];
    [CZRequestHandler removeAccountAndPwd];
}
@end
