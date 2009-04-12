//
//  ORSCanaryDragView.h
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

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
