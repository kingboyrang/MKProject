//
//  SimplePingHelper.h
//  PingTester
//
//  Created by Chris Hulbert on 18/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WldhSimplePing.h"
#import "SimplePingResult.h"

@protocol WldhSimplePingManagerDelegate <NSObject>
- (void)simplePingHelperResult:(SimplePingResult*)result;
@end

@interface WldhSimplePingManager : NSObject <SimplePingDelegate>
+ (void)ping:(NSString*)address target:(id)target action:(SEL)sel;
+ (void)ping:(NSString*)address delegate:(id<WldhSimplePingManagerDelegate>)delegate;
@end
