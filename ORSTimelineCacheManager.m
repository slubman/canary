//
//  ORSTimelineCacheManager.m
//  Timeline Cache Controller
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import "ORSTimelineCacheManager.h"

@implementation ORSTimelineCacheManager

@synthesize followingStatusCache, repliesStatusCache, publicStatusCache, 
	archiveStatusCache, receivedMessagesCache, sentMessagesCache,
	firstFollowingCall, firstRepliesCall, firstPublicCall, 
	firstArchiveCall, firstReceivedMessagesCall, firstSentMessagesCall,
	lastFollowingStatusID, lastReplyStatusID, lastPublicStatusID,
	lastArchiveStatusID, lastReceivedMessageID, lastSentMessageID, 
	favoritesStatusCache, firstFavoriteCall, lastFavoriteStatusID;

- (id) init {
	if (self = [super init]) {
		// Following cache
		followingStatusCache = [NSMutableArray array];
		firstFollowingCall = YES;
		lastFollowingStatusID = [NSString string];
		// Replies cache
		repliesStatusCache = [NSMutableArray array];
		firstRepliesCall = YES;
		lastReplyStatusID = [NSString string];
		// Public cache
		publicStatusCache = [NSMutableArray array];
		firstPublicCall = YES;
		lastPublicStatusID = [NSString string];
		// Archive cache
		archiveStatusCache = [NSMutableArray array];
		firstArchiveCall = YES;
		lastArchiveStatusID = [NSString string];
		// Received Messages cache
		receivedMessagesCache = [NSMutableArray array];
		firstReceivedMessagesCall = YES;
		lastReceivedMessageID = [NSString string];
		// Sent Messages cache
		sentMessagesCache = [NSMutableArray array];
		firstSentMessagesCall = YES;
		lastSentMessageID = [NSString string];
		// Favorites cache
		favoritesStatusCache = [NSMutableArray array];
		firstFavoriteCall = YES;
		lastFavoriteStatusID = [NSString string];
	}
	return self;
}

- (void) resetAllCaches {
	[favoritesStatusCache removeAllObjects];
	[followingStatusCache removeAllObjects];
	[repliesStatusCache removeAllObjects];
	[publicStatusCache removeAllObjects];
	[archiveStatusCache removeAllObjects];
	[receivedMessagesCache removeAllObjects];
	[sentMessagesCache removeAllObjects];
	
	firstFavoriteCall = YES;
	firstFollowingCall = YES;
	firstRepliesCall = YES;
	firstPublicCall = YES;
	firstArchiveCall = YES;
	firstReceivedMessagesCall = YES;
	firstSentMessagesCall = YES;
}

- (NSMutableArray *) setStatusesForTimelineCache:(NSUInteger)timelineCacheType 
					withNotification:(NSNotification *)note{
	BOOL *firstCall;
	NSMutableArray *cache;
	NSString **lastStatusID;
	if (timelineCacheType == ORSFollowingTimelineCacheType) {
		firstCall = &firstFollowingCall;
		cache = followingStatusCache;
		lastStatusID = &lastFollowingStatusID;
	} else if (timelineCacheType == ORSArchiveTimelineCacheType) {
		firstCall = &firstArchiveCall;
		cache = archiveStatusCache;
		lastStatusID = &lastArchiveStatusID;
	} else if (timelineCacheType == ORSPublicTimelineCacheType) {
		firstCall = &firstPublicCall;
		cache = publicStatusCache;
		lastStatusID = &lastPublicStatusID;
	} else if (timelineCacheType == ORSRepliesTimelineCacheType) {
		firstCall = &firstRepliesCall;
		cache = repliesStatusCache;
		lastStatusID = &lastReplyStatusID;
	} else if (timelineCacheType == ORSFavoritesTimelineCacheType) {
		firstCall = &firstFavoriteCall;
		cache = favoritesStatusCache;
		lastStatusID = &lastFavoriteStatusID;
	} else if (timelineCacheType == ORSReceivedMessagesTimelineCacheType) {
		firstCall = &firstReceivedMessagesCall;
		cache = receivedMessagesCache;
		lastStatusID = &lastReceivedMessageID;
	} else if (timelineCacheType == ORSSentMessagesTimelineCacheType) {
		firstCall = &firstSentMessagesCall;
		cache = sentMessagesCache;
		lastStatusID = &lastSentMessageID;
	}
	
	if (*firstCall) {
		[cache setArray:(NSArray *)[note object]];
	} else {
		NSIndexSet *indexSet = [NSIndexSet 
			indexSetWithIndexesInRange:NSMakeRange(0, 
				[(NSArray *)[note object] count])];
		[cache insertObjects:(NSArray *)[note object] atIndexes:indexSet];
	}
	
	NSError *error = NULL;
	if ([cache count] > 0) {
		NSXMLNode *lastNode = (NSXMLNode *)[cache objectAtIndex:0];
		NSArray *lastCreatedAt = [lastNode nodesForXPath:@".//id" error:&error];
		NSXMLNode *lastCreatedAtNode = (NSXMLNode *)[lastCreatedAt 
													 objectAtIndex:0];
		*lastStatusID = [[lastCreatedAtNode stringValue] retain];
		*firstCall = NO;
	}
	return cache;
}

@end
