//
//  MKCallRecordDetailViewController.m
//  MKCallRecord
//
//  Created by chenzhihao on 15-5-21.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKCallRecordDetailViewController.h"
#import <AddressBookUI/AddressBookUI.h>

#import "MKCallRecordDetailListCell.h"
#import "CZRequestHandler.h"
#import "CZServiceManager.h"
#import "CZRequestArgs.h"
#import "Md5Encrypt.h"

#import "MKCallBackManager.h"
#import "ContactWrapper.h"
#import "ContactUtils.h"

// 颜色配置
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBAplha(r, g ,b , a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kWSButtonNormalColor [UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0]
#define kWSButtonHighlightColor [UIColor colorWithRed:2/255.0 green:157/255.0 blue:0/255.0 alpha:1.0]

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width

@interface MKCallRecordDetailViewController ()<ABNewPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ABPeoplePickerNavigationController *picker;

@property (nonatomic,strong) UILabel *phoneNumLab;
@property (nonatomic,strong) UILabel *phoneOnwerLab;
@property (nonatomic,strong) UILabel *nameLabel;

//显示联系人姓名的view
@property (nonatomic,strong) UIView *contactNameView;

//显示电话号码或者新建联系人的view
//是通讯录好友时显示电话号码，非通讯录好友则显示创建新联系人或者添加到现有联系人
@property (nonatomic,strong) UIView *showRecordPhoneNumberView;

//显示最近通话记录列表的tableView
@property (nonatomic,strong) UITableView *recordListTable;

//通话记录数据
@property (nonatomic, strong) NSMutableArray *recordArray;

//编辑联系人的viewController
@property (nonatomic, strong) ABPersonViewController *personViewController;

//是否是通讯录好友
@property (nonatomic, assign) BOOL isContacts;

@end

@implementation MKCallRecordDetailViewController

/**
 *  @brief  初始化UI
 */
- (void)initUI
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.contactNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80)];
    self.contactNameView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contactNameView];
    
    //根据电话号码匹配通讯录
    ContactNode *tmpNode =[[ContactManager shareInstance] contactInfoWithPhone:self.recordNode.phoneNumber];
    //匹配成功，则是联系人
    if (tmpNode != nil)
        self.isContacts = YES;
    
    if (self.isContacts)        //如果是联系人
    {
        self.contactNode = tmpNode;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, 200, 30)];
        self.nameLabel.text = self.recordNode.contactName;
        self.nameLabel.font = [UIFont boldSystemFontOfSize:22.0];
        [self.contactNameView addSubview:self.nameLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, screenWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        [self.contactNameView addSubview:line];
        
        [self.view addSubview:self.contactNameView];
        
        //电话列表
        self.showRecordPhoneNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contactNameView.frame), screenWidth, 60)];
        self.phoneNumLab = [[UILabel alloc] initWithFrame:CGRectMake(33, 12, 160, 21)];
        self.phoneNumLab.textAlignment = NSTextAlignmentLeft;
        self.phoneNumLab.textColor = [UIColor blackColor];
        self.phoneNumLab.font = [UIFont systemFontOfSize:18.0];
        self.phoneNumLab.backgroundColor = [UIColor clearColor];
        self.phoneNumLab.text = self.recordNode.phoneNumber;
        [self.showRecordPhoneNumberView addSubview:self.phoneNumLab];
        
        self.phoneOnwerLab = [[UILabel alloc] initWithFrame:CGRectMake(33, 35, 160, 21)];
        self.phoneOnwerLab.textAlignment = NSTextAlignmentLeft;
        self.phoneOnwerLab.textColor = [UIColor lightGrayColor];
        self.phoneOnwerLab.font = [UIFont systemFontOfSize:13.0];
        self.phoneOnwerLab.backgroundColor = [UIColor clearColor];
        self.phoneOnwerLab.text = [MKCallRecordUtils getPlaceByPhone:self.recordNode.phoneNumber];
        [self.showRecordPhoneNumberView addSubview:self.phoneOnwerLab];
        
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        callBtn.frame = CGRectMake(kScreenWidth-60, 15, 30, 30);
        callBtn.backgroundColor = [UIColor clearColor];
        [callBtn setBackgroundImage:[MKCallRecordUtils getImageFromResourceBundleWithName:@"dial" type:@"png"] forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(makeCall:) forControlEvents:UIControlEventTouchUpInside];
        [self.showRecordPhoneNumberView addSubview:callBtn];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, screenWidth, 0.5)];
        line2.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        [self.showRecordPhoneNumberView addSubview:line2];
        
        [self.view addSubview:self.showRecordPhoneNumberView];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(5, 0, 40, 30);
        [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [rightButton setTitleColor:kWSButtonNormalColor forState:UIControlStateNormal];
        [rightButton setTitleColor:kWSButtonHighlightColor forState:UIControlStateHighlighted];
        
        [rightButton addTarget:self action:@selector(editContact) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        
    }
    // 陌生人
    else
    {
        // 陌生人只需要显示号码
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 33, 200, 21)];
        phoneLabel.text = self.recordNode.phoneNumber;
        phoneLabel.font = [UIFont boldSystemFontOfSize:18.0];
        phoneLabel.textColor = [UIColor blackColor];
        phoneLabel.text = self.recordNode.phoneNumber;
        [self.contactNameView addSubview:phoneLabel];
        
        UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 58, 200, 21)];
        placeLabel.text = self.recordNode.phoneNumber;
        placeLabel.font = [UIFont systemFontOfSize:14.0];
        placeLabel.textColor = [UIColor lightGrayColor];
        placeLabel.text = [MKCallRecordUtils getPlaceByPhone:self.recordNode.phoneNumber];
        [self.contactNameView addSubview:placeLabel];
        
        UIButton *dialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dialBtn setFrame:CGRectMake(kScreenWidth-60, 40, 30, 26)];
        dialBtn.backgroundColor = [UIColor clearColor];
        [dialBtn setBackgroundImage:[MKCallRecordUtils getImageFromResourceBundleWithName:@"dial" type:@"png"] forState:UIControlStateNormal];
        [dialBtn addTarget:self action:@selector(makeCall:) forControlEvents:UIControlEventTouchUpInside];
        [self.contactNameView addSubview:dialBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, screenWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        [self.contactNameView addSubview:line];
        
        [self.view addSubview:self.contactNameView];
        
        //创建新联系人 添加到现有联系人列表
        self.showRecordPhoneNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contactNameView.frame), screenWidth, 120)];
        for(int i=0; i<2; i++)
        {
            UIButton *addContactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addContactBtn.tag = i;
            addContactBtn.frame = CGRectMake(0, 60 * i, screenWidth, 59);
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, 180, 30)];
            title.text = (0==i)?@"创建新联系人":@"添加到现有联系人";
            title.font = [UIFont systemFontOfSize:18.0];
            title.textColor = RGB(6, 191, 4);
            [addContactBtn addSubview:title];
            [addContactBtn setBackgroundImage:[MKCallRecordUtils imageWithColor:RGB(240, 240, 240)] forState:UIControlStateHighlighted];
            [addContactBtn addTarget:self action:@selector(addContactBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.showRecordPhoneNumberView addSubview:addContactBtn];
            
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5+60 * i, screenWidth, 0.5)];
            bottomLine.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
            [self.showRecordPhoneNumberView addSubview:bottomLine];
        }
    }
    [self.view addSubview:self.showRecordPhoneNumberView];
    
    // 添加记录表格
    self.recordListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.showRecordPhoneNumberView.frame), screenWidth, screenHeight-self.contactNameView.frame.size.height-self.showRecordPhoneNumberView.frame.size.height) style:UITableViewStylePlain];
    self.recordListTable.delegate = self;
    self.recordListTable.dataSource = self;
    self.recordListTable.bounces = NO;
    self.recordListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.recordListTable];
    
    //用户数据发送改变时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contactDataChange:)
                                                 name:kNotifyContactDataChanged
                                               object:nil];
}

//表示当前用户信息发生改变
- (void)contactDataChange:(NSNotification *)notification
{
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
}

/**
 *  @brief  刷新UI
 */
- (void)updateUI{
    ContactNode *node = [[ContactManager shareInstance] getOneContactByID:self.recordNode.contactID];
    if (node==nil) {
        return;
    }
    self.contactNode = node;
    self.nameLabel.text = [self.contactNode getContactFullName];
}

/**
 *  @brief  初始化通话记录数据
 */
- (void)initDataSource
{
    for (ContactRecordNode *aRecord in self.recordNode.lastRecordList) {
        if ([aRecord.phoneNum isEqualToString:self.recordNode.phoneNumber]) {
            if (self.recordArray == nil)
                self.recordArray = [NSMutableArray arrayWithCapacity:0];
            if (![self.recordArray containsObject:aRecord]) {
                [self.recordArray addObject:aRecord];
            }
        }
    }
}

- (void)addContactBtnAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    if (0 == tag) {     //添加新的联系人
        [[ContactWrapper shareWrapper] addNewContactWithPhone:self.recordNode.phoneNumber rootViewController:self];
    }
    else    //添加到现有联系人
    {
        self.picker = [[ABPeoplePickerNavigationController alloc] init];
        self.picker.navigationController.title = @"选中联系人";
        self.picker.navigationBar.tintColor = kWSButtonNormalColor;
        self.picker.peoplePickerDelegate = self;
        [self presentViewController:self.picker animated:YES completion:nil];
    }
}

- (void)makeCall:(UIButton *)sender
{
    MKCallBackManager *callBackManager = [MKCallBackManager shareInstance];
    callBackManager.calleePhoneNumber = self.recordNode.phoneNumber;
    callBackManager.calleeName = [ContactUtils getContactNameByPhone:self.recordNode.phoneNumber];
    callBackManager.calleePhonePlace = [ContactUtils getPlaceByPhone:self.recordNode.phoneNumber];
    [callBackManager startCallBackInsertRecordblock:^{
        [MKCallRecordUtils insertOneCallRecord:self.recordNode];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"通话详情";
    [self initDataSource];
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callRecordRefresh:)
                                                 name:@"CallRecordRefresh"
                                               object:nil];
}

#pragma mark - 通话记录数据更新
- (void)callRecordRefresh:(NSNotification *)notify
{
    NSDictionary *userInfo = [notify userInfo];
    if (userInfo)
    {
        ContactRecordNode *aRecord = [userInfo objectForKey:@"Record"];
        if (aRecord && [aRecord isKindOfClass:[ContactRecordNode class]])
        {
            if ([aRecord.phoneNum isEqualToString:self.recordNode.phoneNumber])
            {
                [self performSelectorOnMainThread:@selector(addNewRecord:) withObject:aRecord waitUntilDone:YES];
            }
        }
    }
}

- (void)addNewRecord:(ContactRecordNode *)oneRecord
{
    if (nil == oneRecord || ![oneRecord isKindOfClass:[ContactRecordNode class]])
    {
        return;
    }
    
    @synchronized(self)
    {
        [self.recordNode.lastRecordList insertObject:oneRecord atIndex:0];
        [self.recordArray insertObject:oneRecord atIndex:0];
        [self.recordListTable reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 编辑联系人
/**
 *  @brief  编辑联系人
 */
- (void)editContact
{
    if ((self.contactNode != nil) && (kInValidContactID != self.contactNode.contactID))
    {
        ABAddressBookRef addressBookhandle = [[ContactManager shareInstance] contactAddressBook];
        ABRecordRef onePerson = [[ContactManager shareInstance] getOneABRecordWithID:self.contactNode.contactID
                                                                       inAddressBook:addressBookhandle];
        if (NULL != onePerson)
        {
            [self createEditVC:onePerson];
        }
    }
}

- (void)createEditVC:(ABRecordRef)person
{
    ABNewPersonViewController *npvc = [[ABNewPersonViewController alloc] init];
    [npvc setTitle:@"编辑"];
    [npvc setDisplayedPerson:person];
    [npvc setNewPersonViewDelegate:self];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
        npvc.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelContactEdit)];
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:npvc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)cancelContactEdit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)editingCanceled:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    self.personViewController.personViewDelegate = nil;
}

- (void)editingFinished:(id)sender
{
    [ContactManager shareInstance].canLoadData = NO;
    [self.personViewController setEditing:NO];
    
    BOOL ret = ABAddressBookSave(self.personViewController.addressBook, nil);
    [ContactManager shareInstance].canLoadData = YES;
    
    if (ret) {
        NSLog(@"编辑联系人保存成功");
        [[ContactManager shareInstance] loadAllContact];
    } else {
        NSLog(@"编辑联系人保存失败");
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.personViewController.personViewDelegate = nil;
}

#pragma mark - 代理方法
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
}

#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKCallRecordDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[MKCallRecordDetailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    ContactRecordNode *aNode = (ContactRecordNode *)self.recordArray[indexPath.row];
    
    //通话时间
    cell.recordTimeLabel.text = [MKCallRecordUtils dialDate:aNode.recordDateString];
    
    // 拨打类型
    NSString *callTypeStr =@"";
    switch (aNode.recordType) {
        case 0:
            callTypeStr = @"（呼出）";     // 免费
            break;
        case 1:
            callTypeStr = @"（呼出）";     // 直拨
            break;
        case 2:
            callTypeStr = @"（呼出）";     // 回拨
            break;
        case 3:
            callTypeStr = @"（呼入）";     // 免费
            break;
        default:
            callTypeStr = @"--";
            break;
    }
    cell.recordTypeLabel.text = callTypeStr;
    
    //通话时长
    NSInteger minute = aNode.recordTotalTime / 60;
    NSInteger second = aNode.recordTotalTime % 60;
    if (minute > 0 || second > 0)
    {
        NSMutableString *aStr = [NSMutableString stringWithString:@""];
        if (minute > 0)
        {
            [aStr appendFormat:@"%ld分钟",(long)minute];
        }
        
        if (second > 0)
        {
            [aStr appendFormat:@"%ld秒",(long)second];
        }
        
        cell.recordStatusLabel.text = [NSString stringWithFormat:@"%@",aStr];
    }
    else
    {
        cell.recordStatusLabel.text = (aNode.recordType == 0 || aNode.recordType == 1 || aNode.recordType == 2 ) ?  @"未接通" :@"" ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    // 需要新增的号码
    NSString *phoneNumer = self.recordNode.phoneNumber;
    
    ABRecordRef aa = person;
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutableCopy (ABRecordCopyValue(aa, kABPersonPhoneProperty)) ;
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)phoneNumer, kABPersonPhoneOtherFAXLabel, NULL);
    ABRecordSetValue(aa, kABPersonPhoneProperty, multiPhone,nil);
    
    ABNewPersonViewController *npvc = [[ABNewPersonViewController alloc] init];
    [npvc setTitle:@"添加至联系人"];
    [npvc setDisplayedPerson:aa];
    [npvc setNewPersonViewDelegate:self];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:npvc];
    [peoplePicker presentViewController:nav animated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    return NO;
}

@end
