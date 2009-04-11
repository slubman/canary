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

- (void) encodeWithCoder:(NSCoder *)coder {
	[coder encodeBool:active forKey:@"ORSCanaryFilterActive"];
	[coder encodeObject:filterName forKey:@"ORSCanaryFilterName"];
	[coder encodeObject:predicate forKey:@"ORSCanaryFilterPredicate"];
}

- (id) initWithCoder:(NSCoder *)coder {
    self = [super init];
    active = [coder decodeBoolForKey:@"ORSCanaryFilterActive"];
    filterName = [coder decodeObjectForKey:@"ORSCanaryFilterName"];
    predicate = [coder decodeObjectForKey:@"ORSCanaryFilterPredicate"];
    return self;
}

@end
