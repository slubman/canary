//
//  NSXMLNode+ORSTwitterStatusAdditions.m
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 20/02/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.2 - 16/04/2008
//  0.5 - 03/10/2008
//  0.6 - 02/11/2008

#import "NSXMLNode+ORSTwitterStatusAdditions.h"

@implementation NSXMLNode ( ORSTwitterStatusAdditions )

// Returns the first XML for a given XPath
- (NSXMLNode *) firstNodeForXPath:(NSString *)xpathString {
	NSError *error = nil;
	NSArray *nodes = [self nodesForXPath:xpathString error:&error];
	NSXMLNode *firstNode = (NSXMLNode *)[nodes objectAtIndex:0];
	return firstNode;
}


// Standard Status Attributes (and variations)

// Returns the created_at information for the status
- (NSString *) createdAt {
	return [[self firstNodeForXPath:@".//created_at"] stringValue];
}

// Returns the created_at information for the status as a time
- (NSString *) createdAtAsTimeInterval {
	// get the date sent in the status
	NSDate *statusDate = [NSDate dateWithNaturalLanguageString:[[self 
		firstNodeForXPath:@".//created_at"] stringValue]];
	// get the date as seconds
	NSTimeInterval statusDateAsTimeInterval = [statusDate
						timeIntervalSinceReferenceDate];
	return [NSString stringWithFormat:@"%F", statusDateAsTimeInterval];
}

// Returns the status id
- (NSString *) ID {
	return [[self firstNodeForXPath:@".//id"] stringValue];
}

// Returns the text of the status
- (NSString *) text {
	return [[self firstNodeForXPath:@".//text"] stringValue];
}

// Returns the source of the status
- (NSString *) source {
	return [[self firstNodeForXPath:@".//source"] stringValue];
}

// Returns the truncated value for the status
- (BOOL) truncated {
	if ([[[self firstNodeForXPath:@".//truncated"] stringValue] 
		 isEqualToString:@"true"]) {
		return YES;
	} else {
		return NO;
	}
}

// Returns the in_reply_to value for the status
- (NSString *) inReplyTo {
	return [[self firstNodeForXPath:@".//in_reply_to"] stringValue];
}

// Returns the in_reply_to_user_id for the status
- (NSString *) inReplyToUserID {
	return [[self firstNodeForXPath:@".//in_reply_to_user_id"] stringValue];
}

// Returns the user id for the status
- (NSString *) userID {
	return [[self firstNodeForXPath:@".//user/id"] stringValue];
}

// Returns the username
- (NSString *) userName {
	return [[self firstNodeForXPath:@".//user/name"] stringValue];
}

// Returns the user screen name
- (NSString *) userScreenName {
	return [[self firstNodeForXPath:@".//user/screen_name"] stringValue];
}

// Returns the user location
- (NSString *) userLocation {
	return [[self firstNodeForXPath:@".//user/location"] stringValue];
}

// Returns the user description
- (NSString *) userDescription {
	return [[self firstNodeForXPath:@".//user/description"] stringValue];
}

// Returns the user profile image URL
- (NSString *) userProfileImageURL {
	return [[self firstNodeForXPath:@".//user/profile_image_url"] stringValue];
}

// Returns the user URL
- (NSString *) userURL {
	return [[self firstNodeForXPath:@".//user/url"] stringValue];
}

// Returns the user protected status
- (BOOL) userProtected {
	if ([[[self firstNodeForXPath:@".//user/protected"] stringValue] 
		 isEqualToString:@"true"]) {
		return YES;
	} else {
		return NO;
	}
}

// Returns the count of the user's followers as a string
- (NSString *) userFollowersCount {
	return [[self firstNodeForXPath:@".//user/followers_count"] stringValue];
}

// Returns the text of the status as rich text
- (NSAttributedString *) richText {
	NSAttributedString *attString = [[NSAttributedString alloc]
									 initWithString:[self text]];
	return attString;
}

// Returns whether the message is protected
- (BOOL) protectedStatus {
	if ([[[self firstNodeForXPath:@".//protected"] stringValue] 
		 isEqualToString:@"true"]) {
		return YES;
	} else {
		return NO;
	}
}

@end
