//
//  ORSCanaryCollectionViewItem.m
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

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
