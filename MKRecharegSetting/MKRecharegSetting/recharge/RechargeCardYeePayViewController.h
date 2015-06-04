//
//  RechargeCardViewController.h
//  WldhMini
//
//  Created by zhaojun on 14-6-19.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecharegeBaseViewController.h"
#import "RechargeNode.h"
#import "CardDetailViewController.h"

/**
 *
 *  联通卡，移动卡，电信卡充值
 */
@interface RechargeCardYeePayViewController : RecharegeBaseViewController<UITextFieldDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (assign, nonatomic)BOOL isCMCard;
@property (strong, nonatomic) RechargeNode *rechargeNode;
@property (nonatomic,strong)  NSString *paytypeStr; 
@property (nonatomic,strong)  NSString *payKindStr;
@property (strong, nonatomic) NSMutableArray *cardArr;
@property (strong, nonatomic) NSMutableArray *pwdArr;
@property (strong, nonatomic) NSMutableArray *statesArr;
@property (weak, nonatomic) NSString *isEditCardNO;
@property (weak, nonatomic) NSString *isEditCardPWD;
@property (weak, nonatomic) IBOutlet UIView *actionView;


@property(strong,nonatomic) IBOutlet UIButton * meshuobtn;

@property (weak, nonatomic) IBOutlet UIView *topTip;

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;
@property (weak, nonatomic) IBOutlet UITextField *cardNOText;
@property (weak, nonatomic) IBOutlet UITextField *cardPWdText;
- (IBAction)addCardAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *firstLine;
@property (weak, nonatomic) IBOutlet UILabel *pwdCount;
- (IBAction)backgroundTaped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *pwdinputImage;
- (IBAction)subAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *detailBt;
@property (weak, nonatomic) IBOutlet UIImageView *cardInputImage;
@property (weak, nonatomic) IBOutlet UIImageView *rechargeFailImage;
- (IBAction)goDetailAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *cardNOCount;
@property (weak, nonatomic) IBOutlet UILabel *cardTipLab;
@property (weak, nonatomic) IBOutlet UIButton *failNumCount;
@property (weak, nonatomic) IBOutlet UIImageView *circleImage;
@property (weak, nonatomic) IBOutlet UIView *secondLine;
- (IBAction)goSeefail:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitBt;
@end
