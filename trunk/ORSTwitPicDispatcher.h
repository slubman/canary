//
//  ORSTwitPicDispatcher.h
//  Canary
//
//  Created by Nicholas Toumpelis on 09/12/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 9/12/2008

#import <Cocoa/Cocoa.h>

@interface ORSTwitPicDispatcher : NSObject {

}

- (NSString *) uploadData:(NSData *)imageData
			 withUsername:(NSString *)username
				 password:(NSString *)password
				 filename:(NSString *)filename;

@end