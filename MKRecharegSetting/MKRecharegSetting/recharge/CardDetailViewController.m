//
//  CardDetailViewController.m
//  WldhMini
//
//  Created by zhaojun on 14-6-20.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "CardDetailViewController.h"

#define failTag  100
#define editTag  101
#define cardTag  102
#define pwdTag   103
#define cardTextTag 104
#define pwdTextTag  105
#define saveTag 106
#define CARDTEXTLABEL	((UITextField *)[cell viewWithTag:104])
#define PWDTEXTLABEL	((UITextField *)[cell viewWithTag:105])
#define CARDLAB	((UILabel *)[cell viewWithTag:102])
#define PWDLAB	((UILabel *)[cell viewWithTag:103])
#define FAILBT	((UIImageView *)[cell viewWithTag:100])
#define EDITBT	((UIButton *)[cell viewWithTag:101])
#define SAVEBT	((UIButton *)[cell viewWithTag:106])

@interface CardDetailViewController ()

@end

@implementation CardDetailViewController
@synthesize cardTable,cardArr,pwdArr,subBt,statesArr,isFailAction;

- (id)init{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"MKRechargeSettingRecource" withExtension:@"bundle"]];
    if ((self = [super initWithNibName:@"CardDetailViewController" bundle:bundle]))
    {
        
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    CGRect temprect = cardTable.frame;
    temprect = CGRectMake(0, 0, 320, (cardArr.count*110 > (self.view.frame.size.height - 114))?(self.view.frame.size.height - 114):cardArr.count*110 + 60);
    cardTable.frame = temprect;
    NSLog(@"%@",NSStringFromCGRect(cardTable.frame));
    cardTable.backgroundColor = [UIColor clearColor];
    if (!(cardArr.count*110 > (self.view.frame.size.height - 114))) {
//        cardTable.scrollEnabled = false;
    }
    
    UIImage *callNormalBgImge = [UIImage imageNamed:@"greenBt-down.png"];
    UIImage *callDownBgImge = [UIImage imageNamed:@"greenBt-normal.png"];
    
    //UIImage *callNormalBgImge = [[[UIImage imageNamed:@"greenBt-down.png"] stretchableImageWithLeftCapWidth:45 topCapHeight:43] scaleToBigSize:CGSizeMake(540, 94)];
    //UIImage *callDownBgImge = [[[UIImage imageNamed:@"greenBt-normal.png"] stretchableImageWithLeftCapWidth:45 topCapHeight:43] scaleToBigSize:CGSizeMake(540, 94)];
    
    [subBt setBackgroundImage:callNormalBgImge forState:UIControlStateNormal];
    [subBt setBackgroundImage:callDownBgImge forState:UIControlStateHighlighted];
    if(isFailAction)
    {
        [subBt setTitle:@"继续提交" forState:UIControlStateNormal];
        [subBt setTitle:@"继续提交" forState:UIControlStateHighlighted];
    }
    else{
        [subBt setTitle:@"确定" forState:UIControlStateNormal];
        [subBt setTitle:@"确定" forState:UIControlStateHighlighted];
    }
    self.title = [NSString stringWithFormat:@"已输入(%d)",cardArr.count];
    cardTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cardArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdetify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        UILabel *carNameLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 23, 60, 22)];
        carNameLab.text = @"卡号：";
        carNameLab.textColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1.0];
        UILabel *pwdNameLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 60, 22)];
        pwdNameLab.text = @"密码：";
        pwdNameLab.textColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1.0];

        
        UILabel *cardLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 23, 200, 25)];
        cardLab.tag = cardTag;
        cardLab.textColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1.0];
        UILabel *pwdLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, 200, 25)];
        pwdLab.tag = pwdTag;
        pwdLab.textColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1.0];
        
        UITextField *cardText = [[UITextField alloc] initWithFrame:CGRectMake(95, 10, 170, 40)];
        cardText.textColor = [UIColor blackColor];
        cardText.tag = cardTextTag;
        cardText.hidden = YES;
        cardText.returnKeyType = UIReturnKeyDone;
        cardText.borderStyle = UITextBorderStyleRoundedRect;
        cardText.delegate = self;
        cardText.font = [UIFont systemFontOfSize:12];
        cardText.keyboardType = UIKeyboardTypeNumberPad;
        
        UITextField *pwdText = [[UITextField alloc] initWithFrame:CGRectMake(95, 60, 170, 40)];
        pwdText.textColor = [UIColor blackColor];
        pwdText.tag = pwdTextTag;
        pwdText.hidden = YES;
        pwdText.returnKeyType = UIReturnKeyDone;
        pwdText.borderStyle = UITextBorderStyleRoundedRect;
        pwdText.delegate = self;
        pwdText.font = [UIFont systemFontOfSize:12];
        pwdText.keyboardType = UIKeyboardTypeNumberPad;
        
        UIImageView *failMag = [[UIImageView alloc]initWithFrame:CGRectMake(10, 50, 20, 20)];
        failMag.tag = failTag;
        if (isFailAction) {
            failMag.hidden = NO;
        }else
        {
            failMag.hidden = YES;
        }
        
        
        UIButton *editBt = [UIButton buttonWithType:UIButtonTypeCustom];
        editBt.frame = CGRectMake(294, 7, 25, 25);
        editBt.tag = editTag;
        [editBt setBackgroundImage:[UIImage imageNamed:@"cardeditnormal.png"] forState:UIControlStateNormal];
        [editBt addTarget: self action:@selector(textEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *saveBt = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBt.frame = CGRectMake(285, 45, 30, 30);
        saveBt.tag = saveTag;
        [saveBt setBackgroundImage:[UIImage imageNamed:@"dialOn.png"] forState:UIControlStateNormal];
        [saveBt addTarget: self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        saveBt.hidden = YES;
      
        
        [cell addSubview:carNameLab];
        [cell addSubview:pwdNameLab];
        [cell addSubview:pwdText];
        [cell addSubview:cardText];
        [cell addSubview:cardLab];
        [cell addSubview:pwdLab];
        [cell addSubview:failMag];
        [cell addSubview:editBt];
        [cell addSubview:saveBt];
    }
    UIView * lineView  = [[UIView alloc] initWithFrame:CGRectMake( 0, 109.5, 320, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    [cell addSubview:lineView];
    CARDTEXTLABEL.text = [cardArr objectAtIndex:indexPath.row];
    PWDTEXTLABEL.text = [pwdArr objectAtIndex:indexPath.row];
    CARDLAB.text = [cardArr objectAtIndex:indexPath.row];
    PWDLAB.text = [pwdArr objectAtIndex:indexPath.row];
     NSString *tagStr = [statesArr objectAtIndex:statesArr.count -indexPath.row -1];
    if ([tagStr isEqualToString:@"yes"]) {
        FAILBT.image = [UIImage imageNamed:@"dialOff.png"];
        EDITBT.hidden = YES;
    }
    else{
        FAILBT.image = [UIImage imageNamed:@"recharge_card_fail.png"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textEdit:(id)sender
{
    UITableViewCell *cell = [[UIDevice currentDevice].systemVersion floatValue] >= 7.0 ? (UITableViewCell *)[[sender superview] superview] :(UITableViewCell *)[sender superview];
    CARDLAB.hidden = YES;
    PWDLAB.hidden = YES;
    CARDTEXTLABEL.hidden = NO;
    PWDTEXTLABEL.hidden = NO;
    EDITBT.hidden = YES;
    SAVEBT.hidden = NO;
    NSIndexPath *index = [cardTable indexPathForCell:cell];
    
        if (index.row >= 2) {
            [UIView animateWithDuration:0.5 animations:^{
                  [cardTable setContentOffset:CGPointMake(0, (index.row - 1)*110)];
            }];  
        }

}
-(void)saveAction:(id)sender
{
    UITableViewCell *cell = [[UIDevice currentDevice].systemVersion floatValue] >= 7.0 ? (UITableViewCell *)[[sender superview] superview] :(UITableViewCell *)[sender superview];
    SAVEBT.hidden = YES;
    EDITBT.hidden = NO;
    CARDLAB.hidden = NO;
    PWDLAB.hidden = NO;
    CARDTEXTLABEL.hidden = YES;
    PWDTEXTLABEL.hidden = YES;
    [CARDTEXTLABEL resignFirstResponder];
    [PWDTEXTLABEL resignFirstResponder];
    NSIndexPath *indexpath = [cardTable indexPathForCell:cell];
    [cardArr replaceObjectAtIndex:indexpath.row withObject:CARDTEXTLABEL.text];
    [pwdArr replaceObjectAtIndex:indexpath.row withObject:PWDTEXTLABEL.text];
    CARDLAB.text = CARDTEXTLABEL.text;
    PWDLAB.text = PWDTEXTLABEL.text;
    
    [UIView animateWithDuration:0.5 animations:^{
            [cardTable setContentOffset:CGPointMake(0, 0)];
        }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (IBAction)subAction:(id)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:cardArr forKey:@"card"];
    [dic setObject:pwdArr forKey:@"pwd"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cardChaged" object:nil userInfo:dic];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
