//
//  ORSCanaryDragView.m
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import "ORSCanaryDragView.h"

@implementation ORSCanaryDragView

- (id) initWithFrame:(NSRect)rect {
	if (self = [super initWithFrame:rect]) {
		// Registering newStatusTextField for dragging types
		[self registerForDraggedTypes:[NSArray
			arrayWithObject:NSFilenamesPboardType]];
		highlighted = NO;
		attributes = [[NSMutableDictionary alloc] init];
		[attributes setObject:[NSFont boldSystemFontOfSize:12] 
					   forKey:NSFontAttributeName];
		[attributes setObject:[NSColor whiteColor]
						   forKey:NSForegroundColorAttributeName];
	}
	return self;
}

- (NSView *) hitTest:(NSPoint)aPoint {
	return nil;
}

- (void) drawRect:(NSRect)rect {
	NSRect bounds = [self bounds];
	if (highlighted) {
		[[NSColor keyboardFocusIndicatorColor] set];
		[NSBezierPath fillRect:bounds];
		[[NSColor controlHighlightColor] set];
		[NSBezierPath setDefaultLineWidth:3.0];
		[NSBezierPath strokeRect:rect];
		
		NSString *string = @"Send image to TwitPic";
		NSSize strSize = [string sizeWithAttributes:attributes];
		NSPoint strOrigin;
		strOrigin.x = rect.origin.x + (rect.size.width - strSize.width)/2;
		strOrigin.y = rect.origin.y + (rect.size.height - strSize.height)/2;
		[string drawAtPoint:strOrigin withAttributes:attributes];
	} else {
		[[NSColor clearColor] set];
		[NSBezierPath fillRect:bounds];
	}
}

- (NSDragOperation) draggingEntered:(id <NSDraggingInfo>)sender {
	highlighted = YES;
	[self setNeedsDisplay:YES];
	return NSDragOperationCopy;
}

- (NSDragOperation) draggingUpdated:(id <NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (void) draggingExited:(id <NSDraggingInfo>)sender {
	highlighted = NO;
	[self setNeedsDisplay:YES];
}

- (BOOL) prepareForDragOperation:(id <NSDraggingInfo>)sender {
	// check for filetypes here.
	return YES;
}

- (BOOL) performDragOperation:(id <NSDraggingInfo>) sender {
	NSPasteboard *pboard = [sender draggingPasteboard];
	
	if ([[pboard types] containsObject:NSFilenamesPboardType]) {
		NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		NSString *filename = (NSString *)[files objectAtIndex:0];
		[[ORSCanaryController sharedController] executeAsyncCallToTwitPicWithFile:filename];		
	}		
	return YES;
}

- (void) concludeDragOperation:(id <NSDraggingInfo>)sender {
    highlighted = NO;
	[self setNeedsDisplay:YES];
}

@end
