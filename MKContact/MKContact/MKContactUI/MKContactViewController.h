//
//  MKContactViewController.h
//  MKContact
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKContactViewController : UIViewController

/**
 *  @brief  设置父视图控制器
 *
 *  @param parent   父视图控制器
 *
 */
- (void)setParentController:(UIViewController *)parent;

/**
 *  @brief  tableview row点击事件，默认跳转到联系人详情，子类可重写
 */
- (void)tableViewDidClicked;

/**
 *  @brief  创建新的联系人
 */
- (void)createNewContact;

@end
