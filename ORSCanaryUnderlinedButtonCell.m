//
//  ORSCanaryUnderlinedButtonCell.m
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

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
