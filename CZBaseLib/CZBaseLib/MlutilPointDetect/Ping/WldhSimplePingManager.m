//
//  SimplePingHelper.m
//  PingTester
//
//  Created by Chris Hulbert on 18/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WldhSimplePingManager.h"

@interface WldhSimplePingManager()
@property(nonatomic,retain) WldhSimplePing* simplePing;
@property(nonatomic,retain) id SimpleTarget;
@property(nonatomic,assign) SEL SimpleSel;
@property(nonatomic,assign) id<WldhSimplePingManagerDelegate> delegate;
@property(nonatomic,strong)  NSDate* startDate;
@property(nonatomic,strong)  NSDate* endDate;
@property(nonatomic,strong)  NSURL* hostURL;
- (id)initWithAddress:(NSString*)address target:(id)_target action:(SEL)_sel;
- (id)initWithAddress:(NSString*)address delegate:(id<WldhSimplePingManagerDelegate>)delegate;
@end

@implementation WldhSimplePingManager
@synthesize simplePing, SimpleTarget, SimpleSel;

#pragma mark - Run it

// Pings the address, and calls the selector when done. Selector must take a NSnumber which is a bool for success
+ (void)ping:(NSString*)address target:(id)target action:(SEL)sel {
	// The helper retains itself through the timeout function
	[[[[WldhSimplePingManager alloc] initWithAddress:address target:target action:sel] autorelease] go];
}
+ (void)ping:(NSString*)address delegate:(id<WldhSimplePingManagerDelegate>)delegate{
    [[[[WldhSimplePingManager alloc] initWithAddress:address delegate:delegate] autorelease] go];
}
#pragma mark - Init/dealloc

- (void)dealloc {
	self.simplePing = nil;
	self.SimpleTarget = nil;
	[super dealloc];
}

- (id)initWithAddress:(NSString*)address target:(id)_target action:(SEL)_sel {
	if (self = [self init]) {
        self.hostURL=[NSURL URLWithString:address];
		self.simplePing = [WldhSimplePing simplePingWithHostName:self.hostURL.host];
		self.simplePing.delegate = self;
		self.SimpleTarget = _target;
		self.SimpleSel = _sel;
	}
	return self;
}
- (id)initWithAddress:(NSString*)address delegate:(id<WldhSimplePingManagerDelegate>)delegate{
    
    if (self = [self init]) {
        self.hostURL=[NSURL URLWithString:address];
        self.simplePing = [WldhSimplePing simplePingWithHostName:self.hostURL.host];
        self.simplePing.delegate = self;
        self.delegate = delegate;
    }
    return self;
}


#pragma mark - Go

- (void)go {
	[self.simplePing start];
	[self performSelector:@selector(endTime) withObject:nil afterDelay:1]; // This timeout is what retains the ping helper
}

#pragma mark - Finishing and timing out

// Called on success or failure to clean up
- (void)killPing {
	[self.simplePing stop];
	[[self.simplePing retain] autorelease]; // In case, higher up the call stack, this got called by the simpleping object itself
	self.simplePing = nil;
}

- (void)successPing {
	[self killPing];
	//[target performSelector:sel withObject:[NSNumber numberWithBool:YES]];
    [SimpleTarget performSelector:SimpleSel withObject:[self pingWithStatus:PingHostAddressStatusSuccess success:YES packetLength:0]];
}

- (void)failPing:(NSString*)reason {
	[self killPing];
	//[target performSelector:sel withObject:[NSNumber numberWithBool:NO]];
    if([reason isEqualToString:@"didFailWithError"]){
        [SimpleTarget performSelector:SimpleSel withObject:[self pingWithStatus:PingHostAddressStatusFailed success:NO packetLength:0]];
    }else if([reason isEqualToString:@"didFailToSendPacket"]){
        [SimpleTarget performSelector:SimpleSel withObject:[self pingWithStatus:PingHostAddressStatusTimeOut success:YES packetLength:0]];
    }else{
        [SimpleTarget performSelector:SimpleSel withObject:[self pingWithStatus:PingHostAddressStatusSuccess success:YES packetLength:0]];
    }
    //timeout
}

// Called 1s after ping start, to check if it timed out
- (void)endTime {
	if (self.simplePing) { // If it hasn't already been killed, then it's timed out
        [self endPingWithStatus:PingHostAddressStatusTimeOut success:NO packetLength:0];
		[self failPing:@"timeout"];
	}
}
//表示ping完成
- (void)endPingWithStatus:(PingHostAddressStatus)status success:(BOOL)success packetLength:(NSInteger)len{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(simplePingHelperResult:)]) {
        SimplePingResult *mod=[[SimplePingResult alloc] init];
        if (status!=PingHostAddressStatusTimeOut) {
            mod.timeInterval=[self.endDate timeIntervalSinceDate:self.startDate];
        }
        if (self.hostURL) {
            mod.hostName=self.hostURL.absoluteString;
        }else{
           mod.hostName=self.simplePing.hostName;
        }
        mod.pingHostStatus=status;
        mod.success=success;
        mod.packetLength=len;
        [self.delegate simplePingHelperResult:mod];
    }
}
- (SimplePingResult*)pingWithStatus:(PingHostAddressStatus)status success:(BOOL)success packetLength:(NSInteger)len{
    SimplePingResult *mod=[[SimplePingResult alloc] init];
    if (status!=PingHostAddressStatusTimeOut) {
        mod.timeInterval=[self.endDate timeIntervalSinceDate:self.startDate];
    }
    if (self.hostURL) {
        mod.hostName=self.hostURL.absoluteString;
    }else{
        mod.hostName=self.simplePing.hostName;
    }
    mod.pingHostStatus=status;
    mod.success=success;
    mod.packetLength=len;
    return mod;
}
#pragma mark - Pinger delegate

// When the pinger starts, send the ping immediately
- (void)simplePing:(WldhSimplePing *)pinger didStartWithAddress:(NSData *)address {
    self.startDate=[NSDate date];
	[self.simplePing sendPingWithData:nil];
}

- (void)simplePing:(WldhSimplePing *)pinger didFailWithError:(NSError *)error {
    self.endDate=[NSDate date];
    [self endPingWithStatus:PingHostAddressStatusFailed success:NO packetLength:0];
    [self failPing:@"didFailWithError"];
}

- (void)simplePing:(WldhSimplePing *)pinger didFailToSendPacket:(NSData *)packet error:(NSError *)error {
	// Eg they're not connected to any network
    self.endDate=[NSDate date];
	
    [self endPingWithStatus:PingHostAddressStatusFailPacket success:YES packetLength:packet.length];
    [self failPing:@"didFailToSendPacket"];
}

- (void)simplePing:(WldhSimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet {
    self.endDate=[NSDate date];
    [self endPingWithStatus:PingHostAddressStatusSuccess success:YES packetLength:0];
    [self successPing];
    //[self failPing:@"didReceivePingResponsePacket"];
}

@end
