//
//  ORSCanaryController+Growl.m
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import "ORSCanaryController+Growl.h"

@implementation ORSCanaryController (Growl)

- (NSString *) userIdentifier:(NSXMLNode *)node {
	if (self.showScreenNames) {
		return node.userName;
	} else {
		return node.userScreenName;
	}
}

- (NSString *) senderIdentifier:(NSXMLNode *)node {
	if (self.showScreenNames) {
		return node.senderName;
	} else {
		return node.senderScreenName;
	}
}

- (NSString *) recipientIdentifier:(NSXMLNode *)node {
	if (self.showScreenNames) {
		return node.recipientName;
	} else {
		return node.recipientScreenName;
	}
}

// Posts notifications that status updates have been received
- (void) postStatusUpdatesReceived:(NSNotification *)note {
	NSMutableArray *newStatuses = [[NSMutableArray alloc] init];
	for (NSXMLNode *node in (NSArray *)note.object) {
		if (node.ID.intValue > 
			self.statusIDSinceLastExecution.intValue) {
			[newStatuses addObject:node];
		}
	}
	if (newStatuses.count > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Status Updates Received"
			description:[NSString 
				stringWithFormat:@"%i status updates received", 
					((NSArray *)note.object).count]
							   notificationName:@"Status Updates Received"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:@""];
	} else {
		for (NSXMLNode *node in newStatuses) {
			NSMutableDictionary *contextDict = [NSMutableDictionary new];
			[contextDict setObject:@"Friends" forKey:@"Timeline"];
			[contextDict setObject:node.ID forKey:@"ID"];
			NSData *iconData;
			//if ([node.userProfileImageURL hasSuffix:@".gif"]) {
			//	iconData = nil;
			//} else {
				iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
					URLWithString:node.userProfileImageURL]];
			//}
			[GrowlApplicationBridge notifyWithTitle:[self userIdentifier:node]
		description:[NSString replaceHTMLEntities:node.text]
								   notificationName:@"Status Updates Received"
										   iconData:iconData
										   priority:1
										   isSticky:NO
									   clickContext:contextDict];
		}
	}
}

// Posts notifications that replies have been received
- (void) postRepliesReceived:(NSNotification *)note {
	NSMutableArray *newReplies = [[NSMutableArray alloc] init];
	for (NSXMLNode *node in (NSArray *)note.object) {
		if (node.ID.intValue > 
			self.statusIDSinceLastExecution.intValue) {
			[newReplies addObject:node];
		}
	}
	//if (((NSArray *)note.object).count > 10) {
	if (newReplies.count > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Replies Received"
			description:[NSString stringWithFormat:@"%i replies received", 
												 ((NSArray *)note.object).count]
							   notificationName:@"Replies Received"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:@""];
	} else {
		//for (NSXMLNode *node in (NSArray *)note.object) {
		for (NSXMLNode *node in newReplies) {
			NSMutableDictionary *contextDict = [NSMutableDictionary new];
			[contextDict setObject:@"Replies" forKey:@"Timeline"];
			[contextDict setObject:node.ID forKey:@"ID"];
			NSData *iconData;
			//if ([node.userProfileImageURL hasSuffix:@".gif"]) {
			//	iconData = nil;
			//} else {
				iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
					URLWithString:node.userProfileImageURL]];
			//}
			[GrowlApplicationBridge notifyWithTitle:[self userIdentifier:node]
				description:[NSString replaceHTMLEntities:node.text]
								   notificationName:@"Replies Received"
										   iconData:iconData
										   priority:1
										   isSticky:NO
									   clickContext:contextDict];
		}
	}
}

// Posts notifications that messages have been received
- (void) postDMsReceived:(NSNotification *)note {
	NSMutableArray *newReceivedMessages = [[NSMutableArray alloc] init];
	for (NSXMLNode *node in (NSArray *)note.object) {
		if (node.ID.intValue > 
			self.receivedDMIDSinceLastExecution.intValue) {
			[newReceivedMessages addObject:node];
		}
	}
	//if (((NSArray *)note.object).count > 10) {
	if (newReceivedMessages.count > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Direct Messages Received"
				description:[NSString 
					stringWithFormat:@"%i direct messages received", 
												 ((NSArray *)note.object).count]
							   notificationName:@"Direct Messages Received"
									   iconData:nil
									   priority:1
									   isSticky:YES
								   clickContext:@""];
	} else {
		//for (NSXMLNode *node in (NSArray *)note.object) {
		for (NSXMLNode *node in newReceivedMessages) {
			NSMutableDictionary *contextDict = [NSMutableDictionary new];
			[contextDict setObject:@"Received messages" forKey:@"Timeline"];
			[contextDict setObject:node.ID forKey:@"ID"];
			NSData *iconData;
			//if ([node.senderProfileImageURL hasSuffix:@".gif"]) {
			//	iconData = nil;
			//} else {
				iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
					URLWithString:node.senderProfileImageURL]];
			//}
			[GrowlApplicationBridge notifyWithTitle:[self senderIdentifier:node]
				description:[NSString replaceHTMLEntities:node.text]
								   notificationName:@"Direct Messages Received"
										   iconData:iconData
										   priority:2
										   isSticky:NO
									   clickContext:contextDict];
		}
	}
}

// Posts notifications that messages with larger id that the given have been
// received
- (void) postDMsReceived:(NSNotification *)note
				 afterID:(NSString *)messageID {
	// This can be optimised
	int count = 0;
	for (NSXMLNode *node in (NSArray *)note.object) {
		if (node.ID.intValue > messageID.intValue) {
			count++;
		}
	}
	
	if (count > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Direct Messages Received"
			description:[NSString 
				stringWithFormat:@"%i direct messages received", 
												 ((NSArray *)note.object).count]
							   notificationName:@"Direct Messages Received"
									   iconData:nil
									   priority:1
									   isSticky:YES
								   clickContext:@""];
	} else {
		for (NSXMLNode *node in (NSArray *)note.object) {
			if (node.ID.intValue > messageID.intValue) {
				NSMutableDictionary *contextDict = [NSMutableDictionary new];
				[contextDict setObject:@"Received messages" forKey:@"Timeline"];
				[contextDict setObject:node.ID forKey:@"ID"];
				NSData *iconData;
				//if ([node.senderProfileImageURL hasSuffix:@".gif"]) {
				//	iconData = nil;
				//} else {
					iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
						URLWithString:node.senderProfileImageURL]];
				//}
				[GrowlApplicationBridge notifyWithTitle:[self senderIdentifier:node]
					description:[NSString replaceHTMLEntities:node.text]
									   notificationName:@"Direct Messages Received"
											   iconData:iconData
											   priority:2
											   isSticky:NO
										   clickContext:contextDict];
			}
		}
	}
}

// Posts a notification that a status update has been sent
- (void) postStatusUpdatesSent:(NSNotification *)note {
	if (((NSArray *)note.object).count > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Status Updates Sent"
			description:[NSString stringWithFormat:@"%i status updates sent", 
												 ((NSArray *)note.object).count]
							   notificationName:@"Status Updates Sent"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:@""];
	} else {
		for (NSXMLNode *node in (NSArray *)note.object) {
			NSMutableDictionary *contextDict = [NSMutableDictionary new];
			[contextDict setObject:@"Friends" forKey:@"Timeline"];
			[contextDict setObject:node.ID forKey:@"ID"];
			NSData *iconData;
			//if ([node.userProfileImageURL hasSuffix:@".gif"]) {
			//	iconData = nil;
			//} else {
				iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
					URLWithString:node.userProfileImageURL]];
			//}
			[GrowlApplicationBridge notifyWithTitle:[self userIdentifier:node]
				description:[NSString replaceHTMLEntities:node.text]
								   notificationName:@"Status Updates Sent"
										   iconData:iconData
										   priority:0
										   isSticky:NO
									   clickContext:contextDict];
		}
	}
}

// Posts a notification that a message has been sent
- (void) postDMsSent:(NSNotification *)note {
	if (((NSArray *)note.object).count > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Direct Messages Sent"
			description:[NSString stringWithFormat:@"%i direct messages sent", 
												 ((NSArray *)note.object).count]
							   notificationName:@"Direct Messages Sent"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:@""];
	} else {
		for (NSXMLNode *node in (NSArray *)note.object) {
			NSMutableDictionary *contextDict = [NSMutableDictionary new];
			[contextDict setObject:@"Sent messages" forKey:@"Timeline"];
			[contextDict setObject:node.ID forKey:@"ID"];
			NSData *iconData;
			//if ([node.recipientProfileImageURL hasSuffix:@".gif"]) {
			//	iconData = nil;
			//} else {
				iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
					URLWithString:node.recipientProfileImageURL]];
			//}
			[GrowlApplicationBridge notifyWithTitle:[self 
											recipientIdentifier:node]
				description:[NSString replaceHTMLEntities:node.text]
								   notificationName:@"Direct Messages Sent"
										   iconData:iconData
										   priority:0
										   isSticky:NO
									   clickContext:contextDict];
		}
	}
}

- (void) growlNotificationWasClicked:(id)clickContext {
	NSDictionary *contextDict = (NSDictionary *)clickContext;
	NSString *statusID = [contextDict objectForKey:@"ID"];
	NSString *timeline = [contextDict objectForKey:@"Timeline"];
	if (![statusID isEqualToString:@""]) {
		if ([timeline isEqualToString:@"Friends"] || 
			[timeline isEqualToString:@"Replies"]) {
			for (NSXMLNode *node in [statusArrayController arrangedObjects]) {
				if ([node.ID isEqualToString:statusID]) {
					[statusArrayController setSelectedObjects:[NSArray 
										arrayWithObject:node]];
					break;
				}
			}
		} else if ([timeline isEqualToString:@"Received messages"]) {
			if (![timelineButton.titleOfSelectedItem 
				  isEqualToString:@"Received messages"]) {
				[self changeToReceivedDMs:self];
			}
			for (NSXMLNode *node in [receivedDMsArrayController 
									 arrangedObjects]) {
				if ([node.ID isEqualToString:statusID]) {
					[receivedDMsArrayController setSelectedObjects:[NSArray 
						arrayWithObject:node]];
					break;
				}
			}
		} else {
			for (NSXMLNode *node in [sentDMsArrayController arrangedObjects]) {
				if ([node.ID isEqualToString:statusID]) {
					[sentDMsArrayController setSelectedObjects:[NSArray 
						arrayWithObject:node]];
					break;
				}
			}
		}
	}
	[self showWindow:nil];
	[self.window makeKeyAndOrderFront:self.window];
}

@end
