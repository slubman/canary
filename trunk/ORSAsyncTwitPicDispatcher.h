//
//  ORSAsyncTwitPicDispatcher.h
//  Canary
//
//  Created by Nicholas Toumpelis on 09/12/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.7 - 22/01/2009

#import <Cocoa/Cocoa.h>

@interface ORSAsyncTwitPicDispatcher : NSObject {
	
@private
	NSMutableData *dataReceived;
	NSURLConnection *mainConnection;

}

- (void) uploadData:(NSData *)imageData
	   withUsername:(NSString *)username
		   password:(NSString *)password
		   filename:(NSString *)filename;

@end
