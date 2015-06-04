//
//  AlipayConfig.h
//  CZBaseLib
//
//  Created by wulanzhou on 15-5-25.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZBaseObject.h"
/**
 *
 *  支付宝信息配置
 */
@interface AlipayConfig : CZBaseObject

/**
 *  合作伙伴Id,默认值:2088001406696844
 */
@property (nonatomic,strong) NSString *partnerId;

/**
 *  支付宝帐号,默认值:gaojinya@keepc.com
 */
@property (nonatomic,strong) NSString *sellerId;

/**
 *  支付宝私钥,默认值:
 
 MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKmCvb7bThgapVWEfGyB49o1mNXUrHAF8VSJURYuBrljSkI+go0UetMPKcJTG+xmum2UB/zDr98BakVW9gZH6Ju+cHY9dvq88MjszleYQQqKjt43/uQGCNcIQ9DbLnRDcAUE2+jt0NgquP7vN7jxauSsHwG2uCSC8ywYry5M1oCPAgMBAAECgYBoMF4kY3OayTX6XFaF80hzpSHtvKzIpj5xcX2PnnavmGHaWcWwpXfhJp7KPH8bTQElvSkzqav97Ea/m/XYYnaL0+SMXT7YPNT0UYcNtSTpWwI4eCX+8uoMsGQIsiebXKqjg+iXkXOeE5UqP5AUP7hweOlfhtRIuUoNN+DkkkNOEQJBANNCoQIuyTVUg8ma0lhJ9kV3P4/57Uf4fZqJan7eEQdrJTgIhqQgvPrVsd9iDvey/IgBwMIU5EAirzX9IjauTTMCQQDNaK4vwjqu6oVIpmojKNMQ6zaEiq7SPdrk1SX382oIY7FNUHuh0HHGfEWLnnoFOsjTqJHOHRu/Kv7Mg+FVi2c1AkA1rZxTfafKUSsbMqd3n3Nfuyj/YDWWL+FaPsg8bBhPlj3iuufbFCZwZZPIepXrAiOAO1HK/pvwX9+9DBCBbFBZAkB7niEeKuUIOamG5GgByuLjTrsbnx7A9mrSxpg4Fazdaandnq8Y3gpq6oUsFm7W0N7lypAdHBWDwgtf54pn4iJ1AkAuQ97UBpnDduge5PlRPmh7AWaHGras8TQTSQy4ObNFRtYjB4th4wk+gGQWGmS2SrdK6ZdZKwRe9Vb7O27lzvPK
 
 */
@property (nonatomic,strong) NSString *rsaPrivateKey;

/**
 *  支付宝返回应用的url scheme type设置,默认值为MKAlipay
 */
@property (nonatomic,strong) NSString *schemeStr;

/**
 *  默认值:NO,当出现rsa_private read error : private key is NULL错误时，需要设为YES
 */
@property (nonatomic,assign) BOOL isRSAPrivateKeyNull;

@end
