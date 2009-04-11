//
//  ORSFilterArrayTransformer.m
//  Canary
//
//  Created by Nicholas Toumpelis on 02/02/2009.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.7 - 02/02/2009

#import "ORSFilterArrayTransformer.h"

@implementation ORSFilterArrayTransformer

+ (Class) transformedValueClass {
    return [NSArray class];
}

+ (BOOL) allowsReverseTransformation {
    return YES;
}

- (id) transformedValue:(id)value {
	if (value == nil) 
		return nil;
	
	NSArray *initialArray = (NSArray *)value;
	NSMutableArray *finalArray = [NSMutableArray array];
	ORSFilterTransformer *tranny = [[ORSFilterTransformer alloc] init];
	
	for (id filter in initialArray) {
		[finalArray addObject:(NSDictionary *)[tranny reverseTransformedValue:filter]];
	}
	
	return finalArray;
}

- (id) reverseTransformedValue:(id)value {
    if (value == nil) 
		return nil;
	
	NSArray *initialArray = (NSArray *)value;
	NSMutableArray *finalArray = [NSMutableArray array];
	ORSFilterTransformer *tranny = (ORSFilterTransformer *)[NSValueTransformer valueTransformerForName:@"FilterTransformer"];
	
	for (id dictionary in initialArray) {
		[finalArray addObject:(ORSFilter *)[tranny transformedValue:dictionary]];
	}
    
	return finalArray;
}

@end
