//
//  CacheDataUtil.m
//  CZBaseLib
//
//  Created by wulanzhou-mini on 15-5-26.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "CacheDataUtil.h"

@implementation CacheDataUtil

/**
 *  删除缓存值
 *
 *  @param key 缓存key
 */
+ (void)removeForKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  设置缓存值
 *
 *  @param object 缓存值
 *  @param key    缓存key
 */
+ (void)setValue:(id)object  forKey:(NSString*)key{
    if (object) {
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 *  设置缓存值(缓存值序列化)
 *
 *  @param object 缓存值
 *  @param key    缓存key
 */
+ (void)setValueArchiver:(id)object forKey:(NSString *)key{
    if (object) {
         NSData *data=[NSKeyedArchiver archivedDataWithRootObject:object];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 *  取得缓存值
 *
 *  @param key 缓存key
 *
 *  @return 取得缓存值
 */
+ (id)valueForKey:(NSString*)key{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:key]) {
        return [userDefault objectForKey:key];
    }
    return nil;
}

/**
 *  取得缓存值(缓存值反序列化)
 *
 *  @param key 缓存key
 *
 *  @return 取得缓存值(缓存值反序列化)
 */
+ (id)unarchiveValueForKey:(NSString*)key{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:key]) {
        NSData *data=[userDefault objectForKey:key];
       return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}
@end
