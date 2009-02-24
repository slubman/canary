//
//  ORSSnipURLShortener.m
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 23/02/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  0.6 - 23/02/2009

#import "ORSSnipURLShortener.h"

@implementation ORSSnipURLShortener

// This method returns the generated (shortened) URL that corresponds to the 
// given (original) URL.
- (NSString *) generateURLFrom:(NSString *)originalURL {
	return [self generateAuthenticatedURLFrom:originalURL];
}

// This method returns the generated (shortened) URL that corresponds to the
// given (original) URL using the specified set of authentication credentials.
- (NSString *) generateAuthenticatedURLFrom:(NSString *)originalURL {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [defaults stringForKey:@"SnipURLUsername"];
	NSString *apiKey = [defaults stringForKey:@"SnipURLAPIKey"];
	NSMutableString *requestURL = [NSMutableString 
		stringWithFormat:@"http://snipurl.com/site/getsnip?sniplink=%@&snipformat=simple", 
								   originalURL];
	if (username) {
		[requestURL appendFormat:@"&snipuser=%@", username];
	}
	
	if (apiKey) {
		[requestURL appendFormat:@"&snipapi=%@", apiKey];
	}
	
	return [super generateURLFromPostRequestURL:requestURL];
}

@end
