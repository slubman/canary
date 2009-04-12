//
//  ORSScreenNameToBoolTransformer.m
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

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
