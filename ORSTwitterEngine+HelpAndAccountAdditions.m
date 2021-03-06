//
//  ORSTwitterEngine+HelpAndAccountAdditions.m
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import "ORSTwitterEngine+HelpAndAccountAdditions.h"

@implementation ORSTwitterEngine ( HelpAndAccountAdditions )

#pragma mark Account methods

// Account methods

// specifies the user's location in their profile
- (BOOL) specifyLocation:(NSString *)location {
	NSMutableString *path = [NSMutableString
		stringWithString:@"account/update_location.xml?location="];
	[path appendString:location];
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"GET" atPath:path
				 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

// updates the delivery device
- (BOOL) updateDeliveryDeviceWith:(NSString *)device {
	NSMutableString *path = [NSMutableString
		stringWithString:@"account/update_delivery_device.xml?device="];
	[path appendString:device];
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"POST" atPath:path
				 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

// gets the rate limit status
- (NSXMLNode *) getRateLimitStatus {
	NSString *path = @"account/rate_limit_status.xml";
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"GET" atPath:path
			synchronously:synchronously]];
	if (![[[node childAtIndex:0] name] isEqualToString:@"error"]) {
		return node;
	} else {
		return NULL;
	}
}


#pragma mark Help methods

// Help methods

// tests whether Twitter is active
- (BOOL) isTwitterOnline {
	NSString *path = @"help/text.xml";
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"GET" atPath:path 
			 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"ok"]) {
		return YES;
	} else {
		return NO;
	}
}

// gets Twitter error state
- (NSXMLNode *) getTwitterError {
	NSString *path = @"help/text.xml";
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"GET" atPath:path synchronously:synchronously]];
	if ([[node name] isEqualToString:@"ok"]) {
		return NULL;
	} else {
		return node;
	}
}

// gets Twitter downtime schedule
- (NSXMLNode *) getDowntimeSchedule {
	NSString *path = @"help/downtime_schedule.xml";
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"GET" atPath:path synchronously:synchronously]];
	if (![[[node childAtIndex:0] name] isEqualToString:@"error"]) {
		return node;
	} else {
		return NULL;
	}
}

@end
