//
//  ORSUpdateDispatcher.h
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

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
