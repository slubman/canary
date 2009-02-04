//
//  ORSCanaryCollectionView.m
//  Canary
//
//  Created by Nicholas Toumpelis on 12/12/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 11/12/2008

#import "ORSCanaryCollectionView.h"

@implementation ORSCanaryCollectionView

- (void) drawRect:(NSRect)rect {
	if ([[self content] count] > 0) {
		[super drawRect:rect];
	} else {
		[super drawRect:rect];
		NSRect bounds = [self bounds];
		NSRect newBounds = NSMakeRect(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height-26.0);
		[[NSColor controlColor] set];
		[NSBezierPath fillRect:newBounds];
		
		NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
		[attributes setObject:[NSFont boldSystemFontOfSize:12] 
					   forKey:NSFontAttributeName];
		[attributes setObject:[NSColor grayColor]
					   forKey:NSForegroundColorAttributeName];
		NSString *string = @"This timeline is empty.";
		NSSize strSize = [string sizeWithAttributes:attributes];
		NSPoint strOrigin;
		strOrigin.x = rect.origin.x + (rect.size.width - strSize.width)/2;
		strOrigin.y = rect.origin.y + (rect.size.height - strSize.height)/2;
		[string drawAtPoint:strOrigin withAttributes:attributes];
	}
}

- (BOOL) isOpaque {
	return YES;
}

@end
