//
//  ORSImageView.m
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import "ORSImageView.h"

@implementation ORSImageView

- (void) drawRect:(NSRect)rect {
	NSRect bounds = [self bounds];
	NSBezierPath* thePath = [NSBezierPath bezierPath];
    [thePath appendBezierPathWithRoundedRect:bounds xRadius:6.0 yRadius:6.0];
	[thePath addClip];
	[super drawRect:bounds];
}

@end
