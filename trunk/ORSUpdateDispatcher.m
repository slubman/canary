//
//  ORSUpdateDispatcher.m
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 11/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 18/10/2008

#import "ORSUpdateDispatcher.h"

@implementation ORSUpdateDispatcher

- (id) initWithEngine:(ORSTwitterEngine *)engine {
	if (self = [super init]) {
		twitterEngine = engine;
		//queueArray = [[NSMutableArray new] retain];
		queueArray = [NSMutableArray new];
	}
	// NSLog(@"ORSUpdateDispatcher:: initWithEngine:");
	return self;
}

- (void) addMessage:(NSString *)message {	
	@synchronized(self) {
		BOOL directMessage = NO;
		NSScanner *scanner = [NSScanner scannerWithString:message];
		NSString *token = NULL;
		[scanner scanUpToString:@" " intoString:&token];
		if ([token isEqualToString:@"d"] || [token isEqualToString:@"D"]) {
			[scanner scanUpToString:@" " intoString:&token];
			directMessage = YES;
			message = [[scanner string] 
					   substringFromIndex:[scanner scanLocation]+1];
		} else { 
			directMessage = NO;
		}
	
		unsigned int updateLength = [message length];
		NSMutableString *messagePart = NULL;
		NSMutableString *remainingMessage = [NSMutableString 
										stringWithString:message];
		BOOL firstMessage = YES;
	
		if (updateLength > 140) {
			while ([remainingMessage length] > 136) {
				NSRange rangeOfLastWhitespace = [remainingMessage 
					rangeOfString:@" " options:NSBackwardsSearch 
										  range:NSMakeRange(0, 136)];
				NSRange rangeOfMessagePart = NSMakeRange(0, 
											rangeOfLastWhitespace.location+1);
				messagePart = [NSMutableString 
					stringWithString:[remainingMessage 
									  substringWithRange:rangeOfMessagePart]];
				[remainingMessage deleteCharactersInRange:rangeOfMessagePart];
				if (firstMessage) {
					[messagePart appendString:@" »"];
					firstMessage = NO;
				} else {
					[messagePart insertString:@"» " atIndex:0];
					[messagePart appendString:@" »"];
				}
				[queueArray addObject:(NSString *)messagePart];
			}
			[remainingMessage insertString:@"» " atIndex:0];
			[queueArray addObject:(NSString *)remainingMessage];
		} else {
			[queueArray addObject:(NSString *)message];
		}

		if (directMessage) {
			[self initiateDMDispatch:[NSNotification 
				notificationWithName:@"" object:token]];
		} else {
			[self initiateStatusDispatch:nil];
		}
	}
	// NSLog(@"ORSUpdateDispatcher:: addStatusMessage:");
}

- (void) initiateStatusDispatch:(NSNotification *)note {
	@synchronized(self) {
		if ([queueArray count] > 0) {
			[twitterEngine sendUpdate:[queueArray objectAtIndex:0]
							inReplyTo:nil];
			[queueArray removeObjectAtIndex:0];
			[self performSelector:@selector(initiateStatusDispatch:) 
					   withObject:nil
					   afterDelay:6.0];
		}
	}
	// NSLog(@"ORSUpdateDispatcher:: initiateStatusDispatch:");
}

- (void) initiateDMDispatch:(NSNotification *)note {
	@synchronized(self) {
		if ([queueArray count] > 0) {
			[twitterEngine newDM:[queueArray objectAtIndex:0]
						  toUser:(NSString *)[note object]];
			[queueArray removeObjectAtIndex:0];
			[self performSelector:@selector(initiateDMDispatch:) 
					   withObject:nil
					   afterDelay:6.0];
		}
		// NSLog(@"ORSUpdateDispatcher:: initiateDMDispatch:");
	}
}

@end
