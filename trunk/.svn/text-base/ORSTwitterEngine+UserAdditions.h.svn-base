//
//  ORSTwitterEngine+UserAdditions.h
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 11/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 19/10/2008

#import <Cocoa/Cocoa.h>
#import "ORSTwitterEngine.h"

@interface ORSTwitterEngine ( UserAdditions )

// User methods
- (NSArray *) getFriends;
- (NSArray *) getFriendsOfUser:(NSString *)userID;
- (NSArray *) getFriendsAtPage:(NSString *)page;
- (NSArray *) getFriendsLite;
- (NSArray *) getFriendsLiteAtPage:(int)page;
- (NSArray *) getFriendsSince:(NSString *)date;
- (NSArray *) getFriendsOfUser:(NSString *)userID
						atPage:(NSString *)page;
- (NSArray *) getFriendsLiteOfUser:(NSString *)userID;
- (NSArray *) getFriendsOfUser:(NSString *)userID
						 since:(NSString *)date;
- (NSArray *) getFollowers;
- (NSArray *) getFollowersOfUser:(NSString *)userID;
- (NSArray *) getFollowersAtPage:(NSString *)page;
- (NSArray *) getFollowersLite;
- (NSArray *) getFollowersOfUser:(NSString *)userID 
						  atPage:(NSString *)page;
- (NSArray *) getFollowersLiteOfUser:(NSString *)userID;
- (NSArray *) getFeatured;
- (NSXMLNode *) showUser:(NSString *)userID;
- (NSXMLNode *) showUserWithEmail:(NSString *)email;

@end
