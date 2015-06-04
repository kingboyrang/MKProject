//
//  CacheDataUtil.h
//  CZBaseLib
//
//  Created by wulanzhou-mini on 15-5-26.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheDataUtil : NSObject

/**
 *  删除缓存值
 *
 *  @param key 缓存key
 */
+ (void)removeForKey:(NSString*)key;

/**
 *  设置缓存值
 *
 *  @param object 缓存值
 *  @param key    缓存key
 */
+ (void)setValue:(id)object  forKey:(NSString*)key;

/**
 *  设置缓存值(缓存值序列化)
 *
 *  @param object 缓存值
 *  @param key    缓存key
 */
+ (void)setValueArchiver:(id)object forKey:(NSString *)key;

/**
 *  取得缓存值
 *
 *  @param key 缓存key
 *
 *  @return 取得缓存值
 */
+ (id)valueForKey:(NSString*)key;

/**
 *  取得缓存值(缓存值反序列化)
 *
 *  @param key 缓存key
 *
 *  @return 取得缓存值(缓存值反序列化)
 */
+ (id)unarchiveValueForKey:(NSString*)key;

@end
