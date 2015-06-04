//
//  CZRequestHeaderKey.h
//  CZVOIP
//
//  Created by wulanzhou-mini on 15-1-29.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#ifndef CZVOIP_CZRequestHeaderKey_h
#define CZVOIP_CZRequestHeaderKey_h

typedef enum{
    CZServiceNone=0,
    CZServiceRegister,   //注册
    CZServiceRegisterCode,  //验证码注册（手机验证）获取验证码
    CZServiceEmailRegister, //邮箱注册
    CZServiceMoRegGetNumber,   //mo注册获取手机发送短信的手机号
    CZServiceMoRegister,  //MO注册
    CZServiceSimRegisterMoRegType,    //MO注册轮询账号密码
    CZServiceThirdReg,    //QQ注册
    CZServiceLogin,       //登录
    CZServiceBackCall,    //回拨
    CZServiceChangedPhone,  //发起改绑手机请求(下发绑定手机验证码)
    CZServiceBindNewPhone,  //确定绑定手机
    CZServiceSearchBalance, //查询余额
    CZServiceResetPwdApply, //重置密码下发验证码（第一步）
    CZServiceResetPwdJudgeCode, //重置密码验证码验证码（第二步)
    CZServiceResetPwdSubmit,  //确认重置密码（第三步）
    CZServiceShowPhone,       //来电显示
    CZServiceSysMessage,      //系统公告
    CPCActiveType,                      //CPC激活统计
    RecordInstallNumberType,            //上传安装量统计
    CZServiceContactBackUpType,             //通讯录备份
    CZServiceContactRecoveryType,           //通讯录恢复
    CZServiceContactBackUpInfoType,         //通讯录备份信息
    CZServiceDefaultConfigType,             //静态配置
    CZServiceTemplateConfigType,            //模板配置
    CZServiceRegisterGetCode,                     //新注册，获取验证码
    CZServiceResetPwdJudgeCodeType,              //重置密码验证验证码
    CZServiceAdvertiseInfoType,                  //广告位信息
    CZServiceGetGoodsCgfType,                    //拉取商品列表
    CZServiceThirtyMinuteInfoType,               //赠送30分钟信息查询
    CZServiceCheckRechargeType,                  //查询是否充值过
    CZServiceUserInfoType,                       //获取用户信息(如注册时间)
    CZServiceRichMsgNewNumType,                  //富媒体新消息数目
    CZServiceRichMsgNewListType,                 //富媒体新消息列表
    CZServiceRichMsgFeedBackType,                //富媒体消息统计
    CZServicePlayConfigType,              //玩赚配置接口
    AppstoreRechargeType,               //appstore充值
    RechargeType,                    //非官方充值
    TestHttpServerTpe,                  //测试http server是否可用
    CZServicepullmsg,                 //ios的push拉取消息
    CZServiceTokenReportType,                    //token上传
    CZInvitCountType,                 //邀请好友个数
    CZSearchBalanceType,          //查询余额
    CZMothCalltime,                //节省，通话时长
    CZShowPhoneType,                //来电显示
    CZChangePhoneType,             //绑定手机验证码
    CZNewBindNewPhoneType,          //绑定手机
    CZAdclicedCountType,       //广告位统计
    CZActionStatisticType,                    //行为统计
    CZKCFriendType,           //是否是kc好友
    CZGetottToken,               //拉取云之讯token值
    CZGetRongYunToken,     //拉取融云token值
    CZCheckIn,   //签到
    CZServiceQueryUserType,  //查询用户
    CZServiceVersionUpdateType,     //版本更新
}CZServiceRequestType;

#endif
