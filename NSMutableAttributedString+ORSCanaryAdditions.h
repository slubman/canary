//
//  NSMutableAttributedString+ORSCanaryAdditions.h
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import <Cocoa/Cocoa.h>

@interface NSMutableAttributedString ( ORSCanaryAdditions )

- (NSCharacterSet *) httpDelimitingCharset;
- (NSCharacterSet *) fullDelimitingCharset;
- (NSCharacterSet *) usernameDelimitingCharset;
- (NSCharacterSet *) groupDelimitingCharset;
- (NSCharacterSet *) hashtagDelimitingCharset;
- (NSString *) detectURL:(NSString *)string;
- (NSString *) detectUsername:(NSString *)string;
- (NSString *) detectGroup:(NSString *)string;
- (NSString *) detectHashtag:(NSString *)string;
- (NSString *) detectDOI:(NSString *)string;
- (NSString *) detectHDL:(NSString *)string;
- (NSString *) detectISBN:(NSString *)string;
- (NSString *) detectISSN:(NSString *)string;
- (NSString *) detectIETF:(NSString *)string;
- (NSAttributedString *) emoticonStringWithName:(NSString *)name;
- (void) highlightElements;

@end
