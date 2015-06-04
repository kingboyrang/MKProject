//
//  SettingsViewController.m
//  MKDemo
//
//  Created by chenzhihao on 15-5-28.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "SettingsViewController.h"
#import "RechargeViewController.h"
#import "CallerIDSettingViewController.h"
#import "DialSettingViewController.h"
#import "SoundSettingViewController.h"
#import "CZRequestHandler.h"
#import "CZMyLog.h"
#import "AppConfigManager.h"
#import "PayConfigHandler.h"
#import "SystemUser.h"
#import "CostQueryDetailViewController.h"
#import "MyCostDetail.h"

@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSArray *settingsArr;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化功能列表
    self.settingsArr = @[@"充值",@"拨打设置",@"声音设置",@"来显设置",@"话费收入",@"话单查询"];
    
    //初始化table
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.bounces = NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"indexPath.row=%ld",(long)indexPath.row);
    switch (indexPath.row) {
        case 0:
        {
            RechargeViewController *charge = [[RechargeViewController alloc] init];
            [self.navigationController pushViewController:charge animated:YES];
        }
            break;
        case 1:
        {
            DialSettingViewController *dial = [[DialSettingViewController alloc] init];
            [self.navigationController pushViewController:dial animated:YES];
        }
            break;
        case 2:
        {
            SoundSettingViewController *sound = [[SoundSettingViewController alloc] init];
            [self.navigationController pushViewController:sound animated:YES];
        }
            break;
        case 3:
        {
            CallerIDSettingViewController *caller = [[CallerIDSettingViewController alloc] init];
            [self.navigationController pushViewController:caller animated:YES];
        }
            break;
        case 4:
        {
            __block NSString *strURL=[MyCostDetail getIncomeExpendURLString];
            if (strURL==nil) {
                [MyCostDetail requestQueryCostWithCompleted:^(NSDictionary *userInfo) {
                    strURL=[MyCostDetail getCostDetailURLString];
                    CostQueryDetailViewController *query = [[CostQueryDetailViewController alloc] init];
                    query.requestURLString=strURL;
                    query.title=@"话费收入";
                    [self.navigationController pushViewController:query animated:YES];
                }];
                return;
            }
            CostQueryDetailViewController *query = [[CostQueryDetailViewController alloc] init];
            query.requestURLString=strURL;
            query.title=@"话费收入";
            [self.navigationController pushViewController:query animated:YES];
        }
            break;
        case 5:
        {
            
            __block NSString *strURL=[MyCostDetail getCostDetailURLString];
            if (strURL==nil) {
                [MyCostDetail requestQueryCostWithCompleted:^(NSDictionary *userInfo) {
                    strURL=[MyCostDetail getCostDetailURLString];
                    CostQueryDetailViewController *query = [[CostQueryDetailViewController alloc] init];
                    query.requestURLString=strURL;
                    query.title=@"话单查询";
                    [self.navigationController pushViewController:query animated:YES];
                }];
                return;
            }
            CostQueryDetailViewController *query = [[CostQueryDetailViewController alloc] init];
            query.requestURLString=strURL;
            query.title=@"话单查询";
            [self.navigationController pushViewController:query animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settingsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.settingsArr objectAtIndex:indexPath.row];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 54.5, [UIScreen mainScreen].bounds.size.width-10, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:line];
    
    return cell;
}

@end
