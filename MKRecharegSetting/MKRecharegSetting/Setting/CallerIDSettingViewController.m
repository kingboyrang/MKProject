//
//  CallerIDSettingViewController.m
//  MKRecharegSetting
//
//  Created by wulanzhou-mini on 15-5-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "CallerIDSettingViewController.h"
#import "CZServiceManager.h"
#import "SVProgressHUD.h"

@interface CallerIDSettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *setSwitch;
@property (nonatomic, assign) BOOL callerIDFlag;
@end

@implementation CallerIDSettingViewController

- (id)init{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"MKRechargeSettingRecource" withExtension:@"bundle"]];
    if ((self = [super initWithNibName:@"CallerIDSettingViewController" bundle:bundle]))
    {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"来显设置";
    [self mangerCallerID:@"search"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//来显设置
- (IBAction)callerIDChanged:(id)sender {
    UISwitch *target=(UISwitch*)sender;
    if (!target.on) {
        [self mangerCallerID:@"stop"];
    } else {
        [self mangerCallerID:@"open"];
    }
}
//来显请求
- (void)mangerCallerID:(NSString *)state
{
    CZRequestArgs *args=[[CZRequestArgs alloc] init];
    args.serviceType=CZShowPhoneType;
    [args paramWithObjectsAndKeys:state,@"operate", nil];
    [[CZServiceManager shareInstance] requestServiceWithArgs:args completed:^(NSDictionary *userInfo) {
        NSNumber *result = [userInfo objectForKey:@"result"];
        if ([result integerValue] == 0){
            NSInteger status = [[userInfo objectForKey:@"status"] integerValue];
            if (status==2) {// 已关闭
                [self.setSwitch setOn:NO animated:NO];
                 self.callerIDFlag = NO;
            }
            else if (status==1) {// 已开启
                [self.setSwitch setOn:YES animated:NO];
                 self.callerIDFlag = YES;
            }else{
               [SVProgressHUD dismissWithError: [userInfo objectForKey:@"reason"] afterDelay:2];
            }
        }else {
            [SVProgressHUD dismissWithError: [userInfo objectForKey:@"reason"] afterDelay:2];
            [self.setSwitch setOn:self.callerIDFlag animated:NO];
        }
    }];
}

@end
