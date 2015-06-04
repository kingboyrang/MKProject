//
//  CZRequestBaseArgs.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-13.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZRequestSign.h"
#import "CZRequestHeaderKey.h"

typedef enum{
    CZCodeSignOther=0,//普通签名
    CZCodeSignUID=1 //uid签名
    
}CZCodeSignType;

@class ASIHTTPRequest;

@interface CZRequestArgs : NSObject

/**
 *  服务地址
 */
@property (nonatomic,copy)     NSString *httpServer;
/**
 *  agw版本,默认值为1.0
 */
@property (nonatomic,copy)     NSString *agwVersion;
/**
 *  品牌id
 */
@property (nonatomic,copy)     NSString *brandId;
/**
 *  请求业务类型
 */
@property (nonatomic,assign)   CZServiceRequestType serviceType;
/**
 *  用户Id号
 */
@property (nonatomic,strong)   NSString *userId;
/**
 *  时间戳
 */
@property (nonatomic,readonly) NSString *timeStamp;
/**
 *  平台类型,默认值为iphone(iphone表示企业版,iphone-app表示appstore版)
 */
@property (nonatomic,copy)     NSString *plateVersion;
/**
 *  app版本(如:1.0.0),默认值为[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
 */
@property (nonatomic,copy)     NSString *appVersion;
/**
 *  渠道ID或推荐人ID,默认值为43
 */
@property (nonatomic,copy)     NSString *invitedBy;
/**
 *  渠道类型,默认值为ad
 */
@property (nonatomic,copy)     NSString *invitedWay;
/**
 *  签名认证方式(登录与未登陆的方式不同)
 */
@property (nonatomic,assign)   CZCodeSignType codeSignType;
/**
 *  生成签名类
 */
@property (nonatomic,strong)   CZRequestSign *requestSign;
/**
 *  用户请求唯一key,默认值由[时间+serviceType]组成
 */
@property (nonatomic,readonly) NSString *requestKey;


/**
 *  基于参数data封装(其它参数)
 *
 *  @param firstObject 可变参数 key与value组成
 */
-(void)paramWithObjectsAndKeys:(NSString*)firstObject, ... NS_REQUIRES_NIL_TERMINATION;


/**
 *  可重设请求的URL
 *
 *  @param aRequestURL 重设URL方法
 */
- (void)setCZRequestURL:(NSURL*(^)())aRequestURL;
/**
 *  可重设请求的传递PostData
 *
 *  @param aRequestData 重设的PostData方法
 */
- (void)setCZRequestPostData:(NSData*(^)())aRequestData;

/**
 *  动态添加属性值
 *
 *  @param propertyName 属性名
 *  @param value        属性值
 */
- (void)addAssociatedWithPropertyName:(NSString *)propertyName withValue:(id)value;
/**
 *  取得动态属性值
 *
 *  @param propertyName 属性名
 *
 *  @return 属性值
 */
- (id)getAssociatedValueWithPropertyName:(NSString *)propertyName;

/**
 *  取得请求的URL
 *
 *  @return 取得请求的URL
 */
- (NSURL*)GetRequestURL;
/**
 *  取得请求的传递数据
 *
 *  @return 取得Post数据
 */
- (NSData*)GetPostData;

/**
 *  取得请求asi对象
 *
 *  @return 取得请求asi对象
 */
- (ASIHTTPRequest*)GetHttpRequest;

@end
