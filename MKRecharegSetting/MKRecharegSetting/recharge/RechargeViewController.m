//
//  RechargeViewController.m
//  MKRecharegSetting
//
//  Created by wulanzhou-mini on 15-5-20.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeViewCell.h"
#import "RechargeNode.h"
#import "RechargeManager.h"
#import "RechargeCardViewController.h"
#import "PayTypeViewController.h"
@interface RechargeViewController ()

@end

@implementation RechargeViewController

- (id)init{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"MKRechargeSettingRecource" withExtension:@"bundle"]];
    if ((self = [super initWithNibName:@"RechargeViewController" bundle:bundle]))
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listData=[NSMutableArray arrayWithCapacity:0];
    //设置数据源
    [self setRechargeDataSource];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
        self.rechargeTable.backgroundView = [[UIView alloc]init];
        self.rechargeTable.backgroundColor = [UIColor clearColor];
    }
    /**
    UIView *foot=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    foot.backgroundColor=[UIColor clearColor];
    self.rechargeTable.tableFooterView=foot;
    **/
   
}
//设置数据源
- (void)setRechargeDataSource{
    RechargeNode *node=[[RechargeNode alloc] init];
    node.goods_id=@"40010";//商品id
    node.product_id=@"";
    node.name=@"充值卡";
    node.price=@"";
    [self.listData addObject:node];
     
    
    NSArray *source=[RechargeManager getRechargeGoodsList];
    //重新加载数据源
    if ([source count]==0) {
        [RechargeManager requestRecharegWithCompleted:^(NSArray *rechargeList) {
            if ([rechargeList count]>0) {
                [self.listData addObjectsFromArray:rechargeList];
                // 主线程执行：
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.rechargeTable reloadData];
                });
            }
            
        }];
    }else{
        [self.listData addObjectsFromArray:source];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table Source & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.listData count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"rechargeIdentifier";
    RechargeViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[RechargeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    RechargeNode *mod=[self.listData objectAtIndex:indexPath.section];
    cell.labName.text = mod.name;
    [cell.chargeBtn setTitle:[mod priceToStringText] forState:UIControlStateNormal];
    [cell.chargeBtn setTitle:[mod priceToStringText] forState:UIControlStateHighlighted];
    if ([mod.goods_id isEqualToString:@"40010"]) {//充值卡
        cell.chargeBtn.hidden=YES;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.chargeBtn.hidden=NO;
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 12;
    }
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, 0)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0){
        view.backgroundColor = [UIColor clearColor];
    }else{
        view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RechargeNode *mod=[self.listData objectAtIndex:indexPath.section];
    [self selectedRechargeItem:mod];
    
}
- (void)selectedRechargeItem:(RechargeNode*)node{
    if ([node.goods_id isEqualToString:@"40010"]) {//充值卡
        RechargeCardViewController *card=[[RechargeCardViewController alloc] init];
        if (self.navigationController) {
            [self.navigationController pushViewController:card animated:YES];
        }else{
            [self presentModalViewController:card animated:YES];
        }
    }else{
        PayTypeViewController *payType=[[PayTypeViewController alloc] init];
        payType.rechargeNode=node;
        if (self.navigationController) {
            [self.navigationController pushViewController:payType animated:YES];
        }else{
            [self presentModalViewController:payType animated:YES];
        }
    }
}
@end
