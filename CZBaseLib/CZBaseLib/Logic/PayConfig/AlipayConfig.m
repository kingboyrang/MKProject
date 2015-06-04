//
//  AlipayConfig.m
//  CZBaseLib
//
//  Created by wulanzhou-mini on 15-5-25.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "AlipayConfig.h"

@implementation AlipayConfig

- (id)init{
    if (self=[super init]) {
        self.partnerId=@"2088001406696844";
        self.sellerId=@"gaojinya@keepc.com";
        self.rsaPrivateKey=@"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKmCvb7bThgapVWEfGyB49o1mNXUrHAF8VSJURYuBrljSkI+go0UetMPKcJTG+xmum2UB/zDr98BakVW9gZH6Ju+cHY9dvq88MjszleYQQqKjt43/uQGCNcIQ9DbLnRDcAUE2+jt0NgquP7vN7jxauSsHwG2uCSC8ywYry5M1oCPAgMBAAECgYBoMF4kY3OayTX6XFaF80hzpSHtvKzIpj5xcX2PnnavmGHaWcWwpXfhJp7KPH8bTQElvSkzqav97Ea/m/XYYnaL0+SMXT7YPNT0UYcNtSTpWwI4eCX+8uoMsGQIsiebXKqjg+iXkXOeE5UqP5AUP7hweOlfhtRIuUoNN+DkkkNOEQJBANNCoQIuyTVUg8ma0lhJ9kV3P4/57Uf4fZqJan7eEQdrJTgIhqQgvPrVsd9iDvey/IgBwMIU5EAirzX9IjauTTMCQQDNaK4vwjqu6oVIpmojKNMQ6zaEiq7SPdrk1SX382oIY7FNUHuh0HHGfEWLnnoFOsjTqJHOHRu/Kv7Mg+FVi2c1AkA1rZxTfafKUSsbMqd3n3Nfuyj/YDWWL+FaPsg8bBhPlj3iuufbFCZwZZPIepXrAiOAO1HK/pvwX9+9DBCBbFBZAkB7niEeKuUIOamG5GgByuLjTrsbnx7A9mrSxpg4Fazdaandnq8Y3gpq6oUsFm7W0N7lypAdHBWDwgtf54pn4iJ1AkAuQ97UBpnDduge5PlRPmh7AWaHGras8TQTSQy4ObNFRtYjB4th4wk+gGQWGmS2SrdK6ZdZKwRe9Vb7O27lzvPK";
        self.isRSAPrivateKeyNull=NO;
        self.schemeStr=@"MKAlipay";
    }
    return self;
}


@end
