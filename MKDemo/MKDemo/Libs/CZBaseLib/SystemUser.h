//
//  SystemUser.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-22.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZBaseObject.h"

/**
 * 登录用户信息
 */
@interface SystemUser : CZBaseObject

+ (SystemUser*)shareInstance;

/**
 *  用户名称
 */
@property (nonatomic,strong) NSString *name;
/**
 *  手机号码
 */
@property (nonatomic,strong) NSString *phone;
/**
 *  用户UID号
 */
@property (nonatomic,strong) NSString *userId;
/**
 *  用户密码
 */
@property (nonatomic,strong) NSString *password;
/**
 *  是否登陆
 */
@property (nonatomic,assign) BOOL isLogin;


/**
 *  用户信息保存
 */
- (void)saveUser;
/**
 *  用户信息删除
 */
- (void)removeUser;

@end
