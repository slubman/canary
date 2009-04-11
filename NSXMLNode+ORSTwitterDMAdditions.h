//
//  NSXMLNode+ORSTwitterDMAdditions.h
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 06/11/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 06/11/2008

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
