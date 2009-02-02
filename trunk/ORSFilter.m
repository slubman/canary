//
//  ORSFilter.m
//  Canary
//
//  Created by Nicholas Toumpelis on 02/02/2009.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.7 - 02/02/2009

#import "ORSFilter.h"

@implementation ORSFilter

@synthesize predicate, filterName, active;

// Copy with zone
- (id) copyWithZone:(NSZone *)zone {
	ORSFilter *copyOfCurrentFilter = [[ORSFilter alloc] init];
	copyOfCurrentFilter.active = self.active;
	copyOfCurrentFilter.predicate = [self.predicate copy];
	copyOfCurrentFilter.filterName = [self.filterName copy];
	return copyOfCurrentFilter;
}

@end
