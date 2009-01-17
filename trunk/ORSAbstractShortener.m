//
//  ORSAbstractShortener.m
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 27/12/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 27/12/2008

#import "ORSAbstractShortener.h"

@implementation ORSAbstractShortener

// This method is abstract. When this is implemented, it returns the 
// shortened URL that corresponds to the given original URL.
- (NSString *) generateURLFrom:(NSString *)originalURL {
	return NULL;
}

// This should be used by all concrete classes that implement generateURLFrom:.
// It generates the actual request that is sent to the remote server.
- (NSString *) generateURLFromRequestURL:(NSString *)requestURL {
	NSURLRequest *request = [NSURLRequest 
		requestWithURL:[NSURL URLWithString:requestURL]
			cachePolicy:NSURLRequestUseProtocolCachePolicy
				timeoutInterval:21.0];
	NSURLResponse *response = nil;
	NSError *error = nil;
	return [[NSString alloc] initWithData:[NSURLConnection 
		sendSynchronousRequest:request 
			returningResponse:&response 
					error:&error]
					encoding:NSASCIIStringEncoding];
}

@end
