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

- (id) initWithWindow:(NSWindow *)window {
	if (self = [super initWithWindow:window]) {
		filters = [[NSArray alloc] init];
	}
	return self;
}

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

- (IBAction) addFilter:sender {
	ORSFilter *newFilter = [[ORSFilter alloc] init];
	newFilter.filterName = @"Filter #1";
	newFilter.active = YES;
	[filterArrayController addObject:newFilter];
	[self showFilterSheet:sender];
}

- (IBAction) editFilter:sender {
	[self showFilterSheet:sender];
}

- (IBAction) duplicateFilter:sender {
	ORSFilter *duplicateFilter = [[[filterArrayController selectedObjects]
								   objectAtIndex:0] copy];
	[filterArrayController addObject:duplicateFilter];
}



- (IBAction) showFilterSheet:sender {
	[NSApp beginSheet:filterEditor
	   modalForWindow:self.window
		modalDelegate:self
	   didEndSelector:@selector(didEndNewFilterSheet:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (IBAction) cancelNewFilter:sender {
	[filterEditor orderOut:sender];
	[NSApp endSheet:filterEditor returnCode:0];
}

- (IBAction) newFilterCreated:sender {
	[filterEditor orderOut:sender];
	[NSApp endSheet:filterEditor returnCode:0];
}

- (void) didEndNewFilterSheet:(NSWindow *)sheet
					 returnCode:(int)returnCode
					contextInfo:(void *)contextInfo {
}

@end
