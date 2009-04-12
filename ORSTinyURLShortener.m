//
//  ORSTinyURLShortener.m
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import "ORSTinyURLShortener.h"

@implementation ORSTinyURLShortener

// This method returns the generated (shortened) URL that corresponds to the 
// given (original) URL.
- (NSString *) generateURLFrom:(NSString *)originalURL {
	NSString *requestURL = [NSString 
		stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", 
							originalURL];
	/*NSURLRequest *request = [NSURLRequest 
		requestWithURL:[NSURL URLWithString:requestURL]
			cachePolicy:NSURLRequestUseProtocolCachePolicy
				timeoutInterval:21.0];
	NSURLResponse *response = nil;
	NSError *error = nil;
	return [[NSString alloc] initWithData:[NSURLConnection 
		sendSynchronousRequest:request returningResponse:&response error:&error]
								 encoding:NSASCIIStringEncoding];*/
	return [super generateURLFromRequestURL:requestURL];
}

@end
