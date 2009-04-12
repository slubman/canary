//
//  ORSTwitPicDispatcher.h
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import <Cocoa/Cocoa.h>

@interface ORSTwitPicDispatcher : NSObject {

}

- (NSString *) uploadData:(NSData *)imageData
			 withUsername:(NSString *)username
				 password:(NSString *)password
				 filename:(NSString *)filename;

@end