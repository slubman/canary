//
//  NSString+ORSCanaryAdditions.h
//  Canary
//
//  Created by Nicholas Toumpelis on 04/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 10/11/2008

#import <Cocoa/Cocoa.h>

@interface NSString ( ORSCanaryAdditions )

+ (NSString *) replaceHTMLEntities:(NSString *)string;

@end
