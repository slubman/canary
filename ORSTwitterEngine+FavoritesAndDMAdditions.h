//
//  ORSTwitterEngine+FavoritesAndDMAdditions.h
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 11/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 19/10/2008

#import <Cocoa/Cocoa.h>
#import "ORSTwitterEngine.h"

@interface ORSTwitterEngine ( FavoritesAndDMAdditions )

// Favorite Methods
- (NSArray *) getFavoritesForUser:(NSString *)userID;
- (NSArray *) getFavoritesAtPage:(NSString *)page;
- (NSArray *) getFavoritesForUser:(NSString *)userID atPage:(NSString *)page;
- (BOOL) createFavorite:(NSString *)statusID;
- (void) createBlindFavorite:(NSString *)statusID;
- (BOOL) destroyFavorite:(NSString *)statusID;

// Direct Message Methods
- (NSArray *) getReceivedDMsSince:(NSString *)date;
- (NSArray *) getReceivedDMsAtPage:(NSString *)page;
- (NSArray *) getSentDMsSince:(NSString *)date;
- (NSArray *) getSentDMsAtPage:(NSString *)page;
- (BOOL) newDM:(NSString *)message toUser:(NSString *)userID;
- (BOOL) destroyDM:(NSString *)messageID;

@end
