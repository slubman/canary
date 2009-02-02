//
//  ORSFilterTransformer.m
//  Canary
//
//  Created by Nicholas Toumpelis on 02/02/2009.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.7 - 02/02/2009

#import "ORSFilterTransformer.h"

@implementation ORSFilterTransformer

+ (Class) transformedValueClass {
    return [NSDictionary class];
}

+ (BOOL) allowsReverseTransformation {
    return YES;
}

- (id) transformedValue:(id)value {
	NSLog(@"filter:: entered transformedValue");
	
	if (value == nil) 
		return nil;
	
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	ORSFilter *filterValue = (ORSFilter *)value;
	
	if ([value respondsToSelector:@selector(active)]) {
		[dictionary setObject:[NSNumber numberWithBool:filterValue.active]
					   forKey:@"ORSCanaryFilterActive"];
	} else {
        [NSException raise: NSInternalInconsistencyException
                    format: @"Value (%@) does not respond to -active.",
			[value class]];
	}
	
	if ([value respondsToSelector:@selector(filterName)]) {
		[dictionary setObject:filterValue.filterName
					   forKey:@"ORSCanaryFilterName"];
	} else {
        [NSException raise: NSInternalInconsistencyException
                    format: @"Value (%@) does not respond to -filterName.",
			[value class]];
    }
	
	if ([value respondsToSelector:@selector(predicate)]) {
		[dictionary setObject:[filterValue.predicate predicateFormat]
					   forKey:@"ORSCanaryFilterPredicate"];
	} else {
        [NSException raise: NSInternalInconsistencyException
                    format: @"Value (%@) does not respond to -predicate.",
			[value class]];
    }
	
    NSLog(@"filter:: exited transformedValue");
	return dictionary;
}

- (id) reverseTransformedValue:(id)value {
	NSLog(@"filter:: entered reverseTransformedValue");
	
    if (value == nil) 
		return nil;
	
	NSDictionary *dictionary = (NSDictionary *)value;
	ORSFilter *filter = [[ORSFilter alloc] init];
	
	if ([value respondsToSelector:@selector(objectForKey:)]) {
		filter.active = [(NSNumber *)[dictionary objectForKey:@"ORSCanaryFilterActive"] boolValue];
	} else {
        [NSException raise: NSInternalInconsistencyException
                    format: @"Value (%@) does not respond to -objectForKey:.",
		 [value class]];
    }
	
	if ([value respondsToSelector:@selector(objectForKey:)]) {
		filter.filterName = [dictionary 
							   objectForKey:@"ORSCanaryFilterName"];
	}
	
	if ([value respondsToSelector:@selector(objectForKey:)]) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:[dictionary 
			objectForKey:@"ORSCanaryFilterPredicate"]];
		filter.predicate = predicate;
	}
	
	NSLog(@"filter:: exited reverseTransformedValue");
	return filter;
}

@end
