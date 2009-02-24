//
//  ORSTrimShortener.m
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 24/02/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  0.6 - 24/02/2009

#import "ORSTrimShortener.h"

@implementation ORSTrimShortener

// This method returns the generated (shortened) URL that corresponds to the 
// given (original) URL.
- (NSString *) generateURLFrom:(NSString *)originalURL {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults boolForKey:@"TrimUseAuthenticationCredentials"]) {
		return [self generateAuthenticatedURLFrom:originalURL];
	} else {
		NSString *requestURL = [NSString 
			stringWithFormat:@"http://api.tr.im/api/trim_simple?url=%@", 
								originalURL];
		return [[super generateURLFromRequestURL:requestURL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
}

// This method returns the generated (shortened) URL that corresponds to the
// given (original) URL using the specified set of authentication credentials.
- (NSString *) generateAuthenticatedURLFrom:(NSString *)originalURL {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [defaults stringForKey:@"TrimUsername"];
	NSString *password = [defaults stringForKey:@"TrimPassword"];
	NSMutableString *requestURL = [NSMutableString 
		stringWithFormat:@"http://api.tr.im/api/trim_simple?url=%@", 
								   originalURL];
	if (username) {
		[requestURL appendFormat:@"&username=%@", username];
	}
	
	if (password) {
		[requestURL appendFormat:@"&password=%@", password];
	}
	
	return [[super generateURLFromRequestURL:requestURL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
