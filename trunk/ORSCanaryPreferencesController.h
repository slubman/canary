//
//  ORSCanaryPreferencesController.h
//  Canary
//
//  Created by Nicholas Toumpelis on 10/11/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 10/11/2008

#import <Cocoa/Cocoa.h>
#import "ORSCanaryController.h"
#import "ORSFilter.h"

@interface ORSCanaryPreferencesController : NSWindowController {
	NSArray *filters;
	IBOutlet NSWindow *filterEditor;
	IBOutlet NSArrayController *filterArrayController;
	ORSFilter *tempFilter;
	IBOutlet NSPredicateEditor *filterPredicateEditor;
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
