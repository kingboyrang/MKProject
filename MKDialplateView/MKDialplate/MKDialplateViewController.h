//
//  MKDialplateViewController.h
//  MKDialplateView
//
//  Created by chenzhihao on 15-5-21.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDialplateView.h"

@interface MKDialplateViewController : UIViewController 

//回拨相关参数
//被叫人的电话号码
@property (nonatomic,copy) NSString *calleePhoneNumber;
//呼叫人的UID
@property (nonatomic,copy) NSString *callerUid;
//呼叫人密码
@property (nonatomic,copy) NSString *callerPwd;
//品牌
@property (nonatomic,copy) NSString *brandId;
//服务器地址
@property (nonatomic,copy) NSString *mainHttpServerAddress;
//呼叫人的电话号码
@property (nonatomic,copy) NSString *callerPhoneNumber;


//显示拨号盘当前输入的电话号码字符串
@property (nonatomic,strong) UIView *showDialNumberView;

//拨号盘view
@property (nonatomic,strong) MKDialplateView *dialplateView;

/**
 *  @brief  重新布局，根据设置的frame进行重新布局
 */
- (void)UpdateUI;

@end
