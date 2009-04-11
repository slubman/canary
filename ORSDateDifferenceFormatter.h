//
//  ORSDateDifferenceFormatter.h
//  Canary Controller
//
//  Created by Nicholas Toumpelis on 03/11/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 04/11/2008

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
