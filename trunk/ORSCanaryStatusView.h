//
//  ORSCanaryStatusView.h
//  Canary
//
//  Created by Nicholas Toumpelis on 03/11/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.7 - 25/01/2009

#import <Cocoa/Cocoa.h>


@interface ORSCanaryStatusView : NSView {
	BOOL m_isSelected;
}

- (void) setSelected:(BOOL)flag;
- (BOOL) selected;

@end
