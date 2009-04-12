//
//  ORSCanaryPreferencesController.h
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import <Cocoa/Cocoa.h>
#import "ORSCanaryController.h"
#import "ORSFilter.h"

@interface ORSCanaryPreferencesController : NSWindowController {
	NSArray *filters;
	IBOutlet NSWindow *filterEditor;
	IBOutlet NSArrayController *filterArrayController;
	ORSFilter *tempFilter;
	IBOutlet NSPredicateEditor *filterPredicateEditor;
	IBOutlet NSPopUpButton *selectedShortenerPopUp;
	IBOutlet NSTabView *shortenerSettingsTabView;
}

+ (ORSCanaryPreferencesController *)sharedPreferencesController;
+ (id) allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (IBAction) timelineRefreshRateSelected:sender;
- (IBAction) maxShownUpdatesSelected:sender;
- (IBAction) urlShortenerSelected:sender;
- (IBAction) addFilter:sender;
- (IBAction) editFilter:sender;
- (IBAction) duplicateFilter:sender;
- (IBAction) cancelFilterChanges:sender;
- (IBAction) keepFilterChanges:sender;
- (void) didEndNewFilterSheet:(NSWindow *)sheet
				   returnCode:(int)returnCode
				  contextInfo:(void *)contextInfo;
- (void) didEndEditFilterSheet:(NSWindow *)sheet
				   returnCode:(int)returnCode
				  contextInfo:(void *)contextInfo;

@property(copy) NSArray *filters;

@end
