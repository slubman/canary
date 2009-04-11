//
//  ORSCanaryUnderlinedButtonCell.m
//  Canary
//
//  Created by Nicholas Toumpelis on 03/11/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.7 - 25/01/2009

#import "ORSCanaryUnderlinedButtonCell.h"

@implementation ORSCanaryUnderlinedButtonCell

- (void) mouseEntered:(NSEvent *)theEvent{
	[self setTransparent:NO];
	[self setBordered:YES];
}

- (void) mouseExited:(NSEvent *)theEvent {
	[self setTransparent:YES];
	[self setBordered:NO];
}

- (void) highlight:(BOOL)flag 
		 withFrame:(NSRect)cellFrame 
			inView:(NSView *)controlView {
	return;
}

@end
