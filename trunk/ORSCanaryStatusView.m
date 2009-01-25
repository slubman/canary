//
//  ORSCanaryStatusView.m
//  Canary
//
//  Created by Nicholas Toumpelis on 03/11/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.7 - 25/01/2009

#import "ORSCanaryStatusView.h"

@implementation ORSCanaryStatusView

- (NSView *) hitTest:(NSPoint)aPoint {
	NSView *result = [super hitTest:aPoint];
	if (result && !([result isKindOfClass:[NSButton class]] ||
				   ([result isKindOfClass:[NSTextField class]]))) {
		return self;
	} else {
		return result;
	}
}

- (void) drawRect:(NSRect)rect {
	if ([self selected] && [self isKindOfClass:[ORSCanaryStatusView	class]]) {
		NSGradient *gradient = [[NSGradient alloc] 
			initWithStartingColor:[NSColor colorWithDeviceRed:.0
														green:.0 
														 blue:.400 
														alpha:0.3]
					  endingColor:[NSColor colorWithDeviceRed:.0
														green:.0
														 blue:.400 
														alpha:0.1]];
		[gradient drawInRect:[self bounds] angle:90.0];
	}
	[super drawRect:rect];
}

- (void) setSelected:(BOOL)flag {
	m_isSelected = flag;
}

- (BOOL) selected {
	return m_isSelected;
}

@end
