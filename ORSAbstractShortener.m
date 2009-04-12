//
//  ORSAbstractShortener.m
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

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

// This should be used by all concrete classes that implement generateURLFrom:
// and would like to send POST requests. It generates the actual request that 
// is sent to the remote server.
- (NSString *) generateURLFromPostRequestURL:(NSString *)requestURL {
	NSMutableURLRequest *request = [NSMutableURLRequest
		requestWithURL:[NSURL URLWithString:requestURL]
			cachePolicy:NSURLRequestUseProtocolCachePolicy
				timeoutInterval:21.0];
	[request setHTTPMethod:@"POST"];
	NSURLResponse *response = nil;
	NSError *error = nil;
	return [[NSString alloc] initWithData:[NSURLConnection 
		sendSynchronousRequest:request 
			returningResponse:&response 
				error:&error]
					encoding:NSASCIIStringEncoding];
}

@end
