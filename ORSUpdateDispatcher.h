//
//  ORSUpdateDispatcher.h
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 11/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 18/10/2008

#import <Cocoa/Cocoa.h>
#import "ORSTwitterEngine.h"
#import "ORSTwitterEngine+FavoritesAndDMAdditions.h"

@interface ORSUpdateDispatcher : NSObject {

@private
	ORSTwitterEngine *twitterEngine;
	NSMutableArray *queueArray;	
	
}

- (id) initWithEngine:(ORSTwitterEngine *)engine;
- (void) addMessage:(NSString *)message;
- (void) initiateStatusDispatch:(NSNotification *)note;
- (void) initiateDMDispatch:(NSNotification *)note;

@end
