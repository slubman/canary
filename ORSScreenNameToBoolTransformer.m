//
//  ORSScreenNameToBoolTransformer.m
//  Canary
//
//  Created by Nicholas Toumpelis on 04/02/2009.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.7 - 04/02/2009

#import "ORSScreenNameToBoolTransformer.h"

@implementation ORSScreenNameToBoolTransformer

+ (Class) transformedValueClass {
    return [NSNumber class];
}

+ (BOOL) allowsReverseTransformation {
    return NO;
}

- (id) transformedValue:(id)value {
	if (value == nil) 
		return nil;
	
	NSString *screenName = (NSString *)value;
	ORSTwitterEngine *twitterEngine = [ORSTwitterEngine sharedTwitterEngine];
	if ([screenName isEqualToString:[twitterEngine sessionUserID]]) {
		return [NSNumber numberWithBool:NO];
	} else {
		return [NSNumber numberWithBool:YES];
	}
}

@end
