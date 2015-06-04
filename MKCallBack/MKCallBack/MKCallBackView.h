//
//  MKCallBackView.h
//  MKCallBack
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKCallBackView : UIView

/**
 *  @brief  创建回拨界面对象
 *
 *  @param frame        回拨界面的frame
 *  @param calleeName   被叫人姓名
 *  @param calleeNumber 被叫人手机号码
 *  @param calleePlace  被叫人归属地
 *  @param callerNumber 呼叫人电话号码
 *
 *  @return 回拨界面对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                   calleeName:(NSString *)calleeName
                 calleeNumber:(NSString *)calleeNumber
                  calleePlace:(NSString *)calleePlace
                 callerNumber:(NSString *)callerNumber
                    isVipUser:(BOOL)flag;

@end
