//
//  ORSAdjixShortener.m
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import "ORSAdjixShortener.h"

@implementation ORSAdjixShortener

// This method returns the generated (shortened) URL that corresponds to the 
// given (original) URL.
- (NSString *) generateURLFrom:(NSString *)originalURL {
	/*NSString *requestURL = [NSString 
		stringWithFormat:@"http://api.adjix.com/shrinkLink?url=%@", 
							originalURL];
	return [super generateURLFromRequestURL:requestURL]; */
	return [self generateAuthenticatedURLFrom:originalURL];
}

// This method returns the generated (shortened) URL that corresponds to the
// given (original) URL using the specified set of authentication credentials.
- (NSString *) generateAuthenticatedURLFrom:(NSString *)originalURL {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *partnerID = [defaults stringForKey:@"AdjixPartnerID"];
	NSString *partnerEmail = [defaults stringForKey:@"AdjixPartnerEmail"];
	NSString *adType = [defaults stringForKey:@"AdjixAdType"];
	int useIDOrEmail = [defaults integerForKey:@"AdjixUseIDOrEmail"];
	BOOL generateUltraShortURLs = [defaults 
								   boolForKey:@"AdjixGenerateUltraShortURLs"];
	
	NSMutableString *requestURL = [NSMutableString 
		stringWithFormat:@"http://api.adjix.com/shrinkLink?url=%@", 
								   originalURL];
	if (useIDOrEmail == 0) {
		if (partnerID) {
			[requestURL appendFormat:@"&partnerID=%@", partnerID];
		}
	} else {
		if (partnerEmail) {
			[requestURL appendFormat:@"&partnerEmail=%@", partnerEmail];
		}
	}
	
	if (adType) {
		[requestURL appendFormat:@"&at=%@", adType];
	}
	
	if (generateUltraShortURLs) {
		[requestURL appendString:@"&ultraShort=y"];
	}
	
	return [super generateURLFromRequestURL:requestURL];
}

@end
