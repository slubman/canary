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
	[filterPredicateEditor setContinuous:YES];
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
	newFilter.filterName = @"New Filter";
	newFilter.active = YES;
	NSPredicate *subpredicate = [NSPredicate predicateWithFormat:@"text contains \"text\""];
	NSArray *subpredicates = [NSArray arrayWithObject:subpredicate];
	newFilter.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
	[filterArrayController addObject:newFilter];
	[NSApp beginSheet:filterEditor
	   modalForWindow:self.window
		modalDelegate:self
	   didEndSelector:@selector(didEndNewFilterSheet:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (IBAction) editFilter:sender {
	tempFilter = [[[filterArrayController selectedObjects]
				   objectAtIndex:0] copy];
	[NSApp beginSheet:filterEditor
	   modalForWindow:self.window
		modalDelegate:self
	   didEndSelector:@selector(didEndEditFilterSheet:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (IBAction) duplicateFilter:sender {
	ORSFilter *duplicateFilter = [[[filterArrayController selectedObjects]
								   objectAtIndex:0] copy];
	[filterArrayController addObject:duplicateFilter];
}

- (IBAction) cancelFilterChanges:sender {
	[filterArrayController discardEditing];
	[filterEditor orderOut:sender];
	[NSApp endSheet:filterEditor returnCode:0];
}

- (IBAction) keepFilterChanges:sender {
	[filterArrayController commitEditing];	
	[filterEditor orderOut:sender];
	[NSApp endSheet:filterEditor returnCode:1];
}

- (void) didEndNewFilterSheet:(NSWindow *)sheet
					 returnCode:(int)returnCode
					contextInfo:(void *)contextInfo {
	if (returnCode == 0) {
		[filterArrayController remove:nil];
	}
}

- (void) didEndEditFilterSheet:(NSWindow *)sheet
					returnCode:(int)returnCode
				   contextInfo:(void *)contextInfo {
	int selIndex = filterArrayController.selectionIndex;
	if (returnCode == 0) {
		[filterArrayController remove:nil];
		[filterArrayController insertObject:tempFilter 
					  atArrangedObjectIndex:selIndex];
	}
}

@end
