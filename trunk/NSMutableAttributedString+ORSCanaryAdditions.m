//
//  NSMutableAttributedString+ORSCanaryAdditions.m
//  Canary
//
//  Created by Nicholas Toumpelis on 20/02/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.2 - 16/04/2008
//  0.5 - 03/10/2008

#import "NSMutableAttributedString+ORSCanaryAdditions.h"

@implementation NSMutableAttributedString ( ORSCanaryAdditions )

// Returns an HTTP URL delimiting character set
- (NSCharacterSet *) httpDelimitingCharset {
	NSMutableCharacterSet *charset = [NSMutableCharacterSet new];
	[charset addCharactersInString:@"±§$%^*(){}[];'\"\\|,<>`~ÅÍÎÏ¡™£¢∞§¶"];
	[charset addCharactersInString:@"•ªº≠œ∑´®†¥¨ˆøπ“‘åß∂ƒ©˙∆˚¬…æ«ÓÔ˘¿Â¯"];
	[charset addCharactersInString:@"Ω≈ç√∫˜µ≤≥÷€‹›ﬁﬂ‡°·—Œ„´‰ˇÁ¨ˆØ∏”’˝ÒÚÆ"];
	[charset addCharactersInString:@"»¸˛Ç◊ı˜"];
	return charset;
}

// Returns a delimiting character set for twitter usernames and mailto: urls
- (NSCharacterSet *) fullDelimitingCharset {
	NSMutableCharacterSet *charset = [NSMutableCharacterSet new];
	[charset addCharactersInString:@"±§!#$%^&*()-+={}[];:'\"\\|,./<>?`~ÅÍÎÏ"];
	[charset addCharactersInString:@"¡™£¢∞§¶•ªº–≠œ∑´®†¥¨ˆøπ“‘åß∂ƒ©˙∆˚¬…æ«ÓÔ"];
	[charset addCharactersInString:@"Ω≈ç√∫˜µ≤≥÷⁄€‹›ﬁﬂ‡°·—Œ„´‰ˇÁ¨ˆØ∏”’˝ÒÚÆ"];
	[charset addCharactersInString:@"»¸˛Ç◊ı˜Â¯˘¿"];
	return charset;
}

// Returns a delimiting character set for twitter usernames and mailto: urls
- (NSCharacterSet *) usernameDelimitingCharset {
	NSMutableCharacterSet *charset = [NSMutableCharacterSet new];
	[charset addCharactersInString:@"±§!#$%^&*()+={}[];:'\"\\|,./<>?`~ÅÍÎÏ"];
	[charset addCharactersInString:@"¡™£¢∞§¶•ªº–≠œ∑´®†¥¨ˆøπ“‘åß∂ƒ©˙∆˚¬…æ«ÓÔ"];
	[charset addCharactersInString:@"Ω≈ç√∫˜µ≤≥÷⁄€‹›ﬁﬂ‡°·—Œ„´‰ˇÁ¨ˆØ∏”’˝ÒÚÆ"];
	[charset addCharactersInString:@"»¸˛Ç◊ı˜Â¯˘¿"];
	return charset;
}

// Returns a delimiting character set for twitter hashtag
- (NSCharacterSet *) hashtagDelimitingCharset {
	NSMutableCharacterSet *charset = [NSMutableCharacterSet new];
	[charset addCharactersInString:@"±§!$%^&*()-+={}[];:'\"\\|,./<>?`~ÅÍÎÏ"];
	[charset addCharactersInString:@"¡™£¢∞§¶•ªº–≠œ∑´®†¥¨ˆøπ“‘åß∂ƒ©˙∆˚¬…æ«ÓÔ"];
	[charset addCharactersInString:@"Ω≈ç√∫˜µ≤≥÷⁄€‹›ﬁﬂ‡°·—Œ„´‰ˇÁ¨ˆØ∏”’˝ÒÚÆ"];
	[charset addCharactersInString:@"»¸˛Ç◊ı˜Â¯˘¿"];
	return charset;
}

// Detects all types of URLs (except special Twitter names)
- (NSString *) detectURL:(NSString *)string {	
	NSRange range;
	
	range = [string rangeOfString:@"http://"];
	if (range.location != NSNotFound) {
		NSString *substring = [string substringFromIndex:range.location];
		NSRange charsetRange = [substring 
			rangeOfCharacterFromSet:[self httpDelimitingCharset]];
		if (charsetRange.location == NSNotFound) {
			return substring;
		} else {
			return [substring substringToIndex:charsetRange.location];
		}
	}

	range = [string rangeOfString:@"www."];
	if (range.location != NSNotFound) {
		NSString *substring = [string substringFromIndex:range.location];
		NSRange charsetRange = [substring 
			rangeOfCharacterFromSet:[self httpDelimitingCharset]];
		if (charsetRange.location == NSNotFound) {
			return substring;
		} else {
			return [substring substringToIndex:charsetRange.location];
		}
	}
	
	range = [string rangeOfString:@"mailto:"];
	if (range.location != NSNotFound) {
		NSString *substring = [string substringFromIndex:range.location];
		NSRange charsetRange = [substring 
			rangeOfCharacterFromSet:[self httpDelimitingCharset]];
		if (charsetRange.location == NSNotFound) {
			return substring;
		} else {
			return [substring substringToIndex:charsetRange.location];
		}
	}
	
	return nil;
}

// Detects Twitter usernames
- (NSString *) detectUsername:(NSString *)string {	
	NSRange range = [string rangeOfString:@"@"];
	if (range.location == NSNotFound) {
		return NULL;
	} else {
		if (range.location == 0) {
			NSString *substring = [string substringFromIndex:range.location];
			NSRange charsetRange = [substring 
				rangeOfCharacterFromSet:[self usernameDelimitingCharset]];
			if (charsetRange.location == NSNotFound) {
				return substring;
			} else {
				return [substring substringToIndex:charsetRange.location];
			}
		} else {
			NSString *previousSubstring = [string 
				substringToIndex:range.location];
			NSCharacterSet *alphanumericCharset = [NSCharacterSet 
								alphanumericCharacterSet];
			unichar lastChar = [previousSubstring 
				characterAtIndex:([previousSubstring length]-1)];
			if ([alphanumericCharset characterIsMember:lastChar]) {
				return NULL;
			} else {
				NSString *substring = [string 
					substringFromIndex:range.location];
				NSRange charsetRange = [substring 
					rangeOfCharacterFromSet:[self usernameDelimitingCharset]];
				if (charsetRange.location == NSNotFound) {
					return substring;
				} else {
					return [substring substringToIndex:charsetRange.location];
				}
			}
		}
	}
}

// Detects hashtags
- (NSString *) detectHashtag:(NSString *)string {
	NSRange range = [string rangeOfString:@"#"];
	if (range.location == NSNotFound) {
		return NULL;
	} else {
		if (range.location == 0) {
			NSString *substring = [string substringFromIndex:range.location];
			NSRange charsetRange = [substring 
				rangeOfCharacterFromSet:[self hashtagDelimitingCharset]];
			if (charsetRange.location == NSNotFound) {
				return substring;
			} else {
				return [substring substringToIndex:charsetRange.location];
			}
		} else {
			NSString *previousSubstring = [string 
										   substringToIndex:range.location];
			NSCharacterSet *alphanumericCharset = [NSCharacterSet 
												   alphanumericCharacterSet];
			unichar lastChar = [previousSubstring 
				characterAtIndex:([previousSubstring length]-1)];
			if ([alphanumericCharset characterIsMember:lastChar]) {
				return NULL;
			} else {
				NSString *substring = [string 
									   substringFromIndex:range.location];
				NSRange charsetRange = [substring 
					rangeOfCharacterFromSet:[self hashtagDelimitingCharset]];
				if (charsetRange.location == NSNotFound) {
					return substring;
				} else {
					return [substring substringToIndex:charsetRange.location];
				}
			}
		}
	}
}

// Returns an attributed string for an emoticon
- (NSAttributedString *) emoticonStringWithName:(NSString *)name {
	NSString *emoticonPath = [NSBundle pathForResource:name
												ofType:@"png"
										   inDirectory:@"./Canary.app"];
	NSFileWrapper *emoticon = [[NSFileWrapper alloc] 
							   initWithPath:emoticonPath];
	NSTextAttachment *emoticonAttachment = [[NSTextAttachment alloc] 
											initWithFileWrapper:emoticon];
	NSAttributedString *emoticonString = [NSAttributedString 
							attributedStringWithAttachment:emoticonAttachment];
	return emoticonString;
}

// Highlights the detected elements in statuses (and enables actions on 
// clicking)
- (void) highlightElements {
	NSScanner *scanner;
	NSRange scanRange;
	NSString *scanString;
	NSCharacterSet *terminalCharacterSet;
	NSURL *foundURL;
	NSString *foundURLString;
	NSString *username;
	NSString *hashtag;
	NSDictionary *linkAttr, *usernameAttr, *hashtagAttr;
	
	scanner = [NSScanner scannerWithString:[self string]];
	terminalCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
	while (![scanner isAtEnd]) {
		[scanner scanUpToCharactersFromSet:terminalCharacterSet
								intoString:&scanString];
		scanRange.length = [scanString length];
		scanRange.location = [scanner scanLocation] - scanRange.length;
		
		// URLs
		if (foundURLString = [self detectURL:scanString]) {
			NSRange prefixRange = [foundURLString rangeOfString:@"http://"];
			NSRange wwwRange = [foundURLString rangeOfString:@"www."];
			if (prefixRange.location == NSNotFound && 
					wwwRange.location == 0) {
				foundURL = [NSURL URLWithString:[NSString 
					stringWithFormat:@"http://%@", foundURLString]];
			} else {
				foundURL = [NSURL URLWithString:foundURLString];
			}
			linkAttr = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSColor blueColor], NSForegroundColorAttributeName,
					[NSNumber numberWithInt:NSSingleUnderlineStyle], 
						NSUnderlineStyleAttributeName,
							foundURL, NSLinkAttributeName, NULL];
			NSRange newRange = [scanString rangeOfString:foundURLString];
			NSRange attrRange;
			attrRange.location = scanRange.location + newRange.location;
			attrRange.length = newRange.length;
			[self addAttributes:linkAttr range:attrRange];
		}
		
		// Twitter usernames
		if (username = [self detectUsername:scanString]) {
			NSMutableString *userLinkString = [NSMutableString 
				stringWithString:@"http://twitter.com/"];
			[userLinkString appendString:[username substringFromIndex:1]];
			foundURL = [NSURL URLWithString:userLinkString];
			usernameAttr = [NSDictionary dictionaryWithObjectsAndKeys:
				foundURL, NSLinkAttributeName, 
					[NSColor darkGrayColor], 
						NSForegroundColorAttributeName, NULL];
			NSRange newRange = [scanString rangeOfString:username];
			NSRange attrRange;
			attrRange.location = scanRange.location + newRange.location;
			attrRange.length = newRange.length;
			[self addAttributes:usernameAttr range:attrRange];
		}
		
		// Hashtags
		if (hashtag = [self detectHashtag:scanString]) {
			NSLog(@"hashtag: %@", hashtag);
			NSMutableString *hashtagString = [NSMutableString stringWithString:@"http://search.twitter.com/search?q=%23"];
			[hashtagString appendString:[hashtag substringFromIndex:1]];
			foundURL = [NSURL URLWithString:hashtagString];
			hashtagAttr = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSColor blueColor], NSForegroundColorAttributeName,
					[NSNumber numberWithInt:NSSingleUnderlineStyle], 
						NSUnderlineStyleAttributeName,
									   foundURL, NSLinkAttributeName, NULL];
			NSRange newRange = [scanString rangeOfString:hashtag];
			NSRange attrRange;
			attrRange.location = scanRange.location + newRange.location;
			attrRange.length = newRange.length;
			[self addAttributes:hashtagAttr range:attrRange];
		}
	}
}

@end
