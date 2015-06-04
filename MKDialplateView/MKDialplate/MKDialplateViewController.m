//
//  MKDialplateViewController.m
//  MKDialplateView
//
//  Created by chenzhihao on 15-5-21.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKDialplateViewController.h"
#import "MKSearchContactListCell.h"
#import "ContactWrapper.h"
#import "ContactManager.h"
#import "T9ContactRecord.h"
#import "ContactNode.h"
#import "MKDialplateUtils.h"
#import "MKCallRecordViewController.h"
#import "MKCallBackManager.h"
#import "MKContactDetailViewController.h"
#import "ContactUtils.h"
#import "MKCallRecordUtils.h"

#define kWSButtonNormalColor [UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0]
#define kWSButtonHighlightColor [UIColor colorWithRed:2/255.0 green:157/255.0 blue:0/255.0 alpha:1.0]

#define  kDialAddContactSheetTag 100091

@interface MKDialplateViewController ()<ABNewPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,DialplateKeyboardDelegate,UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UILabel *phoneNumberLabel;
@property (nonatomic,strong) UIButton *clearButton;
@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic,strong) ABPeoplePickerNavigationController *picker;

//通话记录列表
@property (nonatomic,strong) MKCallRecordViewController *callRecordsListVc;



//拨号盘T9搜索，显示联系人的tableview
@property (nonatomic,strong) UITableView *searchContactTable;

//搜索到的联系人的数组
@property (nonatomic,strong) NSMutableArray *searchResult;

//当前显示的号码长度 (可能是空得)
@property (nonatomic,assign) NSInteger currentNumLength;

//临时号码,从拨号盘传入打电话界面
@property (nonatomic,strong) NSString *tempnumdata;
//联系人搜索键值
@property(nonatomic,strong) NSString *t9pushKeyStr;

@end

@implementation MKDialplateViewController
{
    NSString    *numStr;//获取粘贴号码的数据
    BOOL        _isInput;  //是否输入
    BOOL        _isGoingtoNewContact;  //是否新建联系人
    CGFloat     oldFrameOriginalY;
    
    NSString    *_callContactName;
    NSInteger   _callContactID;
}

/**
 *  @brief  初始化UI
 */
- (void)initUI
{
    //用于显示输入的号码的view
    self.showDialNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.showDialNumberView.backgroundColor = [UIColor whiteColor];
    self.showDialNumberView.hidden = YES;
    //显示号码
    self.phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, [UIScreen mainScreen].bounds.size.width-80, 40)];
    self.phoneNumberLabel.backgroundColor = [UIColor whiteColor];
    self.phoneNumberLabel.font = [UIFont systemFontOfSize:26.0];
    [self.showDialNumberView addSubview:self.phoneNumberLabel];
    //一键清除按钮
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearButton.frame = CGRectMake(CGRectGetMaxX(self.phoneNumberLabel.frame), 0, 50, 44);
    self.clearButton.backgroundColor = [UIColor clearColor];
    self.clearButton.hidden = YES;
    [self.clearButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 26, 26)];
    imgView.image = [MKDialplateUtils getImageFromResourceBundleWithName:@"clear" type:@"png"];
    [self.clearButton addSubview:imgView];
    [self.showDialNumberView addSubview:self.clearButton];
    
    //搜索联系人列表
    self.searchContactTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.searchContactTable.delegate = self;
    self.searchContactTable.dataSource = self;
    self.searchContactTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchContactTable.hidden = YES;
    [self.view addSubview:self.searchContactTable];
    
    //通话记录列表
    self.callRecordsListVc = [[MKCallRecordViewController alloc] init];
    self.callRecordsListVc.view.frame = self.view.bounds;
    [self addChildViewController:self.callRecordsListVc];
    [self.view addSubview:self.callRecordsListVc.view];
    
    //拨号盘
    self.dialplateView = [[MKDialplateView alloc] initWithPosition:CGPointMake(0, self.view.bounds.size.height-285)];
    self.dialplateView.delegate = self;
    [self.view addSubview:self.dialplateView];
    
    //通话列表滚动监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recordListScrollToHideKeyboard)
                                                 name:@"recordListScrollToHideKeyboard"
                                               object:nil];
    //刷新通话记录
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callRecordDataRefresh:)
                                                 name:@"CallRecordRefresh"
                                               object:nil];
}

/**
 *  @brief  通话记录滚动隐藏拨号盘
 */
- (void)recordListScrollToHideKeyboard
{
    [self.dialplateView hideDialplate];
    //发出通知
    if (!self.dialplateView.hidden) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dialplateIsHidden" object:nil];
    }
}

//刷新通话记录
- (void)callRecordDataRefresh:(NSNotification *)notify
{
    NSArray *aList = [[ContactManager shareInstance] megerContactRecord];
    NSMutableArray *dataList = [NSMutableArray arrayWithCapacity:0];
    [dataList addObjectsFromArray:aList];
    [self performSelectorOnMainThread:@selector(reloadData:)
                           withObject:dataList
                        waitUntilDone:YES];
}

- (void)reloadData:(NSArray *)aList
{
    @synchronized(self)
    {
        NSMutableArray *bList = [NSMutableArray arrayWithCapacity:0];
        [bList addObjectsFromArray:aList];
        self.callRecordsListVc.recordArray = bList;
        [self.callRecordsListVc.callRecordListTable reloadData];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//UI重新布局
- (void)UpdateUI
{
    //拨号盘的布局
    CGRect rect = self.dialplateView.frame;
    rect.origin.y = self.view.frame.size.height - 285;
    self.dialplateView.frame = rect;
    //搜索联系人的布局
    rect = self.searchContactTable.frame;
    rect.size.height = self.view.frame.size.height;
    rect.size.width = self.dialplateView.frame.size.width;
    self.searchContactTable.frame = rect;
    //通话记录的布局
    rect = self.callRecordsListVc.view.frame;
    rect.size.height = self.view.bounds.size.height;
    self.callRecordsListVc.view.frame = rect;
}

//一键清除输入的内容
- (void)clearButtonAction:(UIButton *)sender
{
    [self DialplateViewLongPress];
}

//初始化数据源
- (void)initDataSource
{
    self.searchResult = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self UpdateUI];
    [self initDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - T9搜索相关
//输入一个字符
- (void)pushOneKey:(NSInteger)aKey
{
    @synchronized(self.t9pushKeyStr)
    {
        if (0 != [self.t9pushKeyStr length])
        {
            self.t9pushKeyStr = [self.t9pushKeyStr stringByAppendingFormat:@"%ld",(long)aKey];
        }
        else
        {
            self.t9pushKeyStr = [NSString stringWithFormat:@"%ld",(long)aKey];
        }
        [[ContactManager shareInstance] pushOneKey:aKey];
        [self reloadSearch];
    }
}
//删除一个字符
- (void)popOneKey
{
    @synchronized(self.t9pushKeyStr)
    {
        NSInteger len = [self.t9pushKeyStr length];
        if (1 < len)
        {
            self.t9pushKeyStr = [self.t9pushKeyStr substringWithRange:NSMakeRange(0, len - 1)];
            [[ContactManager shareInstance] popOneKey];
        }
        else if(0 < len)
        {
            self.t9pushKeyStr = @"";
            [[ContactManager shareInstance] resetKey];
        }
        else
        {
            return;
        }
        [self reloadSearch];
    }
}
//输入复位
- (void)resetKey
{
    @synchronized(self.t9pushKeyStr)
    {
        self.t9pushKeyStr = @"";
        [[ContactManager shareInstance] resetKey];
        [self reloadSearch];
    }
}

/**
 *  @brief  刷新搜索数据
 */
- (void)reloadSearch
{
    @synchronized(self.t9pushKeyStr)
    {
        [self.searchResult removeAllObjects];
        ContactManager *manager = [ContactManager shareInstance];
        //提取搜索数据
        NSArray *aList = [manager searchResult];
        [self.searchResult addObjectsFromArray:aList];
        
        //如果搜索是以 86 +86 086 0086开头的号码，需要进行处理 20150313
        if ([self.tempnumdata hasPrefix:@"86"]||[self.tempnumdata hasPrefix:@"+86"] || [self.tempnumdata hasPrefix:@"086"] || [self.tempnumdata hasPrefix:@"0086"])
        {
            NSArray *contacts = [[ContactManager shareInstance] searchResultWithText:[MKDialplateUtils formatPhoneNumber:self.tempnumdata]];
            for (NSInteger i=0; i<contacts.count; i++) {
                T9ContactRecord *record = contacts[i];
                if (![_searchResult containsObject:record]) {
                    [_searchResult addObject:record];
                }
            }
        }
        
        @synchronized(self.searchContactTable)
        {
            if (_searchResult.count == 0)
            {
                _isGoingtoNewContact = YES;
                
            }else
            {
                _isGoingtoNewContact = NO;
            }
            
            [self.searchContactTable reloadData];
        }
    }
}

/**
 *  @brief  粘贴
 */
- (void)pasteNumber
{
    UIMenuController *pasteCopyMenuCtr = [UIMenuController sharedMenuController];
    [pasteCopyMenuCtr setMenuVisible:NO];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    //若粘贴板上的内容不为空，可以粘贴
    if (0 != [pasteboard.string length])
    {
        //获取粘贴板的内容
        numStr = [MKDialplateUtils replaceSpecialCharacterInPhoneNumber:pasteboard.string];
        if ([MKDialplateUtils textIsPureDigital:numStr] && [numStr length] > 0)
        {
            _isInput = YES;
            self.showDialNumberView.hidden = NO;
            
            self.tempnumdata = numStr;
            self.currentNumLength = [self.tempnumdata length];
            
            [[ContactManager shareInstance] resetKey];
            
            self.t9pushKeyStr = numStr;
            
            for (int i = 0; i < [self.t9pushKeyStr length]; ++i)
            {
                NSInteger oneKey = [[self.t9pushKeyStr substringWithRange:NSMakeRange(i, 1)] integerValue];
                [[ContactManager shareInstance] pushOneKey:oneKey];
            }
            
            [self reloadSearch];
            
            [self changeViewModelToDialInput];
        }else
        {
            [self showtips:@"粘贴的内容不能为空!"];
            
        }
    } else
    {
        [self showtips:@"粘贴的内容不能为空!"];
    }
}

//显示提示信息
- (void)showtips:(NSString *)str
{
    CGFloat Y = [UIScreen mainScreen].bounds.size.height;
    UIButton *tips = [[UIButton alloc]initWithFrame:CGRectMake(20,Y*0.7, 280, 30)];
    [tips setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tips.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [tips setTitle:str forState:UIControlStateNormal];
    tips.backgroundColor = [UIColor blackColor];
    tips.layer.cornerRadius = 10.0;
    tips.alpha = 0.0;
    [self.view addSubview:tips];
    [UIView animateWithDuration:0.2 animations:^{
        tips.alpha = 0.8;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            tips.alpha = 0.0;
        }completion:^(BOOL finished) {
            [tips removeFromSuperview];
        }];
    }];
}

/**
 *  @brief  切换到拨号模式，通话记录列表隐藏，搜索联系人列表显示，显示号码的view显示
 */
- (void)changeViewModelToDialInput
{
    _isInput = YES;
    self.showDialNumberView.hidden = NO;
    self.clearButton.hidden = NO;
    self.searchContactTable.hidden = NO;
    self.callRecordsListVc.view.hidden = YES;
}

- (void)changeViewModelToRecord
{
    _isInput = NO;
    self.showDialNumberView.hidden = YES;
    self.clearButton.hidden = YES;
    self.searchContactTable.hidden = YES;
    self.callRecordsListVc.view.hidden = NO;
}

/**
 *  @brief  根据电话号码拨打电话
 *
 *  @param phone 电话号码
 */
- (void)makeCall:(NSString *)phone
{
    MKCallBackManager *callBackManager = [MKCallBackManager shareInstance];
    callBackManager.calleePhoneNumber = phone;
    callBackManager.calleeName = [ContactUtils getContactNameByPhone:phone];
    callBackManager.calleePhonePlace = [ContactUtils getPlaceByPhone:phone];
    [callBackManager startCallBackInsertRecordblock:^{
        [ContactUtils insertOneCallRecord:phone];
    }];
}

#pragma -mark 格式处理的方法，添加 -
-(NSString *) dealDialnumStr:(NSString *)phone
{
    NSString * newStr = @"";
    if ([phone isEqualToString:@""] && phone.length==0) {
        return newStr;
    }
    
    if ([[phone substringToIndex:1] isEqual:@"1"])
    {
        if ([phone length] < 4)
        {
            newStr = phone;
        }
        else if ([phone length] >=4 && [phone length] <=7 )
        {
            NSString *str=[phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            newStr = [NSString stringWithFormat:@"%@%@",[str substringToIndex:3],[[str substringFromIndex:3] length]>0?[NSString stringWithFormat:@"-%@",[str substringFromIndex:3]]:[str substringFromIndex:3]];
            
        }
        else if ([phone length] > 7 && [phone length] <=11)
        {
            NSString *str=[phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            newStr =  [NSString stringWithFormat:@"%@-%@%@",[str substringToIndex:3],[str substringWithRange:NSMakeRange(3,4)],[[str substringFromIndex:7] length]>0?[NSString stringWithFormat:@"-%@",[str substringFromIndex:7]]:[str substringFromIndex:7]];
            self.phoneNumberLabel.font = [UIFont systemFontOfSize:26.0];
        }
        else if( [phone length] > 11)
        {
            NSString *str=[phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            if ([str length]==11) {
                newStr =  [NSString stringWithFormat:@"%@-%@%@",[str substringToIndex:3],[str substringWithRange:NSMakeRange(3,4)],[[str substringFromIndex:7] length]>0?[NSString stringWithFormat:@"-%@",[str substringFromIndex:7]]:[str substringFromIndex:7]];
            }else{
                newStr = phone;
            }
            self.phoneNumberLabel.font = [UIFont systemFontOfSize:26.0];
        }
        
    }
    else
    {
        newStr = phone;
        
        if ([phone length] >11)
        {
            self.phoneNumberLabel.font = [UIFont systemFontOfSize:22.0];
        }else{
            self.phoneNumberLabel.font = [UIFont systemFontOfSize:26.0];
        }
        
    }
    
    
    if ([phone length] >16)
    {
        newStr = [phone substringFromIndex:(numStr.length - 16)];
    }
    
    return newStr;
}

#pragma mark - 以下是代理方法的实现
#pragma makr - DialplateKayboardDelegate
/**
 *  @brief  点击数字键盘
 *
 *  @param number 输入按钮的索引
 */
- (void) DialplateViewNumberInput:(NSInteger)number
{
    if (number == 10)
    {
        [self pasteNumber];
        return;
    }
    
    _isInput = YES;
    self.showDialNumberView.hidden = NO;
    
    if ([self.tempnumdata length] == 0)
    {
        numStr = [NSString stringWithFormat:@"%ld",(long)number];
    }
    else
    {
        numStr = [NSString stringWithFormat:@"%@%ld",self.tempnumdata,(long)number];
    }
    self.tempnumdata = numStr;
    
    self.phoneNumberLabel.text = [self dealDialnumStr:self.tempnumdata];
    self.currentNumLength = [[self.tempnumdata stringByReplacingOccurrencesOfString:@"-" withString:@""] length];
    
    if (self.currentNumLength >= 12)
    {
        BOOL numzero =[[self.tempnumdata substringWithRange:NSMakeRange(0, 1)]isEqualToString:@"1"];
        if (numzero)
        {
            [self showtips:@"请输入正确的手机号"];
            return;
        }
    }
    
    if (self.currentNumLength > 29)
    {
        [self showtips:@"号码不能超过30位"];
        return;
    }
    
    [self changeViewModelToDialInput];
    
    if (number < 10 && number >= 0)
    {
        [self pushOneKey:number];
    }
}

/**
 *  @brief  长按按钮
 */
- (void) DialplateViewLongPress
{
    if ([self.tempnumdata length] > 0)
    {
        self.phoneNumberLabel.text = @"";
        _isInput = NO;
        self.showDialNumberView.hidden = YES;
        self.currentNumLength = 0;
        self.tempnumdata = @"";
        [self resetKey];
        
        [self changeViewModelToRecord];
    }
}

/**
 *  @brief  点击拨号按钮
 */
- (void) DialplateViewDialButtonClicked
{
    if ([_t9pushKeyStr length]>0 || [self.tempnumdata length]>0)
    {
        self.tempnumdata = [MKDialplateUtils formatPhoneNumber:self.tempnumdata];
        
        //这里判断号码 如果是座机号 提示加区号
        BOOL numone =[[self.tempnumdata substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"];
        BOOL numzero =[[self.tempnumdata substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"];
        if ([self.tempnumdata length] < 7)
        {
            [self showtips:@"暂不支持短号和特服号码拨打!"];
            return;
        }
        
        NSString *phoneStr=[self.tempnumdata stringByReplacingOccurrencesOfString:@"-" withString:@""];
        //首位是1 判断手机号
        if (numzero && [phoneStr length]!=11)
        {
            [self showtips:@"请输入正确的手机号"];
            return;
        }
        
        if (!numone && !numzero) {
            [self showtips:@"固定电话请加区号"];
            return;
            
        }
        [self makeCall:phoneStr];
    }
    else
    {
        [self showtips:@"呼叫号码为空"];
    }
    [[ContactManager shareInstance] resetKey];
}

/**
 *  @brief  点击删除按钮
 *
 *  @param btn button
 */
- (void)DialnumberKeyboardBackspace:(UIButton *)btn
{
    //删除一个搜索key
    if (self.currentNumLength == 1) {
        self.searchContactTable.hidden = YES;
    }
    if (!_isInput) return;
    
    NSString *strNumber = self.tempnumdata;
    NSInteger len = [strNumber length];
    numStr = @"";
    if (1 < len)
    {
        numStr = [strNumber substringToIndex:len - 1];
    }
    else
    {
        numStr = @"";
        _isInput = NO;
        self.showDialNumberView.hidden = YES;
    }
    self.currentNumLength = [numStr length];
    self.tempnumdata = numStr;
    
    self.phoneNumberLabel.text = [self dealDialnumStr:self.tempnumdata];
    
    if (self.currentNumLength == 0)
    {
        self.phoneNumberLabel.text = @"";
        [self changeViewModelToRecord];
    }
    else
    {
        [self changeViewModelToDialInput];
    }
    
    [self popOneKey];
    
}

#pragma mark - scroll delegate
//滚动列表隐藏拨号盘
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.dialplateView hideDialplate];
    //发出通知
    if (!self.dialplateView.hidden) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dialplateIsHidden" object:nil];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    T9ContactRecord *oneRecord = [_searchResult objectAtIndex:indexPath.row];
    if (oneRecord)
    {
        ContactNode *aContact = [[ContactManager shareInstance] getOneContactByID:oneRecord.abRecordID];
        if (nil != aContact && kInValidContactID != aContact.contactID)
        {
            MKContactDetailViewController *contactDetail = [[MKContactDetailViewController alloc] init];
            contactDetail.aContact = aContact;
            [self.navigationController pushViewController:contactDetail animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isGoingtoNewContact)
    {
        if (indexPath.row == 0)    //新建联系人
        {
            [[ContactWrapper shareWrapper] addNewContactWithPhone:self.tempnumdata rootViewController:self];
        }else                      //添加到已有联系人
        {
            self.picker = [[ABPeoplePickerNavigationController alloc] init];
            self.picker.navigationController.title = @"选中联系人";
            self.picker.navigationBar.tintColor = kWSButtonNormalColor;
            self.picker.peoplePickerDelegate = self;
            [self presentViewController:self.picker animated:YES completion:nil];
        }
        
    }
    else
    {
        if (tableView == _searchContactTable) {
            T9ContactRecord *oneRecord = [_searchResult objectAtIndex:indexPath.row];
            ContactNode *aContact = [[ContactManager shareInstance] getOneContactByID:oneRecord.abRecordID];
            if (aContact && kInValidContactID != aContact.contactID) {
                _callContactName = [NSString stringWithFormat:@"%@",[aContact getContactFullName]];
                _callContactID = aContact.contactID;
                //获取联系人电话号码
                NSMutableArray  *aList = [NSMutableArray arrayWithCapacity:2];
                
                NSArray *pList = [aContact contactAllPhone];
                
                //电话号码不为空时才能拨打
                if (0 < [pList count])
                {
                    MKSearchContactListCell *oneCell = (MKSearchContactListCell *)[tableView cellForRowAtIndexPath:indexPath];
                    if (oneCell)
                    {
                        //判断搜索匹配到的是否为电话号码，若是拨打电话，否则拨打联系人的某一个电话
                        BOOL isPhoneNumber = NO;
                        NSString *resultNumberStr = [NSString stringWithFormat:@"%@",[oneCell.phoneNumberLab.zAttributedText string]];;
                        
                        for (NSString *onePhoneNum in pList)
                        {
                            if ([resultNumberStr isEqualToString:onePhoneNum])
                            {
                                isPhoneNumber = TRUE;
                                break;
                            }
                        }
                        
                        if (!isPhoneNumber)
                        {
                            [aList addObjectsFromArray:pList];
                        }
                        else
                        {
                            [aList addObject:resultNumberStr];
                        }
                    }
                }
                
                
                if ([aList count] > 1)
                {
                    if (nil != _callContactName)
                    {
                        _callContactName = nil;
                    }
                    
                    UIActionSheet *phoneSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                            delegate:self
                                                                   cancelButtonTitle:nil
                                                              destructiveButtonTitle:nil
                                                                   otherButtonTitles:nil];
                    phoneSheet.tag = kDialAddContactSheetTag;
                    for (NSString  *phoneNumerStr in  aList)
                    {
                        [phoneSheet addButtonWithTitle:phoneNumerStr];
                    }
                    [phoneSheet addButtonWithTitle:NSLocalizedString(@"取消", nil)];
                    phoneSheet.cancelButtonIndex = [aList count];
                    [phoneSheet showInView:self.tabBarController.view];
                }
                else if([aList count] > 0)
                {
                    [self makeCall:[MKDialplateUtils formatPhoneNumber:[aList objectAtIndex:0]]];
                    [[ContactManager shareInstance] resetKey];
                }
                else
                {
                    [self showCallErrorrTips:@"拨打失败"];
                }
                
            }
            else
            {
                [self showCallErrorrTips:@"拨打失败"];
            }
        }
    }
}

//拨打错误提示
- (void)showCallErrorrTips:(NSString *)errTips
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:errTips
                                                   delegate:nil
                                          cancelButtonTitle:@"我知道了"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isGoingtoNewContact)
    {
        return 2;
    }else
    {
        return  [_searchResult count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGoingtoNewContact)
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"新建联系人";
            UIView * lineView  = [[UIView alloc] initWithFrame:CGRectMake( 0, 56.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
            lineView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
            [cell addSubview:lineView];
        }else
        {
            cell.textLabel.text = @"添加到已有联系人";
        }
        
        return cell;
    }
    else
    {
        MKSearchContactListCell *cell = (MKSearchContactListCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchContactIn"];
        if (cell == nil)
        {
            cell = [[MKSearchContactListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"SearchContactIn"];
        }
        UIButton *operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        operationBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-80, 0, 57, 57);
        operationBtn.backgroundColor = [UIColor clearColor];
        
        [operationBtn setImage:[MKDialplateUtils getImageFromResourceBundleWithName:@"searchcontact_info_normal" type:@"png"] forState:UIControlStateNormal];
        operationBtn.tag =indexPath.row+1000;
        [operationBtn addTarget:self action:@selector(operationBtnshowcontactdetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:operationBtn];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        T9ContactRecord *oneRecord = [_searchResult objectAtIndex:indexPath.row];
        if (oneRecord)
        {
            [cell createCustomColorLabe:oneRecord];
        }
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if (indexPath.row == 0)
        {
            UIView * lineView1  = [[UIView alloc] initWithFrame:CGRectMake( 0, 56.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
            lineView1.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
            [cell addSubview:lineView1];
        }
        else
        {
            UIView * lineView  = [[UIView alloc] initWithFrame:CGRectMake( 0, 56.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
            lineView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
            [cell addSubview:lineView];
        }
        return cell;
    }
}

- (void)operationBtnshowcontactdetail:(UIButton *)sender
{
    NSInteger flag = sender.tag-1000;
    T9ContactRecord *oneRecord = [_searchResult objectAtIndex:flag];
    if (oneRecord)
    {
        ContactNode *aContact = [[ContactManager shareInstance] getOneContactByID:oneRecord.abRecordID];
        if (nil != aContact && kInValidContactID != aContact.contactID)
        {
            MKContactDetailViewController *contactDetail = [[MKContactDetailViewController alloc] init];
            contactDetail.aContact = aContact;
            [self.navigationController pushViewController:contactDetail animated:YES];
        }
    }
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
    NSString *phoneNumer = self.tempnumdata;
    
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


- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
