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

static ORSCanaryPreferencesController *sharedPreferencesController = nil;

+ (ORSCanaryPreferencesController *)sharedPreferencesController {
	@synchronized(self) {
		if (sharedPreferencesController == nil) {
			[[self alloc] initWithWindowNibName:@"Preferences"];
		}
	}
	return sharedPreferencesController;
}

+ (id) allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedPreferencesController == nil) {
			sharedPreferencesController = [super allocWithZone:zone];
			return sharedPreferencesController;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone *)zone {
	return self;
} 

- (id) initWithWindow:(NSWindow *)window {
	if (self = [super initWithWindow:window]) {
		filters = [[NSArray alloc] init];
	}
	return self;
}

- (void) windowWillClose:(NSNotification *)notification {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setFloat:self.window.frame.origin.x
				forKey:@"CanaryPreferencesWindowX"];
	[defaults setFloat:self.window.frame.origin.y
				forKey:@"CanaryPreferencesWindowY"];
	[defaults setFloat:self.window.frame.size.width
				forKey:@"CanaryPreferencesWindowWidth"];
	[defaults setFloat:self.window.frame.size.height
				forKey:@"CanaryPreferencesWindowHeight"];
}

- (void) awakeFromNib {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[self urlShortenerSelected:self];
	if ([defaults floatForKey:@"CanaryPreferencesWindowX"]) {
		NSRect newFrame = NSMakeRect(
			[defaults floatForKey:@"CanaryPreferencesWindowX"],
			[defaults floatForKey:@"CanaryPreferencesWindowY"],
			[defaults floatForKey:@"CanaryPreferencesWindowWidth"],
			[defaults floatForKey:@"CanaryPreferencesWindowHeight"]);
		[[self window] setFrame:newFrame display:YES];
	} else {
		[self.window center];
	}
}

- (IBAction) timelineRefreshRateSelected:sender {
	[[ORSCanaryController sharedController] updateTimer];
}

- (IBAction) maxShownUpdatesSelected:sender {
	[[ORSCanaryController sharedController] updateMaxNoOfShownUpdates];
}

- (IBAction) urlShortenerSelected:sender {
	[[ORSCanaryController sharedController] updateSelectedURLShortener];
	if ([selectedShortenerPopUp.selectedItem.title isEqualToString:@"Adjix"]) {
		[shortenerSettingsTabView selectTabViewItemAtIndex:0];
	} else if ([selectedShortenerPopUp.selectedItem.title 
				isEqualToString:@"Bit.ly"]) {
		[shortenerSettingsTabView selectTabViewItemAtIndex:1];
	} else if ([selectedShortenerPopUp.selectedItem.title 
				isEqualToString:@"Cli.gs"]) {
		[shortenerSettingsTabView selectTabViewItemAtIndex:2];
	} else if ([selectedShortenerPopUp.selectedItem.title 
				isEqualToString:@"Is.gd"]) {
		[shortenerSettingsTabView selectTabViewItemAtIndex:3];
	} else if ([selectedShortenerPopUp.selectedItem.title 
				isEqualToString:@"SnipURL"]) {
		[shortenerSettingsTabView selectTabViewItemAtIndex:4];
	} else if ([selectedShortenerPopUp.selectedItem.title 
				isEqualToString:@"TinyURL"]) {
		[shortenerSettingsTabView selectTabViewItemAtIndex:5];
	} else if ([selectedShortenerPopUp.selectedItem.title 
				isEqualToString:@"tr.im"]) {
		[shortenerSettingsTabView selectTabViewItemAtIndex:6];
	} else if ([selectedShortenerPopUp.selectedItem.title 
				isEqualToString:@"urlBorg"]) {
		[shortenerSettingsTabView selectTabViewItemAtIndex:7];
	}
}

- (IBAction) addFilter:sender {
	ORSFilter *newFilter = [[ORSFilter alloc] init];
	newFilter.filterName = @"New Filter";
	newFilter.active = YES;
	newFilter.predicate = [NSPredicate 
		predicateWithFormat:@"(text contains \"Adam\") AND \
						   (text contains \"Eve\")"];
	[filterArrayController insertObject:newFilter 
				  atArrangedObjectIndex:0];
	[filterArrayController setSelectionIndex:0];
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
