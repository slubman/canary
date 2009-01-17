//
//  ORSCanaryDragView.h
//  Canary
//
//  Created by Nicholas Toumpelis on 11/12/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 11/12/2008

#import <Cocoa/Cocoa.h>
#import "ORSCanaryController.h"

@interface ORSCanaryDragView : NSView {
	BOOL highlighted;
	NSMutableDictionary *attributes;
}

- (id) initWithFrame:(NSRect)rect;
- (void)drawRect:(NSRect)rect;
- (NSDragOperation) draggingEntered:(id <NSDraggingInfo>)sender;
- (void) draggingExited:(id <NSDraggingInfo>)sender;
- (BOOL) prepareForDragOperation:(id <NSDraggingInfo>)sender;
- (BOOL) performDragOperation:(id <NSDraggingInfo>) sender;
- (void) concludeDragOperation:(id <NSDraggingInfo>)sender;

@end
