//
//  NSXMLNode+ORSTwitterStatusAdditions.h
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import <Cocoa/Cocoa.h>

@interface NSXMLNode ( ORSTwitterStatusAdditions )

- (NSXMLNode *) firstNodeForXPath:(NSString *)xpathString;
- (NSString *) createdAt;
- (NSString *) createdAtAsTimeInterval;
- (NSInteger) createdAtSecondsAgo;
- (NSString *) ID;
- (NSString *) text;
- (NSString *) source;
- (BOOL) truncated;
- (NSString *) inReplyToStatusID;
- (NSString *) inReplyToUserID;
- (NSString *) inReplyToScreenName;
- (NSString *) userID;
- (NSString *) userName;
- (NSString *) userScreenName;
- (NSString *) userLocation;
- (NSString *) userDescription;
- (NSString *) userProfileImageURL;
- (NSString *) userURL;
- (BOOL) userProtected;
- (NSString *) userFollowersCount;
- (NSAttributedString *) richText;
- (BOOL) protectedStatus;

@end
