//
//  ORSTimelineCacheManager.h
//  Timeline Cache Controller
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import <Cocoa/Cocoa.h>

enum {
	ORSFollowingTimelineCacheType = 1,
	ORSArchiveTimelineCacheType = 2,
	ORSPublicTimelineCacheType = 3,
	ORSRepliesTimelineCacheType = 4,
	ORSFavoritesTimelineCacheType = 5,
	ORSReceivedMessagesTimelineCacheType = 6,
	ORSSentMessagesTimelineCacheType = 7
};
typedef NSUInteger ORSTimelineCacheTypes;

@interface ORSTimelineCacheManager : NSObject {

	// Intermediate caches
	NSMutableArray *followingStatusCache, *repliesStatusCache, 
		*publicStatusCache, *archiveStatusCache, *receivedMessagesCache,
		*sentMessagesCache, *favoritesStatusCache;
	BOOL firstFollowingCall, firstRepliesCall, firstPublicCall, 
		firstArchiveCall, firstReceivedMessagesCall, firstSentMessagesCall,
		firstFavoriteCall;
	NSString *lastFollowingStatusID, *lastReplyStatusID, *lastPublicStatusID,
		*lastArchiveStatusID, *lastReceivedMessageID, *lastSentMessageID, 
		*lastFavoriteStatusID;
	
}

- (void) resetAllCaches;
- (NSMutableArray *) setStatusesForTimelineCache:(NSUInteger)timelineCacheType
					withNotification:(NSNotification *)note;

@property(copy) NSMutableArray *followingStatusCache, *repliesStatusCache,
	*publicStatusCache, *archiveStatusCache, *receivedMessagesCache,
	*sentMessagesCache, *favoritesStatusCache;
@property() BOOL firstFollowingCall, firstRepliesCall, firstPublicCall,
	firstArchiveCall, firstReceivedMessagesCall, 
	firstSentMessagesCall, firstFavoriteCall;
@property(copy) NSString *lastFollowingStatusID, *lastReplyStatusID,
	*lastPublicStatusID, *lastArchiveStatusID, *lastReceivedMessageID, 
	*lastSentMessageID, *lastFavoriteStatusID;

@end
