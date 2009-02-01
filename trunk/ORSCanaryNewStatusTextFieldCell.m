//
//  CanaryNewStatusTextFieldCell.m
//  Canary
//
//  Created by Nicholas Toumpelis on 19/04/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.5 - 03/10/2008

#import "ORSCanaryNewStatusTextFieldCell.h"

@implementation ORSCanaryNewStatusTextFieldCell

- (NSText *) setUpFieldEditorAttributes:(NSText *)textObj {
	// add separator
	if (![[textObj menu] itemWithTitle:@"Shorten URL"]) {
		[[textObj menu] addItem:separatorMenuItem];
		[[textObj menu] addItem:shortenURLMenuItem];
	}
	[self setDrawsBackground:NO];
	return textObj;
}

@end
