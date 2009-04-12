//
//  ORSTwitterEngine+HelpAndAccountAdditions.h
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import <Cocoa/Cocoa.h>
#import "ORSTwitterEngine.h"

@interface ORSTwitterEngine ( HelpAndAccountAdditions )

// Account methods
- (BOOL) specifyLocation:(NSString *)location;
- (BOOL) updateDeliveryDeviceWith:(NSString *)device;
- (NSXMLNode *) getRateLimitStatus;

// Help methods
- (BOOL) isTwitterOnline;
- (NSXMLNode *) getTwitterError;
- (NSXMLNode *) getDowntimeSchedule;

@end
