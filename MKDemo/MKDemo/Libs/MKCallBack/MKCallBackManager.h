//
//  MKCallBackManager.h
//  MKCallBack
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <Foundation/Foundation.h>

//回拨成功，用于插入一条通话记录
typedef void(^CallbackSuccess)(void);

@interface MKCallBackManager : NSObject
{
    CallbackSuccess InsertRecordBlock;
}

//回拨的电话号码
@property (nonatomic,copy) NSString *calleePhoneNumber;
//被叫人的姓名
@property (nonatomic,copy) NSString *calleeName;
//被叫人号码归属地
@property (nonatomic,copy) NSString *calleePhonePlace;

- (void)setUid:(NSString *)uid password:(NSString *)pwd brandId:(NSString *)bid serverAddr:(NSString *)srvAddr phone:(NSString *)phoneNum;

/**
 *  @brief  单例
 *
 *  @return 返回MKCallBackManager对象
 */
+ (MKCallBackManager*)shareInstance;

/**
 *  @brief  开始拨打回拨电话
 *
 *  @param block 处理插入通话记录的回调
 */
- (void)startCallBackInsertRecordblock:(CallbackSuccess)block;


@end
