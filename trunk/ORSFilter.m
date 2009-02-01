//
//  ORSFilter.m
//  Canary
//
//  Created by Νικόλαος Τουμπέλης on 01/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
