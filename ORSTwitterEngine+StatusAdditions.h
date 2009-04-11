//
//  ORSTwitterEngine+StatusAdditions.h
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 11/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 19/10/2008

#import <Cocoa/Cocoa.h>
#import "ORSTwitterEngine.h"

@interface ORSTwitterEngine ( StatusAdditions ) 

// Status methods
- (NSArray *) getFriendsTimelineSince:(NSString *)date;
- (NSArray *) getFriendsTimelineWithNumberOfStatuses:(NSString *)count;
- (NSArray *) getFriendsTimelineAtPage:(NSString *)page;
- (NSArray *) getUserTimelineWithNumberOfStatuses:(NSString *)count;
- (NSArray *) getUserTimelineSince:(NSString *)date;
- (NSArray *) getUserTimelineAtPage:(NSString *)page;

- (NSArray *) getUserTimelineForUser:(NSString *)userID 
				withNumberOfStatuses:(NSString *)count;
- (NSArray *) getUserTimelineForUser:(NSString*)userID 
							   since:(NSString *)date;
- (NSArray *) getUserTimelineForUser:(NSString *)userID
						 sinceStatus:(NSString *)statusID;
- (NSArray *) getUserTimelineForUser:(NSString *)userID
							  atPage:(NSString *)page;
- (NSXMLNode *) getStatus:(NSString *)statusID;
- (NSArray *) getRepliesAtPage:(NSString *)page;
- (NSArray *) getRepliesSince:(NSString *)date;
- (NSXMLNode *) destroyStatus:(NSString *)statusID;

@end
