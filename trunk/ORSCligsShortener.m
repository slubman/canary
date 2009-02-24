//
//  ORSCligsShortener.m
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 18/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 18/10/2008

#import "ORSCligsShortener.h"

@implementation ORSCligsShortener

// This method returns the generated (shortened) URL that corresponds to the 
// given (original) URL.
- (NSString *) generateURLFrom:(NSString *)originalURL {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults boolForKey:@"CligsUseAuthentication"]) {
		return [self generateAuthenticatedURLFrom:originalURL];
	} else {
		NSString *requestURL = [NSString 
			stringWithFormat:@"http://cli.gs/api/v1/cligs/create?url=%@", 
								originalURL];
		return [super generateURLFromRequestURL:requestURL];
	}
}

// This method returns the generated (shortened) URL that corresponds to the
// given (original) URL using the specified set of authentication credentials.
- (NSString *) generateAuthenticatedURLFrom:(NSString *)originalURL {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *apiKey = [defaults stringForKey:@"CligsAPIKey"];
	NSMutableString *requestURL = [NSMutableString 
		stringWithFormat:@"http://cli.gs/api/v1/cligs/create?url=%@&appID=canary", 
								   originalURL];
	if (apiKey) {
		[requestURL appendFormat:@"&key=%@", apiKey];
	}
	
	return [super generateURLFromRequestURL:requestURL];
}

@end
