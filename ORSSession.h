//
//  ORSSession.h
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 11/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 19/10/2008
//  0.7 - 21/01/2009

#import <Cocoa/Cocoa.h>

@interface ORSSession : NSObject <NSCopying> {

@private
	NSString *userID;
	NSString *password;
	NSMutableData *dataReceived;
	NSURLConnection *mainConnection;
	
}

- (id) initWithUserID:(NSString *)newUserID
		  andPassword:(NSString *)newPassword;
- (id) copyWithZone:(NSZone *)zone;
- (NSData *) executeRequestOfType:(NSString *)type
						   atPath:(NSString *)path
					synchronously:(BOOL)synchr;
- (NSData *) executeUnencodedRequestOfType:(NSString *)type
									atPath:(NSString *)path
							 synchronously:(BOOL)synchr;
- (void) simpleExecuteRequestOfType:(NSString *)type
							 atPath:(NSString *)path
					  synchronously:(BOOL)synchr;
- (NSXMLDocument *) getXMLDocumentFromData:(NSData *)data;
- (NSXMLNode *) getNodeFromData:(NSData *)userData;
- (NSArray *) getAllStatusesFromData:(NSData *)statuses;
- (NSArray *) getAllUsersFromData:(NSData *)users;
- (NSArray *) getAllDMsFromData:(NSData *)directMessages;

// NSURLConnection delegates for asynchronous connections
- (void) connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void) connection:(NSURLConnection *)connection 
 didReceiveResponse:(NSURLResponse *)response;
- (void) connection:(NSURLConnection *)connection 
	 didReceiveData:(NSData *)dataReceived;
- (void) connection:(NSURLConnection *)connection 
   didFailWithError:(NSError *)connectionError;
- (void) connectionDidFinishLoading:(NSURLConnection *)connection;

@property(copy) NSString *userID;
@property(copy) NSString *password;

@end
