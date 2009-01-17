//
//  ORSCanaryCollectionView.h
//  Canary
//
//  Created by Nicholas Toumpelis on 12/12/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 12/12/2008

#import <Cocoa/Cocoa.h>

@interface ORSCanaryCollectionView : NSCollectionView {

}

- (void) drawRect:(NSRect)rect;
- (BOOL) isOpaque;

@end
