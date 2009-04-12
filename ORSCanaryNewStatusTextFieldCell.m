//
//  CanaryNewStatusTextFieldCell.m
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

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
