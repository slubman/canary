//
//  ORSTwitterEngine.m
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 19/03/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.1 - 
//  0.2 - 16/04/2008
//  0.3 - 07/09/2008
//  0.4 - 12/09/2008
//  0.5 - 03/10/2008
//  0.6 - 19/10/2008
//  0.7 - 21/01/2009

#import "ORSTwitterEngine.h"
#import "ORSCanaryController.h"

@implementation ORSTwitterEngine

@synthesize dataReceived, synchronously, mainConnection, session;

static ORSTwitterEngine *sharedEngine = nil;

// sharedController
+ (ORSTwitterEngine *) sharedTwitterEngine {
    @synchronized(self) {
        if (sharedEngine == nil) {
            [[self alloc] init];
        }
    }
    return sharedEngine;
}

// allocWithZone
+ (id) allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedEngine == nil) {
			return [super allocWithZone:zone];
        }
    }
	return sharedEngine;
}

// Initialiser for specifying the way the engine operates: synchrously or the
// opposite
- (id) initSynchronously:(BOOL)synchr 
			  withUserID:(NSString *)userID
			 andPassword:(NSString *)password {
	Class engineClass = [self class];
	@synchronized(engineClass) {
		if (sharedEngine == nil) {
			if (self = [super init]) {
				sharedEngine = self;
				session = [[ORSSession alloc] initWithUserID:userID
												 andPassword:password];
				synchronously = synchr;
				sessionQueue = [NSMutableArray arrayWithCapacity:4];
			}
		}
	}
	return sharedEngine;
}

// copyWithZone
- (id) copyWithZone:(NSZone *)zone {
	return self;
}

// Returns the session user id
- (NSString *) sessionUserID {
	return [session userID];
}

// Sets the session user id
- (void) setSessionUserID:(NSString *)theSessionUserID {
	[session setUserID:theSessionUserID];
}

// Returns the session password
- (NSString *) sessionPassword {
	return [session password];
}

// Sets the session password
- (void) setSessionPassword:(NSString *)theSessionPassword {
	[session setPassword:theSessionPassword];
}

// Executes a request
- (NSData *) executeRequestOfType:(NSString *)type
						   atPath:(NSString *)path
					synchronously:(BOOL)synchr {
	ORSSession *tempSession = (ORSSession *)[session copy];
	[sessionQueue addObject:tempSession];
	if ([sessionQueue count] > 4) {
		[sessionQueue removeObjectAtIndex:0];
	}
	return [tempSession executeRequestOfType:type 
									 atPath:path
							  synchronously:synchr];
}

// Executes a request without URL encoding
- (NSData *) executeUnencodedRequestOfType:(NSString *)type
									atPath:(NSString *)path
							 synchronously:(BOOL)synchr{
	ORSSession *tempSession = (ORSSession *)[session copy];
	[sessionQueue addObject:tempSession];
	if ([sessionQueue count] > 4) {
		[sessionQueue removeObjectAtIndex:0];
	}
	return [tempSession executeUnencodedRequestOfType:type 
											   atPath:path
										synchronously:synchr];
}

// Executes a request with no data returned
- (void) simpleExecuteRequestOfType:(NSString *)type
							 atPath:(NSString *)path
					  synchronously:(BOOL)synchr {
	ORSSession *tempSession = (ORSSession *)[session copy];
	[sessionQueue addObject:tempSession];
	if ([sessionQueue count] > 4) {
		[sessionQueue removeObjectAtIndex:0];
	}
	return [tempSession simpleExecuteRequestOfType:type 
								  atPath:path
						   synchronously:synchr];
}

// Returns an XML document from the given data
- (NSXMLDocument *) getXMLDocumentFromData:(NSData *)data {
	return [session getXMLDocumentFromData:data];
}

// Returns the node from the data received from the connection
- (NSXMLNode *) getNodeFromData:(NSData *)data {
	return [session getNodeFromData:data];
}

// Returns all the statuses as an array from the data received from the
// connection.
- (NSArray *) getAllStatusesFromData:(NSData *)statuses {
	return [session getAllStatusesFromData:statuses];
}

// Returns all the users as an array from the data received from the
// connection.
- (NSArray *) getAllUsersFromData:(NSData *)users {
	return [session getAllUsersFromData:users];
}

// Returns all the users as an array from the data received from the
// connection.
- (NSArray *) getAllDMsFromData:(NSData *)directMessages {
	return [session getAllDMsFromData:directMessages];
}


#pragma mark Status methods

// Status methods

// returns the 20 most recent statuses from non-protected users who have set
// a custom user icon
- (NSArray *) getPublicTimeline {
	NSString *path = @"statuses/public_timeline.xml";
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self getAllStatusesFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns the most recent statuses from non-protected users who have set
// a custom user icon since the given id
- (NSArray *) getPublicTimelineSinceStatus:(NSString *)statusID {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/public_timeline.xml?since_id="];
	[path appendString:statusID];
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self getAllStatusesFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns the 20 most recent statuses from the current user and the people
// she follows
- (NSArray *) getFriendsTimeline {
	NSString *path = @"statuses/friends_timeline.xml";
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self getAllStatusesFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns the most recent statuses from the current user and the people she 
// follows since the given status id
- (NSArray *) getFriendsTimelineSinceStatus:(NSString *)statusID {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/friends_timeline.xml?since_id="];
	[path appendString:statusID];
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self getAllStatusesFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns the 20 most recent statuses from the current user
- (NSArray *) getUserTimeline {
	NSString *path = @"statuses/user_timeline.xml";
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self getAllStatusesFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns the 20 most recent statuses from the specified user
- (NSArray *) getUserTimelineForUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"statuses/user_timeline/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self getAllStatusesFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns the 20 most recent statuses from the current user since the given
// status id
- (NSArray *) getUserTimelineSinceStatus:(NSString *)statusID {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/user_timeline.xml?since_id="];
	[path appendString:statusID];
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self getAllStatusesFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// updates the current user's status
- (NSXMLNode *) sendUpdate:(NSString *)text 
				 inReplyTo:(NSString *)statusID {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/update.xml?status="];
	NSString *statusText = [text 
		stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	statusText = [statusText stringByReplacingOccurrencesOfString:@"&" 
														   withString:@"%26"];
	statusText = [statusText stringByReplacingOccurrencesOfString:@"+"		
														withString:@"%2B"];
	[path appendString:statusText];
	if (statusID != NULL) {
		[path appendString:@"&in_reply_to_status_id="];
		[path appendString:statusID];
	}
	[path appendString:@"&source=canary"];
	if (synchronously) {
		NSXMLNode *node = [self getNodeFromData:[self 
			executeUnencodedRequestOfType:@"POST" 
								   atPath:path 
							synchronously:synchronously]];
		if ([[node name] isEqualToString:@"status"]) {
			return node;
		} else {
			return NULL;
		}
	} else {
		[self executeUnencodedRequestOfType:@"POST" 
									 atPath:path 
							  synchronously:synchronously];
		return NULL;
	}
}

// returns the 20 most recent replies for the current user
- (NSArray *) getReplies {
	NSString *path = @"statuses/replies.xml";
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self getAllStatusesFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns the 20 most recent replies since the given status ID
- (NSArray *) getRepliesSinceStatus:(NSString *)statusID {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/replies.xml?since_id="];
	[path appendString:statusID];
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self getAllStatusesFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}


#pragma mark Direct Message methods

// Direct Message methods

// returns a list of the 20 most recent DMs sent to the current user
- (NSArray *) getReceivedDMs {
	NSString *path = @"direct_messages.xml";
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"direct-messages"]) {
			return [self getAllDMsFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns a list of the 20 most recent DMs sent to the current user since a
// status_id
- (NSArray *) getReceivedDMsSinceDM:(NSString *)dmID {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"direct_messages.xml?since_id="];
	[path appendString:dmID]; 
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"direct-messages"]) {
			return [self getAllDMsFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns a list of the 20 most recent DMs sent by the current user
- (NSArray *) getSentDMs {
	NSString *path = @"/direct_messages/sent.xml";
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"direct-messages"]) {
			return [self getAllDMsFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns a list of the 20 most recent DMs sent by the current user since a
// status_id
- (NSArray *) getSentDMsSinceDM:(NSString *)dmID {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"direct_messages/sent.xml?since_id="];
	[path appendString:dmID]; 
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"direct-messages"]) {
			return [self getAllDMsFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}


#pragma mark Friendship methods

// Friendship methods

// creates friendship with user
- (BOOL) createFriendshipWithUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"friendships/create/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"POST"
																atPath:path 
														// synchronously:YES]];
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

// discontinues friendship with user
- (BOOL) destroyFriendshipWithUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"friendships/destroy/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path 
											 // synchronously:YES]];
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

// tests if a friendship exists between two users (one way only)
- (BOOL) user:(NSString *)userIDA isFriendWithUser:(NSString *)userIDB {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"friendships/exists.xml?user_a="];
	[path appendString:userIDA];
	[path appendString:@"&user_b="];
	[path appendString:userIDB];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"GET"
				atPath:path 
		 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"friends"] &&
		[[node stringValue] isEqualToString:@"true"]) {
		return YES;
	} else {
		return NO;
	}
}


#pragma mark Account methods

// Account methods

// verifies the user credentials
- (BOOL) verifyCredentials {
	NSString *path = @"account/verify_credentials.xml";
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"GET" 
																atPath:path 
														 synchronously:YES]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

// ends the session of the authenticating user
- (BOOL) endSession {
	NSString *path = @"account/end_session";
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"GET" 
					  atPath:path 
			   synchronously:synchronously]];
	if (node) {
		return YES;
	} else {
		return NO;
	}
}


#pragma mark Favorite methods

// Favorite methods

// gets the favorites for the current user
- (NSArray *) getFavorites {
	NSString *path = @"favorites.xml";
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self getAllStatusesFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path synchronously:synchronously];
		return NULL;
	}
}

// gets the favorites for the current user since the given ID
- (NSArray *) getFavoritesSinceStatus:(NSString *)statusID {
	NSString *path = [NSString 
		stringWithFormat:@"favorites.xml?since_id=%@", statusID];
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET"
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self getNodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self getAllStatusesFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET"
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}


#pragma mark Notification methods

// Notification Methods

// follow the user with the specified id
- (BOOL) followUser:(NSString *)userID  {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"notifications/follow/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"POST"
																atPath:path 
											 // synchronously:YES]];
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

// leave the user with the specified id
- (BOOL) leaveUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"notifications/leave/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"POST"
																atPath:path 
											 // synchronously:YES]];
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}


#pragma mark Block methods

// Block methods (ignore the results)

// blocks the user with the specified id
- (BOOL) blockUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
		 stringWithString:@"blocks/create/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path 
											 // synchronously:YES]];
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

// unblocks the user with the specified id
- (BOOL) unblockUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"blocks/destroy/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path 
											 // synchronously:YES]];
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

@end
