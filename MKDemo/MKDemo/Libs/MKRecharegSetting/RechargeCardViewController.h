//
//  KcCardViewController.h
//  WldhMini
//
//  Created by zhaojun on 14-6-18.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecharegeBaseViewController.h"
/**
 *  充值卡
 */
@interface RechargeCardViewController :RecharegeBaseViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UIButton *submitBt;
@property (weak, nonatomic) IBOutlet UIImageView *cardInputImage;

- (IBAction)submitAction:(id)sender;
- (IBAction)backgroundTaped:(id)sender;
@end
