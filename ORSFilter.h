//
//  ORSFilter.h
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

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
