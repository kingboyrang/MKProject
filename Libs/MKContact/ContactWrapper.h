//
//  ContactWrapper.h
//  WldhMini
//  处理联系人相关的一些跳转，包含详情、发送短信、新建联系人
//  Created by mini1 on 14-7-4.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactManager.h"
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>


@interface ContactWrapper : NSObject<MFMessageComposeViewControllerDelegate,ABNewPersonViewControllerDelegate>

//新建联系人界面
@property (nonatomic, strong) ABNewPersonViewController  *myNewPersonController;

/**
 *  @brief  单例
 *
 *  @return ContactWrapper对象
 */
+ (ContactWrapper *)shareWrapper;

/**
 *  @brief  发送信息
 *
 *  @param phoneList        发送的电话号码
 *  @param msgContent       信息内容
 *  @param parentController 当前的视图控制器
 */
- (void)sendMessageWithPhones:(NSArray *)phoneList msgContent:(NSString *)msgContent rootViewController:(UIViewController *)parentController;

/**
 *  @brief  查看联系人详情
 *
 *  @param oneContact       对应的联系人结点
 *  @param parentController 当前的视图控制器
 */
- (void)showContactDetail:(ContactNode *)oneContact rootViewController:(UINavigationController *)parentController;

/**
 *  @brief  添加新联系人
 *
 *  @param phoneNum         添加到已有的电话号码，传入nil表示新建联系人，否则添加到已有的联系人
 *  @param parentController 当前的视图控制器
 */
- (void)addNewContactWithPhone:(NSString *)phoneNum rootViewController:(UIViewController *)parentController;

@end
