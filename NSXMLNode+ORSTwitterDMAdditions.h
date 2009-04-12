//
//  NSXMLNode+ORSTwitterDMAdditions.h
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import <Cocoa/Cocoa.h>

@interface NSXMLNode ( ORSTwitterDMAdditions )

- (NSXMLNode *) firstNodeForXPath:(NSString *)xpathString;
- (NSString *) senderID;
- (NSString *) recipientID;
- (NSString *) senderScreenName;
- (NSString *) recipientScreenName;
- (NSString *) senderName;
- (NSString *) senderLocation;
- (NSString *) senderDescription;
- (NSString *) senderProfileImageURL;
- (NSString *) senderURL;
- (NSString *) senderProtected;
- (NSString *) senderFollowersCount;
- (NSString *) recipientName;
- (NSString *) recipientLocation;
- (NSString *) recipientDescription;
- (NSString *) recipientProfileImageURL;
- (NSString *) recipientURL;
- (NSString *) recipientProtected;
- (NSString *) recipientFollowersCount;

@end
