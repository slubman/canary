//
//  ORSAsyncTwitPicDispatcher.h
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

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
