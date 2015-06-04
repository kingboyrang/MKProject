//
//  ViewController.m
//  MKDemo
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "ViewController.h"
#import "DialplateViewController.h"
#import "LoginViewController.h"
#import "CallBackViewController.h"
#import "ContactViewController.h"
#import "CallRecordListViewController.h"

#import "ContactManager.h"
#import "ContactUtils.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *funcsArray;
@property (nonatomic,strong) UITableView *functionsTable;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Demo";
    // Do any additional setup after loading the view, typically from a nib.
    
    self.funcsArray = @[@"登录",@"拨号盘",@"回拨",@"联系人",@"通话记录"];
    
    self.functionsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    self.functionsTable.delegate = self;
    self.functionsTable.dataSource = self;
    [self.view addSubview:self.functionsTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.funcsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.funcsArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            LoginViewController *loginVc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVc animated:YES];
        }
            break;
        case 1:
        {
            DialplateViewController *dialplateViewVc = [[DialplateViewController alloc] init];
            [self.navigationController pushViewController:dialplateViewVc animated:YES];
        }
            break;
        case 2:
        {
            CallBackViewController *callBackVc = [[CallBackViewController alloc] init];
            [self.navigationController pushViewController:callBackVc animated:YES];
        }
            break;
        case 3:
        {
            ContactViewController *contactVc = [[ContactViewController alloc] init];
            [self.navigationController pushViewController:contactVc animated:YES];
        }
            break;
        case 4:
        {
            CallRecordListViewController *callRecordListVc = [[CallRecordListViewController alloc] init];
            [self.navigationController pushViewController:callRecordListVc animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
