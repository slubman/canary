//
//  ORSUrlborgShortener.m
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import "ORSUrlborgShortener.h"

@implementation ORSUrlborgShortener

// This method returns the generated (shortened) URL that corresponds to the 
// given (original) URL.
- (NSString *) generateURLFrom:(NSString *)originalURL {
	return [self generateAuthenticatedURLFrom:originalURL];
}

// This method returns the generated (shortened) URL that corresponds to the
// given (original) URL using the specified set of authentication credentials.
- (NSString *) generateAuthenticatedURLFrom:(NSString *)originalURL {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *apiKey = [defaults stringForKey:@"UrlborgAPIKey"];
	NSMutableString *requestURL = [NSMutableString 
		stringWithString:@"http://urlborg.com/api/"];
	if (apiKey) {
		[requestURL appendFormat:@"%@/url/create_or_reuse.xml/", apiKey];
	}
	
	[requestURL appendFormat:@"%@", originalURL];
	
	NSError *error, *documentError = NULL;
	NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithXMLString:[super 
		generateURLFromRequestURL:requestURL] options:NSXMLDocumentTidyXML
			error:&documentError];
	NSXMLNode *mainNode = (NSXMLNode *)[xmlDocument rootElement];
	NSArray *nodes = [mainNode nodesForXPath:@".//s_url" error:&error];
	NSXMLNode *firstNode = (NSXMLNode *)[nodes objectAtIndex:0];
	NSString *shortURL = [firstNode stringValue];
	return shortURL;
}

@end