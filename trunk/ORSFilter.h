//
//  ORSFilter.h
//  Canary
//
//  Created by Νικόλαος Τουμπέλης on 01/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
