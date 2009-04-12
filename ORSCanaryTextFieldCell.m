//
//  ORSCanaryTextFieldCell.m
//  Canary
//
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import "ORSCanaryTextFieldCell.h"

@implementation ORSCanaryTextFieldCell

// Configures the attributed string for the text field cell (for each status)
- (NSAttributedString *) attributedStringValue {
	NSString *initialString = [[[super attributedStringValue] string] 
				stringByReplacingOccurrencesOfString:@"\n"
							   withString:@" "];							   
	NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]
		initWithString:[NSString replaceHTMLEntities:initialString]];
	NSFont *textFont = [NSFont systemFontOfSize:10.2];
	//NSFont *textFont = [NSFont systemFontOfSize:12.2];
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								textFont, NSFontAttributeName, NULL];
	[attString beginEditing];
	[attString addAttributes:attributes 
					   range:NSMakeRange(0, attString.length)];
	/*if ([attString.string rangeOfString:@":)"].location != NSNotFound) {
		NSRange oldRange = [attString.string rangeOfString:@":)"];
		NSRange newRange = NSMakeRange(oldRange.location, 0);
		[attString replaceCharactersInRange:newRange
					   withAttributedString:[attString emoticonStringWithName:@"Smile"]];
	}*/
	[attString highlightElements];
	[attString endEditing];
	[super setAttributedStringValue:attString];
	return attString;
}

@end