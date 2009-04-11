//
//  ORSCanaryAboutController.h
//  Canary
//
//  Created by Nicholas Toumpelis on 12/11/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 12/11/2008

#import <Cocoa/Cocoa.h>

@interface ORSCanaryAboutController : NSWindowController {

}

+ (ORSCanaryAboutController *)sharedAboutController;
+ (id) allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;

@end
