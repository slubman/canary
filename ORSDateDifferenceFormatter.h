//
//  ORSDateDifferenceFormatter.h
//  Canary Controller
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import <Cocoa/Cocoa.h>

@interface ORSDateDifferenceFormatter : NSFormatter {

}

- (NSString *) stringForObjectValue:(id)anObject;
- (BOOL) getObjectValue:(id *)anObject 
			  forString:(NSString *)string
	   errorDescription:(NSString **)error;
- (NSAttributedString *)attributedStringForObjectValue:(id)anObject
							withDefaultAttributes:(NSDictionary *)attributes;

@end
