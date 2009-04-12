//
//  ORSCanaryController+Growl.h
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import <Cocoa/Cocoa.h>
#import "ORSCanaryController.h"
#import "NSString+ORSCanaryAdditions.h"

@interface ORSCanaryController ( Growl )

- (NSString *) userIdentifier:(NSXMLNode *)node;
- (NSString *) senderIdentifier:(NSXMLNode *)node;
- (NSString *) recipientIdentifier:(NSXMLNode *)node;
- (void) postStatusUpdatesReceived:(NSNotification *)note;
- (void) postRepliesReceived:(NSNotification *)note;
- (void) postDMsReceived:(NSNotification *)note;
- (void) postDMsReceived:(NSNotification *)note
				 afterID:(NSString *)messageID;
- (void) postStatusUpdatesSent:(NSNotification *)note;
- (void) postDMsSent:(NSNotification *)note;

@end
