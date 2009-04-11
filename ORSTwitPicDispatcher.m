//
//  ORSTwitPicDispatcher.h
//  Canary
//
//  Created by Nicholas Toumpelis on 09/12/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 09/12/2008

#import "ORSTwitPicDispatcher.h"

@implementation ORSTwitPicDispatcher

- (NSString *) uploadData:(NSData *)imageData
			 withUsername:(NSString *)username
				 password:(NSString *)password 
				 filename:(NSString *)filename {
	@synchronized(self) {
		NSURL *url = [NSURL URLWithString:@"http://twitpic.com/api/upload"];
		NSMutableURLRequest *postRequest = [NSMutableURLRequest 
			requestWithURL:url
				cachePolicy:NSURLRequestUseProtocolCachePolicy 
											timeoutInterval:21.0];
		
		[postRequest setHTTPMethod:@"POST"];
		
		NSString *stringBoundary = [NSString 
			stringWithString:@"0xKhTmLbOuNdArY"];
		NSString *contentType = [NSString 
			stringWithFormat:@"multipart/form-data; boundary=%@",
								 stringBoundary];
		[postRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
		
		NSMutableData *postBody = [NSMutableData data];
		[postBody appendData:[[NSString stringWithFormat:@"\r\n\r\n--%@\r\n", 
			stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithString:
				@"Content-Disposition: form-data; name=\"source\"\r\n\r\n"] 
							  dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithString:@"canary"] 
							  dataUsingEncoding:NSUTF8StringEncoding]];
		
		[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", 
			stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithString:
			@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"]
							  dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[username dataUsingEncoding:NSUTF8StringEncoding]];
		
		[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",
			stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithString:
			@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] 
							  dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
		
		NSString *mimeType = NULL;
		if ([filename hasSuffix:@".jpeg"] || [filename hasSuffix:@".jpg"] || 
			[filename hasSuffix:@".jpe"]) {
			mimeType = @"image/jpeg";
		} else if ([filename hasSuffix:@".png"]) {
			mimeType = @"image/png";
		} else if ([filename hasSuffix:@".gif"]) {
			mimeType = @"image/gif";
		}	
		
		[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",
			stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:
		@"Content-Disposition: form-data; name=\"media\"; filename=\"%@\"\r\n", 
			filename] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString 
			stringWithFormat:@"Content-Type: %@\r\n", mimeType] 
							  dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithString:
			@"Content-Transfer-Encoding: binary\r\n\r\n"] 
							  dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:imageData];
		[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",
			stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		[postRequest setHTTPBody:postBody];
		
		NSURLResponse *response = nil;
		NSError *dataError, *documentError, *nodeError = nil;
		NSString *stringNode = [[NSString alloc] initWithData:[NSURLConnection 
			sendSynchronousRequest:postRequest returningResponse:&response 
					error:&dataError] encoding:NSUTF8StringEncoding];
		
		NSXMLDocument *document = [[NSXMLDocument alloc] 
			initWithXMLString:stringNode
				options:NSXMLDocumentTidyXML error:&documentError];
		NSXMLNode *root = [document rootElement];
		return [(NSXMLNode *)[[root nodesForXPath:@".//mediaurl" 
			error:&nodeError] objectAtIndex:0] stringValue];
	}
}

@end
