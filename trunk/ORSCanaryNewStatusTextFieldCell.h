//
//  CanaryNewStatusTextFieldCell.h
//  Canary
//
//  Created by Nicholas Toumpelis on 19/04/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.5 - 03/10/2008
//  0.6 - 10/11/2008

#import <Cocoa/Cocoa.h>

@interface ORSCanaryNewStatusTextFieldCell : NSTextFieldCell {
	IBOutlet NSMenuItem *shortenURLMenuItem;
	IBOutlet NSMenuItem *separatorMenuItem;
}

- (NSText *) setUpFieldEditorAttributes:(NSText *)textObj;

@end
