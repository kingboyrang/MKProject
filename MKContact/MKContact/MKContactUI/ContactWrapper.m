//
//  ContactWrapper.m
//  WldhMini
//  处理联系人相关的一些跳转，包含详情、发送短信、新建联系人
//  Created by mini1 on 14-7-4.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "ContactWrapper.h"
#import "MKContactDetailViewController.h"

// 颜色配置
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBAplha(r, g ,b , a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kWSButtonNormalColor [UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0]
#define kWSButtonHighlightColor [UIColor colorWithRed:2/255.0 green:157/255.0 blue:0/255.0 alpha:1.0]
#define kWSRegisterBtnNormalColor [UIColor colorWithRed:44/255.0 green:109/255.0 blue:255/255.0 alpha:1.0]
#define kWSRegisterBtnHighlightColor [UIColor colorWithRed:32/255.0 green:83/255.0 blue:199/255.0 alpha:1.0]
#define kWSNavTextColor [UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1.0]

#define kWSSearchHightLightColor    [UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0]
#define kWSChatSettingColor         [UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0]

static ContactWrapper *stat_contactWrapper = nil;

@implementation ContactWrapper
{
    UIViewController * navcon;
}
@synthesize myNewPersonController;

/**
 *  @brief  单例
 *
 *  @return ContactWrapper对象
 */
+ (ContactWrapper *)shareWrapper
{
    @synchronized(self)
    {
        if (stat_contactWrapper == nil)
        {
            stat_contactWrapper = [[ContactWrapper alloc] init];
        }
    }
    return stat_contactWrapper;
}

/**
 *  @brief  发送信息
 *
 *  @param phoneList        发送的电话号码
 *  @param msgContent       信息内容
 *  @param parentController 当前的视图控制器
 */
- (void)sendMessageWithPhones:(NSArray *)phoneList msgContent:(NSString *)msgContent rootViewController:(UIViewController *)parentController
{
    if (nil == parentController) {
        return;
    }
    
    BOOL canSendMessage = [MFMessageComposeViewController canSendText];
    if (canSendMessage) {
        MFMessageComposeViewController *messageSendController = [[MFMessageComposeViewController alloc] init];
        messageSendController.messageComposeDelegate = self;
        messageSendController.recipients = phoneList;
        messageSendController.body = msgContent;

        [parentController presentViewController:messageSendController animated:YES completion:nil];
        messageSendController.navigationBar.tintColor = kWSButtonNormalColor;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"contact_send_message_err", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"contact_send_message_button", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

/**
 *  @brief  查看联系人详情
 *
 *  @param oneContact       对应的联系人结点
 *  @param parentController 当前的视图控制器
 */
- (void)showContactDetail:(ContactNode *)oneContact rootViewController:(UINavigationController *)parentController
{
    MKContactDetailViewController *detailVc = [[MKContactDetailViewController alloc] init];
    detailVc.aContact = oneContact;
    [parentController pushViewController:detailVc animated:YES];
}

/**
 *  @brief  添加新联系人
 *
 *  @param phoneNum         添加到已有的电话号码，传入nil表示新建联系人，否则添加到已有的联系人
 *  @param parentController 当前的视图控制器
 */
- (void)addNewContactWithPhone:(NSString *)phoneNum rootViewController:(UIViewController *)parentController
{
    if (nil == parentController)
    {
        return;
    }
    navcon = parentController;
    
    NSString *phoneNumer = phoneNum ? [NSString stringWithFormat:@"%@",phoneNum] : @"";
    ABRecordRef aContact = ABPersonCreate();
    CFErrorRef anError = NULL;
    ABMutableMultiValueRef phoneLabe = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneLabe,(__bridge CFStringRef)phoneNumer, kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(aContact, kABPersonPhoneProperty, phoneLabe, &anError);
    
    self.myNewPersonController = [[ABNewPersonViewController alloc] init];
    self.myNewPersonController.newPersonViewDelegate = self;
    self.myNewPersonController.displayedPerson = aContact;
    
    UINavigationController *aNav = [[UINavigationController alloc] initWithRootViewController:self.myNewPersonController];
#if TARGET_IPHONE_SIMULATOR
#else
    [ContactManager shareInstance].canLoadData = NO;
#endif
    [parentController presentViewController:aNav animated:YES completion:NULL];
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    [ContactManager shareInstance].canLoadData = YES;
    self.myNewPersonController.newPersonViewDelegate = nil;
    [newPersonView.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

@end
