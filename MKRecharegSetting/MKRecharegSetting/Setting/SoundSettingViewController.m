//
//  SoundSettingViewController.m
//  MKRechargeSetting
//
//  Created by wulanzhou-mini on 15-5-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "SoundSettingViewController.h"
#import "ConfigSettingHandler.h"

@interface SoundSettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *keyPressSwitch; //按键音
@property (weak, nonatomic) IBOutlet UISwitch *speechSoundSwitch;//语音提醒

@end

@implementation SoundSettingViewController

- (id)init{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"MKRechargeSettingRecource" withExtension:@"bundle"]];
    if ((self = [super initWithNibName:@"SoundSettingViewController" bundle:bundle]))
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"声音设置";
  
    
    [self.keyPressSwitch setOn:[ConfigSettingHandler isKeyPressSoundOn] animated:NO];
    [self.speechSoundSwitch setOn:[ConfigSettingHandler isSpeechRemindOn] animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//按键音设置
- (IBAction)keyPressSettingChange:(id)sender {
    UISwitch *target=(UISwitch*)sender;
    [ConfigSettingHandler setKeyPressSoundOn:target.on];
}

//语音提醒设置
- (IBAction)speechSoundSettingChange:(id)sender {
    UISwitch *target=(UISwitch*)sender;
    [ConfigSettingHandler setSpeechRemindOn:target.on];
}


@end
