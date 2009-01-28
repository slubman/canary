//
//  ORSTwitterEngine+FavoritesAndDMAdditions.m
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 11/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 19/10/2008

#import "ORSTwitterEngine+FavoritesAndDMAdditions.h"

@implementation ORSTwitterEngine ( FavoritesAndDMAdditions )

#pragma mark Favorite methods

// Favorite methods

// gets the favorites for the specified user
- (NSArray *) getFavoritesForUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString stringWithString:@"favorites/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"statuses"]) {
		return [self getAllStatusesFromData:data];
	} else {
		return NULL;
	}
}

// gets the next 20 most recent favorites for the current user
- (NSArray *) getFavoritesAtPage:(NSString *)page {
	NSMutableString *path = 
	[NSMutableString stringWithString:@"favorites.xml?page="];
	[path appendString:page];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"statuses"]) {
		return [self getAllStatusesFromData:data];
	} else {
		return NULL;
	}
}

// gets the next 20 most recent favorites for the specified user
- (NSArray *) getFavoritesForUser:(NSString *)userID 
						   atPage:(NSString *)page {
	NSMutableString *path = [NSMutableString stringWithString:@"favorites/"];
	[path appendString:userID];
	[path appendString:@".xml?page="];
	[path appendString:page];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"statuses"]) {
		return [self getAllStatusesFromData:data];
	} else {
		return NULL;
	}
}

// creates a favorite status
- (BOOL) createFavorite:(NSString *)statusID {
	NSMutableString *path = [NSMutableString
							 stringWithString:@"favorites/create/"];
	[path appendString:statusID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self 
							executeRequestOfType:@"POST" atPath:path
											 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"status"]) {
		return YES;
	} else {
		return NO;
	}
}

// creates a favorite status with no data
- (void) createBlindFavorite:(NSString *)statusID {
	NSMutableString *path = [NSMutableString
							 stringWithString:@"favorites/create/"];
	[path appendString:statusID];
	[path appendString:@".xml"];
	[self simpleExecuteRequestOfType:@"POST" 
							  atPath:path
					   synchronously:synchronously];
}

// unfavorites the specified status
- (BOOL) destroyFavorite:(NSString *)statusID {
	NSMutableString *path = [NSMutableString
							 stringWithString:@"favorites/destroy/"];
	[path appendString:statusID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self 
			executeRequestOfType:@"POST" atPath:path
											 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"status"]) {
		return YES;
	} else {
		return NO;
	}
}


#pragma mark Direct Message methods

// Direct Message methods

// returns a list of the 20 most recent DMs sent to the current user since a 
// date
- (NSArray *) getReceivedDMsSince:(NSString *)date {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"direct_messages.xml?since="];
	[path appendString:date];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"direct-messages"]) {
		return [self getAllDMsFromData:data];
	} else {
		return NULL;
	}
}

// returns the 20 next most recent DMs sent to the current user (page-based)
- (NSArray *) getReceivedDMsAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"direct_messages.xml?page="];
	[path appendString:page]; 
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"direct-messages"]) {
		return [self getAllDMsFromData:data];
	} else {
		return NULL;
	}
}

// returns a list of the 20 most recent DMs sent by the current user since a
// date
- (NSArray *) getSentDMsSince:(NSString *)date {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"direct_messages/sent.xml?since="];
	[path appendString:date];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"direct-messages"]) {
		return [self getAllDMsFromData:data];
	} else {
		return NULL;
	}
}

// returns the 20 next most recent DMs sent by the current user (page-based)
- (NSArray *) getSentDMsAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString 
			stringWithString:@"direct_messages/sent.xml?page="];
	[path appendString:page]; 
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"direct-messages"]) {
		return [self getAllDMsFromData:data];
	} else {
		return NULL;
	}
}

// sends a new DM to the specified user
- (BOOL) newDM:(NSString *)message toUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"direct_messages/new.xml?user="];
	[path appendString:userID];
	[path appendString:@"&text="];
	NSString *messageText = [message 
		stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	messageText = [messageText stringByReplacingOccurrencesOfString:@"&" 
															withString:@"%26"];
	messageText = [messageText stringByReplacingOccurrencesOfString:@"+"		
														 withString:@"%2B"];
	[path appendString:messageText];
	NSXMLNode *node = [self getNodeFromData:[self 
		executeUnencodedRequestOfType:@"POST" 
				atPath:path synchronously:synchronously]];
	if ([[node name] isEqualToString:@"direct_message"]) {
		return YES;
	} else {
		return NO;
	}
}

// destroy a specified DM
- (BOOL) destroyDM:(NSString *)messageID {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"direct_messages/destroy/"];
	[path appendString:messageID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"POST" atPath:path synchronously:synchronously]];
	if ([[node name] isEqualToString:@"direct_message"]) {
		return YES;
	} else {
		return NO;
	}
}

@end
