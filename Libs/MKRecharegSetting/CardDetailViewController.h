//
//  CardDetailViewController.h
//  WldhMini
//
//  Created by zhaojun on 14-6-20.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecharegeBaseViewController.h"
@interface CardDetailViewController : RecharegeBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, assign) BOOL isFailAction;
@property (nonatomic, strong) NSMutableArray *cardArr;
@property (nonatomic, strong) NSMutableArray *pwdArr;
@property (nonatomic, strong) NSMutableArray *statesArr;
@property (weak, nonatomic) IBOutlet UITableView *cardTable;
@property (weak, nonatomic) IBOutlet UIButton *subBt;
- (IBAction)subAction:(id)sender;

@end
