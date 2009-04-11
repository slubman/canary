//
//  ORSBitlyShortener.m
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 18/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 18/10/2008

#import "ORSBitlyShortener.h"

@implementation ORSBitlyShortener

// This method returns the generated (shortened) URL that corresponds to the 
// given (original) URL.
- (NSString *) generateURLFrom:(NSString *)originalURL {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults boolForKey:@"BitlyUseAuthenticationCredentials"]) {
		return [self generateAuthenticatedURLFrom:originalURL];
	} else {
		NSString *requestURL = [NSString 
			stringWithFormat:@"http://bit.ly/api?url=%@", originalURL];
		return [super generateURLFromRequestURL:requestURL];
	}
}

// This method returns the generated (shortened) URL that corresponds to the
// given (original) URL using the specified set of authentication credentials.
- (NSString *) generateAuthenticatedURLFrom:(NSString *)originalURL {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [defaults stringForKey:@"BitlyUsername"];
	NSString *apiKey = [defaults stringForKey:@"BitlyAPIKey"];
	NSMutableString *requestURL = [NSMutableString 
		stringWithFormat:@"http://api.bit.ly/shorten?version=2.0.1&format=xml&history=1&longUrl=%@", originalURL];
	if (username) {
		[requestURL appendFormat:@"&login=%@", username];
	}
	
	if (apiKey) {
		[requestURL appendFormat:@"&apiKey=%@", apiKey];
	}
	
	NSError *error, *documentError = NULL;
	NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithXMLString:[super 
		generateURLFromRequestURL:requestURL] options:NSXMLDocumentTidyXML
				error:&documentError];
	NSXMLNode *mainNode = (NSXMLNode *)[xmlDocument rootElement];
	NSArray *nodes = [mainNode nodesForXPath:@".//results/nodeKeyVal/shortUrl" error:&error];
	NSXMLNode *firstNode = (NSXMLNode *)[nodes objectAtIndex:0];
	NSString *shortURL = [firstNode stringValue];
	
	return shortURL;
}

@end
