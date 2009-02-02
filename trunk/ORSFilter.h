//
//  ORSFilter.h
//  Canary
//
//  Created by Nicholas Toumpelis on 02/02/2009.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.7 - 02/02/2009

#import <Cocoa/Cocoa.h>

@interface ORSFilter : NSObject <NSCopying> {
	NSPredicate *predicate;
	NSString *filterName;
	BOOL active;
}

- (id) copyWithZone:(NSZone *)zone;

@property(copy) NSPredicate *predicate;
@property(copy) NSString *filterName;
@property() BOOL active;

@end
