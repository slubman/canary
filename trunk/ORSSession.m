//
//  ORSSession.m
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 11/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 19/10/2008
//  0.7 - 21/01/2009

#import "ORSSession.h"

@implementation ORSSession

@synthesize userID, password;

// Initialiser
- (id) initWithUserID:(NSString *)newUserID
		  andPassword:(NSString *)newPassword {
	self = [super init];
	if (self != nil) {
		userID = newUserID;
		password = newPassword;
	}
	return self;
	
}

// Copy with zone
- (id) copyWithZone:(NSZone *)zone {
	return [[ORSSession alloc] initWithUserID:userID andPassword:password];
}

// Executes any request both synchronously and asynchronously. For asynchronous
// requests it requires the help of NSURLConnection delegates. For synchronous
// requests the data is returned directly while for asynchronous the 
// setStatuses method in the controller is called upon finishing.
- (NSData *) executeRequestOfType:(NSString *)type
						   atPath:(NSString *)path
					synchronously:(BOOL)synchr {
	@synchronized(self) {
		// Forming the first part of the request URL
		NSMutableString *requestURL = [NSMutableString 
			stringWithFormat:@"https://%@:%@@twitter.com/", userID, password];
	
		// Appending the second part of the request URL, the "path"
		[requestURL appendString:path];
		
		// Correcting the encoding
		NSString *encodedRequestURL = [requestURL 
			stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
		// Creating the request
		NSMutableURLRequest *request = [NSMutableURLRequest
			requestWithURL:[NSURL URLWithString:encodedRequestURL]
				cachePolicy:NSURLRequestUseProtocolCachePolicy
										timeoutInterval:48.0];
	
		// Adding some extra values to the request
		[request addValue:@"Canary" forHTTPHeaderField:@"X-Twitter-Client"];
		[request addValue:@"0.6" 
	   forHTTPHeaderField:@"X-Twitter-Client-Version"];
		[request addValue:@"http://macsphere.wordpress.com/" 
			forHTTPHeaderField:@"X-Twitter-Client-URL"];
	
		// Setting the request method (except GET - doesn't need to be specified
		// explicitly)
		if (![type isEqualToString:@"GET"]) {
			[request setHTTPMethod:type];
		}
		
		// Checking whether the request should be synchronous or asynchronous
		if (!synchr) {
			// If asynchronous... setting up the connection
			mainConnection = [[NSURLConnection alloc] initWithRequest:request 
														 delegate:self];
			if (mainConnection) {
				// the data buffer
				dataReceived = [NSMutableData data];
			} else {
			}
			return NULL;
		} else { 
			// If synchronous
			NSURLResponse *response = NULL;
			NSError *error = NULL;
			// the data is returned "immediately"
			NSData *data = [NSURLConnection sendSynchronousRequest:request 
											 returningResponse:&response 
														 error:&error];
			if (data) {
				return data;
			} else {
			}
			return NULL;
		}
	}
	return NULL;
}

// Executes any request without URL encoding
- (NSData *) executeUnencodedRequestOfType:(NSString *)type
									atPath:(NSString *)path
							 synchronously:(BOOL)synchr {
	@synchronized(self) {
		// Forming the first part of the request URL
		NSMutableString *requestURL = [NSMutableString 
			stringWithFormat:@"https://%@:%@@twitter.com/", userID, password];
		
		// Appending the second part of the request URL, the "path"
		[requestURL appendString:path];
		
		NSLog(@"requestURL: %@", requestURL);
		
		// Creating the request
		NSMutableURLRequest *request = [NSMutableURLRequest
			requestWithURL:[NSURL URLWithString:requestURL]
				cachePolicy:NSURLRequestUseProtocolCachePolicy
										timeoutInterval:48.0];
		
		// Adding some extra values to the request
		[request addValue:@"Canary" forHTTPHeaderField:@"X-Twitter-Client"];
		[request addValue:@"0.6" 
	   forHTTPHeaderField:@"X-Twitter-Client-Version"];
		[request addValue:@"http://macsphere.wordpress.com/" 
	   forHTTPHeaderField:@"X-Twitter-Client-URL"];
		
		// Setting the request method (except GET - doesn't need to be specified
		// explicitly)
		if (![type isEqualToString:@"GET"]) {
			[request setHTTPMethod:type];
		}
		
		// Checking whether the request should be synchronous or asynchronous
		if (!synchr) {
			// If asynchronous... setting up the connection
			mainConnection = [[NSURLConnection alloc] initWithRequest:request 
															 delegate:self];
			if (mainConnection) {
				// the data buffer
				dataReceived = [NSMutableData data];
			} else {
			}
			return NULL;
		} else { 
			// If synchronous
			NSURLResponse *response = NULL;
			NSError *error = NULL;
			// the data is returned "immediately"
			NSData *data = [NSURLConnection sendSynchronousRequest:request 
												 returningResponse:&response 
															 error:&error];
			if (data) {
				return data;
			} else {
			}
			return NULL;
		}
	}
	return NULL;
}

// Executes any request both synchronously and asynchronously. Works like above
// but does not return any data. Used in cases where returned data is not a 
// concern.
- (void) simpleExecuteRequestOfType:(NSString *)type
							 atPath:(NSString *)path
					  synchronously:(BOOL)synchr {
	@synchronized(self) {
		// Forming the first part of the request URL
		NSMutableString *requestURL = [NSMutableString 
			stringWithFormat:@"https://%@:%@@twitter.com/", userID, password];
	
		// Appending the second part of the request URL, the "path"
		[requestURL appendString:path];
		
		// Correcting the encoding
		NSString *encodedRequestURL = [requestURL 
					  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
		// Creating the request
		NSMutableURLRequest *request = [NSMutableURLRequest
			requestWithURL:[NSURL URLWithString:encodedRequestURL]
				cachePolicy:NSURLRequestUseProtocolCachePolicy
					timeoutInterval:48.0];
	
		// Adding some extra values to the request
		[request addValue:@"Canary" forHTTPHeaderField:@"X-Twitter-Client"];
		[request addValue:@"0.6" 
	   forHTTPHeaderField:@"X-Twitter-Client-Version"];
		[request addValue:@"http://macsphere.wordpress.com/" 
			forHTTPHeaderField:@"X-Twitter-Client-URL"];
	
		// Setting the request method (except GET - doesn't need to be specified
		// explicitly)
		if (![type isEqualToString:@"GET"]) {
			[request setHTTPMethod:type];
		}
	
		// Checking whether the request should be synchronous or asynchronous
		if (!synchr) {
			// If asynchronous... setting up the connection
			mainConnection = [[NSURLConnection alloc] initWithRequest:request 
														 delegate:nil];
		} else { 
			return;
		}
	}
}

// Returns an XML document from the given data
- (NSXMLDocument *) getXMLDocumentFromData:(NSData *)data {
	NSError *error = NULL;
	NSString *xml = [[NSString alloc] initWithData:data
										  encoding:NSUTF8StringEncoding];
	
    NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithXMLString:xml
		options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
														error:&error];
    if (xmlDocument == NULL) {
		xmlDocument = [[NSXMLDocument alloc] initWithXMLString:xml
			options:NSXMLDocumentTidyXML error:&error];
    }
    if (xmlDocument == NULL)  {
        if (error) {
			// Error handling
		}
        return NULL;
    }
    if (error) {
		// Error handling
	}
	return xmlDocument;
}

// Returns the node from the data received from the connection
- (NSXMLNode *) getNodeFromData:(NSData *)data {
	NSXMLDocument *xmlDocument = [self getXMLDocumentFromData:data];
	return [xmlDocument rootElement];
}

// Returns all the statuses as an array from the data received from the
// connection.
- (NSArray *) getAllStatusesFromData:(NSData *)statuses {
	NSError *error = NULL;
	NSXMLNode *root = [self getNodeFromData:statuses];
	return [root nodesForXPath:@".//status" error:&error];
}

// Returns all the users as an array from the data received from the
// connection.
- (NSArray *) getAllUsersFromData:(NSData *)users {
	NSError *error = NULL;
	NSXMLNode *root = [self getNodeFromData:users];
	return [root nodesForXPath:@".//user" error:&error];
}

// Returns all the users as an array from the data received from the
// connection.
- (NSArray *) getAllDMsFromData:(NSData *)directMessages {
	NSError *error = NULL;
	NSXMLNode *root = [self getNodeFromData:directMessages];
	return [root nodesForXPath:@".//direct_message" error:&error];
}


#pragma mark NSURLConnection delegates for async conn

// NSURLConnection delegates for asynchronous connections

// is called when the server requests (additional) authentication.
- (void) connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	@synchronized(self) {
		if ([challenge previousFailureCount] == 0) {
			NSURLCredential *newCredential = [NSURLCredential 
											  credentialWithUser:userID 
											  password:password
					persistence:NSURLCredentialPersistenceNone];
			[[challenge sender] useCredential:newCredential
				forAuthenticationChallenge:challenge];
		} else {
			[[challenge sender] cancelAuthenticationChallenge:challenge];
		}
	}
}

// is called when the connection receives a response from the server.
- (void) connection:(NSURLConnection *)connection 
					didReceiveResponse:(NSURLResponse *)response {
	@synchronized(self) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"OTEReceivedResponse"
						  object:response];
		[dataReceived setLength:0];
	}
}

// is called when the connection receives some data from the server.
- (void) connection:(NSURLConnection *)connection 
		didReceiveData:(NSData *)dataReceivedArg {
	@synchronized(self) {
		[dataReceived appendData:dataReceivedArg];
	}
}

// is called when the connection faces some kind of error.
- (void) connection:(NSURLConnection *)connection
				didFailWithError:(NSError *)connectionError {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"OTEConnectionFailure"
					  object:connectionError];
}

// is called when the data received from the server finishes.
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	@synchronized(self) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		NSXMLNode *node = [self getNodeFromData:dataReceived];
		if ([[node name] isEqualToString:@"statuses"]) {
			[nc postNotificationName:@"OTEStatusesDidFinishLoading"
							object:[self getAllStatusesFromData:dataReceived]];
		} else if ([[node name] isEqualToString:@"users"]) {
			[nc postNotificationName:@"OTEUsersDidFinishLoading"
						  object:[self getAllUsersFromData:dataReceived]];
		} else if ([[node name] isEqualToString:@"direct-messages"] || 
				   [[node name] isEqualToString:@"nilclasses"]) {
			[nc postNotificationName:@"OTEDMsDidFinishLoading"
							  object:[self getAllDMsFromData:dataReceived]];
		} else if ([[node name] isEqualToString:@"direct_message"])  {
			NSError *error = NULL;
			[nc postNotificationName:@"OTEDMDidFinishSending"
						  object:[node nodesForXPath:@".//recipientScreenName" 
											   error:&error]];
		} else if ([[node name] isEqualToString:@"status"]) {
			[nc postNotificationName:@"OTEStatusDidFinishLoading"
							object:node];
		} else if ([[node name] isEqualToString:@"hash"]) {
			NSError *error = NULL;
			[nc postNotificationName:@"OTEErrorMsgDidFinishLoading"
							  object:[node nodesForXPath:@".//error" 
												   error:&error]];
		}
	}
}

@end
