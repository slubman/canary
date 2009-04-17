//
//  NSMutableAttributedString+ORSCanaryAdditions.m
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import "NSMutableAttributedString+ORSCanaryAdditions.h"

@implementation NSMutableAttributedString ( ORSCanaryAdditions )

// Returns an HTTP URL delimiting character set
- (NSCharacterSet *) httpDelimitingCharset {
	NSMutableCharacterSet *charset = [NSMutableCharacterSet new];
	[charset addCharactersInString:@"±§$^*(){}[];'\"\\|,<>`ÅÍÎÏ¡™£¢∞§¶"];
	[charset addCharactersInString:@"•ªº≠œ∑´®†¥¨ˆøπ“‘åß∂ƒ©˙∆˚¬…æ«ÓÔ˘¿Â¯"];
	[charset addCharactersInString:@"Ω≈ç√∫˜µ≤≥÷€‹›ﬁﬂ‡°·—Œ„´‰ˇÁ¨ˆØ∏”’˝ÒÚÆ"];
	[charset addCharactersInString:@"»¸˛Ç◊ı˜!"];
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

// Returns a delimiting character set for identica group
- (NSCharacterSet *) groupDelimitingCharset {
	NSMutableCharacterSet *charset = [NSMutableCharacterSet new];
	[charset addCharactersInString:@"±§!$%^&*()-+={}[];:'\"\\|,./<>?`~ÅÍÎÏ"];
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
	
	range = [string rangeOfString:@"www.."];
	if (range.location != NSNotFound) {
		return nil;
	}
	
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
	if (range.location == 0) {
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

// Detects identica groups
- (NSString *) detectGroup:(NSString *)string {
	//return NULL;
	NSRange range = [string rangeOfString:@"!"];
	if (range.location == NSNotFound) {
		return NULL;
	} else {
		if (range.location == 0) {
			NSString *substring = [string substringFromIndex:range.location+1];
			NSRange charsetRange = [substring 
				rangeOfCharacterFromSet:[self groupDelimitingCharset]];
			if (charsetRange.location == NSNotFound) {
				if ([string compare:@"!"] == NSOrderedSame) { // the ! is alone
					return NULL;
				} else {
					return string;
				}
			} else {
				return [string substringToIndex:charsetRange.location+1];
			}
		}
	}
	return NULL;
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

// Detects DOIs
- (NSString *) detectDOI:(NSString *)string {
	NSRange range = [string rangeOfString:@"doi:"];
	if (range.location == NSNotFound) {
		return NULL;
	} else {
		if (range.location == 0) {
			NSString *substring = [string substringFromIndex:range.location];
			NSRange charsetRange = [substring 
					rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
					rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				if (charsetRange.location == NSNotFound) {
					return substring;
				} else {
					return [substring substringToIndex:charsetRange.location];
				}
			}
		}
	}
}

// Detects HDLs
- (NSString *) detectHDL:(NSString *)string {
	NSRange range = [string rangeOfString:@"hdl:"];
	if (range.location == NSNotFound) {
		return NULL;
	} else {
		if (range.location == 0) {
			NSString *substring = [string substringFromIndex:range.location];
			NSRange charsetRange = [substring 
									rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
										rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				if (charsetRange.location == NSNotFound) {
					return substring;
				} else {
					return [substring substringToIndex:charsetRange.location];
				}
			}
		}
	}
}

// Detects ISBNs
- (NSString *) detectISBN:(NSString *)string {
	NSRange range = [string rangeOfString:@"isbn:"];
	if (range.location == NSNotFound) {
		return NULL;
	} else {
		if (range.location == 0) {
			NSString *substring = [string substringFromIndex:range.location];
			NSRange charsetRange = [substring 
									rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
										rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				if (charsetRange.location == NSNotFound) {
					return substring;
				} else {
					return [substring substringToIndex:charsetRange.location];
				}
			}
		}
	}
}

// Detects ISSNs
- (NSString *) detectISSN:(NSString *)string {
	NSRange range = [string rangeOfString:@"issn:"];
	if (range.location == NSNotFound) {
		return NULL;
	} else {
		if (range.location == 0) {
			NSString *substring = [string substringFromIndex:range.location];
			NSRange charsetRange = [substring 
									rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
										rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				if (charsetRange.location == NSNotFound) {
					return substring;
				} else {
					return [substring substringToIndex:charsetRange.location];
				}
			}
		}
	}
}

// Detects IETFs
- (NSString *) detectIETF:(NSString *)string {
	NSRange range = [string rangeOfString:@"ietf:rfc:"];
	if (range.location == NSNotFound) {
		return NULL;
	} else {
		if (range.location == 0) {
			NSString *substring = [string substringFromIndex:range.location];
			NSRange charsetRange = [substring 
									rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
										rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				if (charsetRange.location == NSNotFound) {
					return substring;
				} else {
					return [substring substringToIndex:charsetRange.location];
				}
			}
		}
	}
}

// Detects NBNs
- (NSString *) detectNBN:(NSString *)string {
	NSRange range = [string rangeOfString:@"nbn:"];
	if (range.location == NSNotFound) {
		return NULL;
	} else {
		if (range.location == 0) {
			NSString *substring = [string substringFromIndex:range.location];
			NSRange charsetRange = [substring 
									rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
										rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
	NSString *foundURLString, *username, *group, *hashtag, *doi, *hdl, *isbn, *issn,
		*ietf, *nbn;
	NSDictionary *linkAttr, *usernameAttr, *groupAttr, *hashtagAttr, *doiAttr, *hdlAttr, 
		*isbnAttr, *issnAttr, *ietfAttr, *nbnAttr;
	
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
			/*NSMutableString *userLinkString = [NSMutableString 
				stringWithString:@"http://twitter.com/"];*/
			NSMutableString *userLinkString = [NSMutableString 
				stringWithString:@"http://identi.ca/"];
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
		
		// identi.ca groups
		if (group = [self detectGroup:scanString]) {
			NSMutableString *groupLinkString = [NSMutableString 
				stringWithString:@"http://identi.ca/group/"];
			[groupLinkString appendString:[group substringFromIndex:1]];
			foundURL = [NSURL URLWithString:groupLinkString];
			groupAttr = [NSDictionary dictionaryWithObjectsAndKeys:
				foundURL, NSLinkAttributeName, 
					[NSColor darkGrayColor], 
						NSForegroundColorAttributeName, NULL];
			NSRange newRange = [scanString rangeOfString:group];
			NSRange attrRange;
			attrRange.location = scanRange.location + newRange.location;
			attrRange.length = newRange.length;
			[self addAttributes:groupAttr range:attrRange];
		}
		
		// Hashtags
		if (hashtag = [self detectHashtag:scanString]) {
			/*NSMutableString *hashtagString = [NSMutableString 
				stringWithString:@"http://search.twitter.com/search?q=%23"];*/
			NSMutableString *hashtagString = [NSMutableString 
				stringWithString:@"http://identi.ca/search?q=%23"];
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
		
		// DOIs
		if (doi = [self detectDOI:scanString]) {
			NSMutableString *doiString = [NSMutableString 
				stringWithString:@"http://dx.doi.org/"];
			[doiString appendString:doi];
			foundURL = [NSURL URLWithString:doiString];
			doiAttr = [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSColor redColor], NSForegroundColorAttributeName,
						   [NSNumber numberWithInt:NSSingleUnderlineStyle], 
						   NSUnderlineStyleAttributeName,
						   foundURL, NSLinkAttributeName, NULL];
			NSRange newRange = [scanString rangeOfString:doi];
			NSRange attrRange;
			attrRange.location = scanRange.location + newRange.location;
			attrRange.length = newRange.length;
			[self addAttributes:doiAttr range:attrRange];
		}
		
		// HDLs
		if (hdl = [self detectHDL:scanString]) {
			NSMutableString *hdlString = [NSMutableString 
				stringWithString:@"http://dx.doi.org/"];
			[hdlString appendString:hdl];
			foundURL = [NSURL URLWithString:hdlString];
			hdlAttr = [NSDictionary dictionaryWithObjectsAndKeys:
					   [NSColor redColor], NSForegroundColorAttributeName,
					   [NSNumber numberWithInt:NSSingleUnderlineStyle], 
					   NSUnderlineStyleAttributeName,
					   foundURL, NSLinkAttributeName, NULL];
			NSRange newRange = [scanString rangeOfString:hdl];
			NSRange attrRange;
			attrRange.location = scanRange.location + newRange.location;
			attrRange.length = newRange.length;
			[self addAttributes:hdlAttr range:attrRange];
		}
		
		// ISBNs
		if (isbn = [self detectISBN:scanString]) {
			NSMutableString *isbnString = [NSMutableString 
				stringWithString:@"http://books.google.com/books?q="];
			[isbnString appendString:isbn];
			foundURL = [NSURL URLWithString:isbnString];
			isbnAttr = [NSDictionary dictionaryWithObjectsAndKeys:
					   [NSColor redColor], NSForegroundColorAttributeName,
					   [NSNumber numberWithInt:NSSingleUnderlineStyle], 
					   NSUnderlineStyleAttributeName,
					   foundURL, NSLinkAttributeName, NULL];
			NSRange newRange = [scanString rangeOfString:isbn];
			NSRange attrRange;
			attrRange.location = scanRange.location + newRange.location;
			attrRange.length = newRange.length;
			[self addAttributes:isbnAttr range:attrRange];
		}
		
		// ISSNs
		if (issn = [self detectISSN:scanString]) {
			NSMutableString *issnString = [NSMutableString 
						stringWithString:@"http://books.google.com/books?q="];
			[issnString appendString:issn];
			foundURL = [NSURL URLWithString:issnString];
			issnAttr = [NSDictionary dictionaryWithObjectsAndKeys:
						[NSColor redColor], NSForegroundColorAttributeName,
						[NSNumber numberWithInt:NSSingleUnderlineStyle], 
						NSUnderlineStyleAttributeName,
						foundURL, NSLinkAttributeName, NULL];
			NSRange newRange = [scanString rangeOfString:issn];
			NSRange attrRange;
			attrRange.location = scanRange.location + newRange.location;
			attrRange.length = newRange.length;
			[self addAttributes:issnAttr range:attrRange];
		}
		
		// IETF RFCs
		if (ietf = [self detectIETF:scanString]) {
			NSMutableString *ietfString = [NSMutableString 
				stringWithString:@"http://www.ietf.org/rfc/rfc"];
			[ietfString appendString:[ietf substringFromIndex:9]];
			[ietfString appendString:@".txt"];
			foundURL = [NSURL URLWithString:ietfString];
			ietfAttr = [NSDictionary dictionaryWithObjectsAndKeys:
						[NSColor redColor], NSForegroundColorAttributeName,
						[NSNumber numberWithInt:NSSingleUnderlineStyle], 
						NSUnderlineStyleAttributeName,
						foundURL, NSLinkAttributeName, NULL];
			NSRange newRange = [scanString rangeOfString:ietf];
			NSRange attrRange;
			attrRange.location = scanRange.location + newRange.location;
			attrRange.length = newRange.length;
			[self addAttributes:ietfAttr range:attrRange];
		}
		
		// NBNs
		if (nbn = [self detectNBN:scanString]) {
			NSMutableString *nbnString = [NSMutableString 
				stringWithString:@"http://nbn-resolving.org/urn/resolver.pl?urn=urn:"];
			[nbnString appendString:nbn];
			foundURL = [NSURL URLWithString:nbnString];
			nbnAttr = [NSDictionary dictionaryWithObjectsAndKeys:
						[NSColor redColor], NSForegroundColorAttributeName,
						[NSNumber numberWithInt:NSSingleUnderlineStyle], 
						NSUnderlineStyleAttributeName,
						foundURL, NSLinkAttributeName, NULL];
			NSRange newRange = [scanString rangeOfString:nbn];
			NSRange attrRange;
			attrRange.location = scanRange.location + newRange.location;
			attrRange.length = newRange.length;
			[self addAttributes:nbnAttr range:attrRange];
		}
	}
}

@end
