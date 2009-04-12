//
//  ORSCanaryAboutController.m
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import "ORSCanaryAboutController.h"

@implementation ORSCanaryAboutController

static ORSCanaryAboutController *sharedAboutController = nil;

+ (ORSCanaryAboutController *)sharedAboutController {
	@synchronized(self) {
		if (sharedAboutController == nil) {
			[[self alloc] initWithWindowNibName:@"About"];
		}
	}
	return sharedAboutController;
}

+ (id) allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedAboutController == nil) {
			sharedAboutController = [super allocWithZone:zone];
			return sharedAboutController;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
} 

- (void) windowWillClose:(NSNotification *)notification {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setFloat:self.window.frame.origin.x
				forKey:@"CanaryAboutWindowX"];
	[defaults setFloat:self.window.frame.origin.y
				forKey:@"CanaryAboutWindowY"];
	[defaults setFloat:self.window.frame.size.width
				forKey:@"CanaryAboutWindowWidth"];
	[defaults setFloat:self.window.frame.size.height
				forKey:@"CanaryAboutWindowHeight"];
}

- (void) awakeFromNib {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults floatForKey:@"CanaryAboutWindowX"]) {
		NSRect newFrame = NSMakeRect(
			[defaults floatForKey:@"CanaryAboutWindowX"],
			[defaults floatForKey:@"CanaryAboutWindowY"],
			[defaults floatForKey:@"CanaryAboutWindowWidth"],
			[defaults floatForKey:@"CanaryAboutWindowHeight"]);
		[[self window] setFrame:newFrame display:YES];
	} else {
		[self.window center];
	}
}

@end
