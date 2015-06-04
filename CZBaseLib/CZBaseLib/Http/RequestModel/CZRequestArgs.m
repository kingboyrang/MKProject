//
//  CZRequestBaseArgs.m
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-13.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "CZRequestArgs.h"
#import "CZRequestHandler.h"
#import "ASIHTTPRequest.h"
#import "CZMyLog.h"
#import <objc/runtime.h>

@interface CZRequestArgs (){
    NSURL* (^BlockRequestURL)();
    NSData* (^BlockRequestPostData)();
    
    NSMutableDictionary *postDataDic_;
    NSString *requestKey_;
}
@property (nonatomic,readonly) NSMutableDictionary *postDataDic;
@property (nonatomic,strong) NSMutableArray *postParams;
@end


@implementation CZRequestArgs
@synthesize postDataDic=postDataDic_;
@synthesize requestKey=requestKey_;


- (id)init{
    if (self=[super init]) {
        self.requestSign=[[CZRequestSign alloc] init];
        self.codeSignType=CZCodeSignOther;
        self.postParams=[[NSMutableArray alloc] initWithCapacity:0];
        postDataDic_=[NSMutableDictionary dictionaryWithCapacity:0];
        
        CZRequestConfig *config=[CZRequestHandler shareRequestConfig];
        self.httpServer=config.httpServer;
        self.agwVersion=config.agwVersion;
        self.brandId=config.brandId;
        self.plateVersion=config.plateVersion;
        self.appVersion=config.appVersion;
        self.invitedBy=config.invitedBy;
        self.invitedWay=config.invitedWay;
        self.userId=config.userId;
        self.requestSign.password=config.password;
    }
    return self;
}

//时间戳
- (NSString*)timeStamp{
    NSDate *localDate = [NSDate date];
    NSString *strTimestamp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];
    return strTimestamp;
}
//随机数
- (NSString*)randomNumberWithTimeStamp:(NSString*)ts{
    int i = abs(arc4random())%100000;
    NSString *strNonce = [NSString stringWithFormat:@"%@%d", ts, i];
    return strNonce;
}
- (NSString*)requestKey{
    if (requestKey_&&[requestKey_ length]>0) {
        return requestKey_;
    }
    NSString *key = [NSString stringWithFormat:@"%d_%@",
                     self.serviceType,
                     [NSDate date]];
    
    requestKey_=key;
    return requestKey_;
}
/**
 *  基于参数(data=)封装
 *
 *  @param firstObject 可变参数 key与value组成
 */
-(void)paramWithObjectsAndKeys:(NSString*)firstObject, ... NS_REQUIRES_NIL_TERMINATION{
    NSMutableArray *values=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray *keys=[NSMutableArray arrayWithCapacity:0];
    NSInteger index=0;
    va_list args;
    va_start(args,firstObject);
    if(firstObject)
    {
        [values addObject:firstObject];
        index++;
        NSString *otherString;
        while((otherString=va_arg(args,NSString*)))
        {
            if (index%2==0){
                [values addObject:otherString];
            }else{
                //依次取得所有参数
                [keys addObject:otherString];
            }
            index++;
        }
    }
    va_end(args);
    
    NSAssert([values count]==[keys count], @"paramWithObjectsAndKeys方法设置的key与value不匹配!");
    
    if([keys count]>0&&[values count]>0)
    {
        for(NSInteger i=0;i<[values count];i++)
        {
            [self setParamValue:[values objectAtIndex:i] name:[keys objectAtIndex:i]];
        }
    }
}

/**
 *  基于参数(data=)封装
 *
 *  @param value 参数值
 *  @param key   参数名
 */
- (void)setParamValue:(NSString*)value name:(NSString*)key{
    [self.postParams addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
    [postDataDic_ setValue:value forKey:key];
}
#pragma mark -请求方法重写
- (void)setCZRequestURL:(NSURL*(^)())aRequestURL{
    BlockRequestURL=aRequestURL;
}
- (void)setCZRequestPostData:(NSData*(^)())aRequestData{
    BlockRequestPostData=aRequestData;
}
#pragma mark -动态添加属性
- (void)addAssociatedWithPropertyName:(NSString *)propertyName withValue:(id)value {
    id property = objc_getAssociatedObject(self, &propertyName);
    if(property == nil)    {
        property = value;
        objc_setAssociatedObject(self, &propertyName, property, OBJC_ASSOCIATION_RETAIN);
    }
}
- (id)getAssociatedValueWithPropertyName:(NSString *)propertyName {
    id property = objc_getAssociatedObject(self, &propertyName);
    return property;
}
#pragma mark - request url
- (NSString*)basicURLString{
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@/%@/%@",
                         self.httpServer,
                         self.agwVersion,
                         self.brandId];
    
    NSAssert(self.brandId!=nil||[self.brandId length]!=0, @"品牌值不能为空!");
    return baseUrl;
}
- (NSURL*)GetRequestURL{
    if (BlockRequestURL) {
        return BlockRequestURL();
    }
    return [NSURL URLWithString:[self requestURLString:[self basicURLString]]];
}
- (NSString*)requestURLString:(NSString*)baseUrl{
    NSString *strUrl = nil;
    
    switch (self.serviceType)
    {
        case CZServiceRegister:          //注册
            strUrl = [NSString stringWithFormat:@"%@/account/reg", baseUrl];
            break;
        case CZServiceBindNewPhone:      //绑定
            strUrl = [NSString stringWithFormat:@"%@/user/bind_submit", baseUrl];
            break;
        case CZServiceThirdReg:       //QQ 注册
            strUrl = [NSString stringWithFormat:@"%@/account/third_reg", baseUrl];
            break;
        case CPCActiveType:             //渠道
            strUrl = [NSString stringWithFormat:@"%@/statistic/cpc", baseUrl];
            break;
        case RecordInstallNumberType:   //安装量
            strUrl = [NSString stringWithFormat:@"%@/statistic/install", baseUrl];
            break;
        case CZServiceLogin:      //登录
            strUrl = [NSString stringWithFormat:@"%@/account/login", baseUrl];
            break;
        case CZServiceEmailRegister:  //邮箱注册
            strUrl = [NSString stringWithFormat:@"%@/account/email_reg_nobind", baseUrl];
            break;
        case CZServiceContactBackUpType:  //通讯录备份
            strUrl = [NSString stringWithFormat:@"%@/contacts/backup",baseUrl];
            break;
        case CZServiceContactRecoveryType:             //联系人恢复
            strUrl = [NSString stringWithFormat:@"%@/contacts/down",baseUrl];
            break;
        case CZServiceContactBackUpInfoType:            //联系人备份信息
            strUrl = [NSString stringWithFormat:@"%@/contacts/info",baseUrl];
            break;
        case CZServiceDefaultConfigType:              //拉取静态配置
            strUrl = [NSString stringWithFormat:@"%@/config/app",baseUrl];
            break;
        case CZServiceTemplateConfigType:              //获取模板配置
            strUrl = [NSString stringWithFormat:@"%@/config/tpl",baseUrl];
            break;
        case CZServiceSysMessage:                     //获取系统公告
            strUrl = [NSString stringWithFormat:@"%@/config/sysmsg",baseUrl];
            break;
            
        case CZServiceRegisterGetCode:             //新注册，获取验证码
        {
            strUrl = [NSString stringWithFormat:@"%@/account/reg_validate", baseUrl];
        }
            break;
            
        case CZServiceResetPwdApply:                      //重置密码请求
        {
            strUrl = [NSString stringWithFormat:@"%@/user/reset_pwd_apply", baseUrl];
        }
            break;
        case CZServiceResetPwdJudgeCodeType:
        {
            strUrl = [NSString stringWithFormat:@"%@/user/reset_pwd_check", baseUrl];
        }
            break;
        case CZServiceResetPwdSubmit:
        {
            strUrl = [NSString stringWithFormat:@"%@/user/reset_pwd", baseUrl];
        }
            break;
        case CZServiceSimRegisterMoRegType:               //MO注册轮询账号密码
        {
            strUrl = [NSString stringWithFormat:@"%@/account/mo_reg", baseUrl];
        }
            break;
        case CZServiceThirtyMinuteInfoType:               //赠送30分钟信息查询
        {
            strUrl = [NSString stringWithFormat:@"%@/user/giftpkg_leftime", baseUrl];
        }
            break;
        case CZServiceGetGoodsCgfType:                    //拉取商品列表
        {
            strUrl = [NSString stringWithFormat:@"%@/config/goods", baseUrl];
        }
            break;
        case CZServiceCheckRechargeType:                  //查询是否充值过
        {
            strUrl = [NSString stringWithFormat:@"%@/order/is_first", baseUrl];
        }
            break;
            
        case CZServiceAdvertiseInfoType:               //广告位信息
        {
            strUrl = [NSString stringWithFormat:@"%@/config/ad_conf",baseUrl];
        }
            break;
        case CZServiceRichMsgNewNumType:                  //富媒体
        {
            strUrl = [NSString stringWithFormat:@"%@/rnms/msg_num",baseUrl];
        }
            break;
        case CZServiceRichMsgNewListType:
        {
            strUrl = [NSString stringWithFormat:@"%@/rnms/msg_list",baseUrl];
        }
            break;
        case CZServiceRichMsgFeedBackType:
        {
            strUrl = [NSString stringWithFormat:@"%@/rnms/click_feedback",baseUrl];
        }
            break;
        case AppstoreRechargeType:               //appstore充值
        {
            strUrl = [NSString stringWithFormat:@"%@/order/iphone_pay", baseUrl];
        }
            break;
        case RechargeType:                       //非官方版充值
        {
            strUrl = [NSString stringWithFormat:@"%@/order/pay", baseUrl];
        }
            break;
            
        case CZServiceBackCall:              //回拨请求call call_back_new
        {
            
            strUrl = [NSString stringWithFormat:@"%@/call_back_new",baseUrl];
        }
            break;
            
        case CZServicePlayConfigType:              //玩赚配置
        {
            strUrl = [NSString stringWithFormat:@"%@/config/games",baseUrl];
        }
            break;
        case CZInvitCountType: //邀请好友数
        {
            strUrl = [NSString stringWithFormat:@"%@/bounty/count",baseUrl];
        }
            break;
            
        case CZServicepullmsg:                //push拉取消息
        {
            strUrl = [NSString stringWithFormat:@"%@/statistic/pull_msg",baseUrl];
            
        }
            break;
        case CZServiceTokenReportType:                    //token上传
        {
            
            strUrl = [NSString stringWithFormat:@"%@/statistic/token", baseUrl];
            
        }
            break;
        case CZMothCalltime:  //月通话时长
        {
            strUrl = [NSString stringWithFormat:@"%@/user/month_calltime",baseUrl];
        }
            break;
        case CZSearchBalanceType: //查询余额
        {
            strUrl = [NSString stringWithFormat:@"%@/user/wallet",baseUrl];
        }
            break;
            
        case CZShowPhoneType:                      //新来电显示
        {
            strUrl = [NSString stringWithFormat:@"%@/user/show_num", baseUrl];
        }
            break;
            
        case CZChangePhoneType:                    //发起改绑手机请求
        {
            strUrl = [NSString stringWithFormat:@"%@/user/bind_req", baseUrl];
        }
            break;
        case CZNewBindNewPhoneType:                   //确定改绑手机
        {
            strUrl = [NSString stringWithFormat:@"%@/user/bind_phone", baseUrl];
        }
            break;
        case CZActionStatisticType:                   //用户行为统计上报
        {
            strUrl = [NSString stringWithFormat:@"%@/statistic/act_upload",baseUrl];
        }
            break;
            
        case CZAdclicedCountType:
        {
            strUrl = [NSString stringWithFormat:@"%@/statistic/ad_upload", baseUrl];
        }
            break;
            
        case CZKCFriendType:
        {
            strUrl = [NSString stringWithFormat:@"%@/user/iskc", baseUrl];
        }
            break;
        case CZGetottToken:                       //云之讯token
        {
            strUrl = [NSString stringWithFormat:@"%@/ott/gettoken", baseUrl];
        }
            break;
        case CZGetRongYunToken:                  //融云token
        {
            strUrl = [NSString stringWithFormat:@"%@/rc/gettoken", baseUrl];
        }
            break;
        case CZCheckIn:                  //签到
        {
            strUrl = [NSString stringWithFormat:@"%@/check_in", baseUrl];
        }
            break;
        case CZServiceVersionUpdateType:                  //版本更新
        {
            strUrl = [NSString stringWithFormat:@"%@/config/update", baseUrl];
        }
            break;
        case CZServiceQueryUserType:                  //查询用户
        {
            strUrl = [NSString stringWithFormat:@"%@/user/query_user", baseUrl];
        }
            break;
        default:
            break;
    }
    
    return strUrl;
}
#pragma mark -post data
//传递数据
- (NSData*)GetPostData{
    
    if (BlockRequestPostData) {
        return BlockRequestPostData();
    }
    
    //uid与pwd都不为空则 auth_type=uid 否则为key
    if (self.userId&&[self.userId length] > 0 &&self.requestSign.password&&[self.requestSign.password length] > 0){
        self.codeSignType=CZCodeSignUID;
    }else{
        self.codeSignType=CZCodeSignOther;
    }
    //签证参数
    NSMutableDictionary *tempDic=[NSMutableDictionary dictionaryWithCapacity:0];
    [tempDic setValue:self.plateVersion forKey:@"pv"];
    [tempDic setValue:self.appVersion forKey:@"v"];
    [tempDic setValue:self.timeStamp forKey:@"ts"];
    [tempDic setValue:[self randomNumberWithTimeStamp:[tempDic objectForKey:@"ts"]] forKey:@"nonce"];
    [tempDic setValue:self.invitedBy forKey:@"invitedby"];
    [tempDic setValue:self.invitedWay forKey:@"invitedway"];
    [tempDic setValue:self.codeSignType==CZCodeSignUID?@"uid":@"key" forKey:@"auth_type"];
    
    NSString *strData=[self.postParams componentsJoinedByString:@"&"];
    if ([strData length]>0) {
        [tempDic setValue:strData forKey:@"data"];
    }
    if (self.userId&&[self.userId length]>0&&self.codeSignType==CZCodeSignUID) {
        [tempDic setValue:self.userId forKey:@"uid"];
    }
    
    //签证处理
    NSString *strSign=[self.requestSign GetUrlUidSign:tempDic];
    //传递参数
    NSMutableArray *params=[NSMutableArray arrayWithCapacity:0];
    for (NSString *item in tempDic.allKeys) {
        if ([item isEqualToString:@"data"]) {
            [params addObject:[NSString stringWithFormat:@"%@=%@",item,[self getPostOtherDataString]]];
            continue;
        }
        [params addObject:[NSString stringWithFormat:@"%@=%@",item,[tempDic objectForKey:item]]];
    }
    
    NSString *post =[NSString stringWithFormat:@"%@&sign=%@&uid=%@",[params componentsJoinedByString:@"&"],strSign,self.userId];
    
    [CZMyLog writeLog:post];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    return postData;
}
#pragma mark -私有方法
- (NSString*)getPostOtherDataString{
    //获取data数据
    NSString *strData = @"";
    if([self.postParams count] > 0)
    {
        strData=[self.postParams componentsJoinedByString:@"&"];
        NSString *aStr = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)strData,
                                                                                              NULL,
                                                                                              CFSTR(":/?#[]@!$&’()*+,;="),
                                                                                              kCFStringEncodingUTF8));
        strData = [NSString stringWithFormat:@"%@",aStr];
    }
    return strData;
}
/**
 *  取得请求asi对象
 *
 *  @return 取得请求asi对象
 */
- (ASIHTTPRequest*)GetHttpRequest{
    NSURL *webURL=[self GetRequestURL];
    [CZMyLog writeLog:webURL.absoluteString];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:webURL];
    NSData *postData=[self GetPostData];
    [request appendPostData:postData];
    
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [request addRequestHeader:@"Content-Length" value:postLength];
    [request setTimeOutSeconds:10];
    return request;
}
@end
