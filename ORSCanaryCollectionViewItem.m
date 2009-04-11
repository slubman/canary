//
//  ORSCanaryCollectionViewItem.m
//  Canary
//
//  Created by Nicholas Toumpelis on 03/11/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.7 - 25/01/2009

#import "ORSCanaryCollectionViewItem.h"

@implementation ORSCanaryCollectionViewItem

- (void) setSelected:(BOOL)flag {
	[super setSelected:flag];
	
	// tell the view that it has been selected
	ORSCanaryStatusView *theView = (ORSCanaryStatusView *)[self view];
	if ([theView isKindOfClass:[ORSCanaryStatusView class]]) {
		[theView setSelected:flag];
		[theView setNeedsDisplay:YES];
	}
}

@end
