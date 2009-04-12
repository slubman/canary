//
//  ORSCanaryStatusView.m
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import "ORSCanaryStatusView.h"

@implementation ORSCanaryStatusView

- (BOOL) acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

/*- (NSView *) hitTest:(NSPoint)aPoint {
	NSView *result = [super hitTest:aPoint];
	if (result && !([result isKindOfClass:[NSButton class]] ||
				   ([result isKindOfClass:[NSTextField class]]))) {
		return self;
	} else {
		return result;
	}
}*/

- (void) drawRect:(NSRect)rect {
	/*if ([self selected] && [self isKindOfClass:[ORSCanaryStatusView	class]]) {
		[[NSColor colorWithDeviceRed:.651
							   green:.717
								blue:.919 
							   alpha:1.0] setFill];
		NSRectFill([self bounds]);
	} else {*/
		NSGradient *gradient = [[NSGradient alloc] 
			initWithStartingColor:[NSColor colorWithDeviceRed:0.784 
													  green:0.784 
													   blue:0.784 
													  alpha:1.0]
								endingColor:[NSColor colorWithDeviceRed:0.988 
													   green:0.988 
														blue:0.988 
													   alpha:1.0]];
		[gradient drawInRect:[self bounds] angle:90.0];
	//}
	//[super drawRect:rect];
}

- (void) setSelected:(BOOL)flag {
	m_isSelected = flag;
}

- (BOOL) selected {
	return m_isSelected;
}

@end
