//
//  ORSCanaryPreferencesController.m
//  Canary
//
//  Created by Nicholas Toumpelis on 10/11/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 10/11/2008

#import "ORSCanaryPreferencesController.h"

@implementation ORSCanaryPreferencesController

@synthesize filters;

- (void) awakeFromNib {
	[self.window center];
}

- (IBAction) timelineRefreshRateSelected:sender {
	[[ORSCanaryController sharedController] updateTimer];
}

- (IBAction) maxShownUpdatesSelected:sender {
	[[ORSCanaryController sharedController] updateMaxNoOfShownUpdates];
}

- (IBAction) urlShortenerSelected:sender {
	[[ORSCanaryController sharedController] updateSelectedURLShortener];
}

- (IBAction) showNewFilterSheet:sender {
	[NSApp beginSheet:filterEditor
	   modalForWindow:self.window
		modalDelegate:self
	   didEndSelector:@selector(didEndNewFilterSheet:returnCode:contextInfo:)
		  contextInfo:nil];
}

@end
