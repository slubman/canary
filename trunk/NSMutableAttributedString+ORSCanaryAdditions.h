//
//  NSMutableAttributedString+ORSCanaryAdditions.h
//  Canary
//
//  Created by Nicholas Toumpelis on 20/02/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.2 - 16/04/2008
//  0.5 - 03/10/2008
//  0.6 - 10/11/2008

#import <Cocoa/Cocoa.h>

@interface NSMutableAttributedString ( ORSCanaryAdditions )

- (NSCharacterSet *) httpDelimitingCharset;
- (NSCharacterSet *) fullDelimitingCharset;
- (NSCharacterSet *) usernameDelimitingCharset;
- (NSCharacterSet *) hashtagDelimitingCharset;
- (NSString *) detectURL:(NSString *)string;
- (NSString *) detectUsername:(NSString *)string;
- (NSString *) detectHashtag:(NSString *)string;
- (NSString *) detectDOI:(NSString *)string;
- (NSString *) detectHDL:(NSString *)string;
- (NSString *) detectISBN:(NSString *)string;
- (NSString *) detectISSN:(NSString *)string;
- (NSString *) detectTwitter:(NSString *)string;
- (NSAttributedString *) emoticonStringWithName:(NSString *)name;
- (void) highlightElements;

@end
