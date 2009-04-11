//
//  ORSCanaryController+Growl.h
//  Canary
//
//  Created by Nick Toumpelis on 15/02/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  0.7 - 15/02/2009

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
