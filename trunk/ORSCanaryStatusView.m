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

- (BOOL) acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

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
		[[NSColor colorWithDeviceRed:.651
							   green:.717
								blue:.919 
							   alpha:1.0] setFill];
		NSRectFill([self bounds]);
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
