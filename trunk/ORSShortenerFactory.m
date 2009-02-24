//
//  ORSShortenerFactory.m
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 18/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 18/10/2008

#import "ORSShortenerFactory.h"

@implementation ORSShortenerFactory

// Returns the URL shortener that corresponds to the given shortener type.
+ (id <ORSShortener>) getShortener:(NSUInteger)shortenerType {
	switch (shortenerType) {
		case ORSAdjixShortenerType:
			return [[ORSAdjixShortener alloc] init];
		case ORSBitlyShortenerType:
			return [[ORSBitlyShortener alloc] init];
		case ORSCligsShortenerType:
			return [[ORSCligsShortener alloc] init];
		case ORSIsgdShortenerType:
			return [[ORSIsgdShortener alloc] init];
		case ORSSnipURLShortenerType:
			return [[ORSSnipURLShortener alloc] init];
		case ORSTinyURLShortenerType:
			return [[ORSTinyURLShortener alloc] init];
		case ORSTrimShortenerType:
			return [[ORSTrimShortener alloc] init];
		case ORSUrlborgShortenerType:
			return [[ORSUrlborgShortener alloc] init];
		default:
			return NULL;
	}
}

@end
