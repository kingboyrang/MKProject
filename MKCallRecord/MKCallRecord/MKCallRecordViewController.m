//
//  MKCallRecordViewController.m
//  MKCallRecord
//
//  Created by chenzhihao on 15-5-20.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKCallRecordViewController.h"
#import "MKCallRecordListCell.h"
#import "CZRequestHandler.h"
#import "CZServiceManager.h"
#import "CZRequestArgs.h"
#import "Md5Encrypt.h"
#import "MKCallBackManager.h"
#import "MKCallRecordDetailViewController.h"
#import "MKCallRecordUtils.h"
#import "RecordMegerNode.h"
#import "ContactRecordNode.h"
#import "ContactUtils.h"

@interface MKCallRecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL flag; //重新加载数据陌生号码不需要再次设置frame

@end

@implementation MKCallRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *aList = [[ContactManager shareInstance] megerContactRecord];
    self.recordArray = [[NSMutableArray alloc] initWithArray:aList];
    
    self.callRecordListTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.callRecordListTable.delegate = self;
    self.callRecordListTable.dataSource = self;
    self.callRecordListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.callRecordListTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contactDataChange:)
                                                 name:kNotifyContactDataChanged
                                               object:nil];
}

/**
 *  @brief  联系人数据发送改变
 *
 *  @param notification 编辑、删除联系人时的通知
 */
- (void)contactDataChange:(NSNotification *)notification
{
    self.flag = YES;
    //重新获取通话记录列表
    NSArray *aList = [[ContactManager shareInstance] megerContactRecord];
    self.recordArray = [[NSMutableArray alloc] initWithArray:aList];
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
}

/**
 *  @brief  刷新UI
 */
- (void)updateUI{
    @synchronized(self.callRecordListTable)
    {
        [self.callRecordListTable reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.flag = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//点击按钮进入通话记录详情
//传递参数为了拨打电话
- (void)cellDidSelected:(UIButton *)btn
{
    NSInteger index = btn.tag - 4120;
    RecordMegerNode *node = [self.recordArray objectAtIndex:index];
    MKCallRecordDetailViewController *detail = [[MKCallRecordDetailViewController alloc] init];
    detail.recordNode = node;
    [self.navigationController pushViewController:detail animated:YES];
}

//滑动事件，用于隐藏拨号盘，滑动发送通知
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recordListScrollToHideKeyboard" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

//编辑模式设置为删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//编辑模式下的标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//提交编辑
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    @synchronized(self)
    {
        if (indexPath.section >= 0 && indexPath.section < [self.recordArray count])
        {
            RecordMegerNode *aRecord = [self.recordArray objectAtIndex:indexPath.row];  //获取要删除的记录
            NSMutableArray *aList = [NSMutableArray arrayWithCapacity:0];
            for (ContactRecordNode *oneContactRecord in aRecord.lastRecordList)         //要删除的记录的最近的通话记录列表
            {
                [aList addObject:[NSNumber numberWithInteger:oneContactRecord.recordID]];   //recordID
            }
            
            if ([aList count] > 0)
            {
                if ([[ContactManager shareInstance].myRecordEngine deleteRecords:aList])   //批量删除通话记录
                {
                    NSMutableArray *bList = [NSMutableArray arrayWithCapacity:0];
                    [bList addObjectsFromArray:self.recordArray];
                    [bList removeObjectAtIndex:indexPath.row];
                    self.recordArray = bList;                   //获取剩余的通话记录
                    [self.callRecordListTable reloadData];      //重新加载tableview
                }
            }
        }
    }
}

//点击行直接打回拨
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RecordMegerNode *record = (RecordMegerNode *)[self.recordArray objectAtIndex:indexPath.row];
    MKCallBackManager *callBackManager = [MKCallBackManager shareInstance];
    callBackManager.calleePhoneNumber = record.phoneNumber;
    callBackManager.calleeName = [ContactUtils getContactNameByPhone:record.phoneNumber];
    callBackManager.calleePhonePlace = [ContactUtils getPlaceByPhone:record.phoneNumber];
    [callBackManager startCallBackInsertRecordblock:^{
        [MKCallRecordUtils insertOneCallRecord:record];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKCallRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"];
    if (cell==nil) {
        cell = [[MKCallRecordListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recordCell"];
    }
    RecordMegerNode *record = [self.recordArray objectAtIndex:indexPath.row];
    
    cell.nameLab.text = record.contactName;
    CGRect rect = cell.nameLab.frame;
    rect.size.width = [MKCallRecordUtils getLabelLength:cell.nameLab.text font:cell.nameLab.font];
    cell.nameLab.frame = rect;
    
    
    cell.placeLab.text = [MKCallRecordUtils getPlaceByPhone:record.phoneNumber];//号码归属地
    rect = cell.placeLab.frame;
    rect.size.width = [MKCallRecordUtils getLabelLength:cell.placeLab.text font:cell.placeLab.font];
    cell.placeLab.frame =rect;
    
    
    //通话次数
    cell.recordNumLab.text = [NSString stringWithFormat:@"(%ld)",(long)record.lastRecordList.count];
    rect = cell.recordNumLab.frame;
    if (cell.nameLab.frame.size.width>=cell.placeLab.frame.size.width) {
        rect.origin.x = CGRectGetMaxX(cell.nameLab.frame)+8;
    }
    else
    {
        rect.origin.x = CGRectGetMaxX(cell.placeLab.frame)+8;
    }
    cell.recordNumLab.frame = rect;
    
    //通话时间
    cell.lastTimeLab.text = [MKCallRecordUtils getTimeShowFormaterString:record.lastDateString];
    
    cell.operationBtn.tag = 4120+indexPath.row;
    [cell.operationBtn addTarget:self
                          action:@selector(cellDidSelected:)
                forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    ContactRecordNode *aNode = (ContactRecordNode *)record.lastRecordList[0];
    
    //通话类型
    if (aNode.recordType == 3) {
        cell.recordTypeImg.image = [MKCallRecordUtils getImageFromResourceBundleWithName:@"typehuru" type:@"png"];
    }
    else
    {
        cell.recordTypeImg.image = [MKCallRecordUtils getImageFromResourceBundleWithName:@"typehuchu" type:@"png"];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.8 green:.8 blue:.8 alpha:1.0];
    [cell.contentView addSubview:line];
    
    return cell;
}

@end
