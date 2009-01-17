//
//  NSXMLNode+ORSTwitterDMAdditions.m
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 06/11/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 06/11/2008

#import "NSXMLNode+ORSTwitterDMAdditions.h"

@implementation NSXMLNode ( ORSTwitterDMAdditions )

// Returns the first XML for a given XPath
- (NSXMLNode *) firstNodeForXPath:(NSString *)xpathString {
	NSError *error = nil;
	NSArray *nodes = [self nodesForXPath:xpathString error:&error];
	NSXMLNode *firstNode = (NSXMLNode *)[nodes objectAtIndex:0];
	return firstNode;
}

// Direct Message Attributes (different from the status attributes)
 
// Returns the ID of the sender
- (NSString *) senderID {
	return [[self firstNodeForXPath:@".//sender_id"] stringValue];
}
 
// Returns the ID of the recipient
- (NSString *) recipientID {
	return [[self firstNodeForXPath:@".//recipient_id"] stringValue];
}
 
// Returns the screen name of the sender
- (NSString *) senderScreenName {
	return [[self firstNodeForXPath:@".//sender_screen_name"] stringValue];
}

// Returns the screen name of the recipient
- (NSString *) recipientScreenName {
	return [[self firstNodeForXPath:@".//recipient_screen_name"] stringValue];
}

// Returns the name of the sender
- (NSString *) senderName {
	return [[self firstNodeForXPath:@".//sender/name"] stringValue];
}

// Returns the location of the sender
- (NSString *) senderLocation {
	return [[self firstNodeForXPath:@".//sender/location"] stringValue];
}

// Returns the description of the sender
- (NSString *) senderDescription {
	return [[self firstNodeForXPath:@".//sender/description"] stringValue];
}
 
// Returns the profile image URL of the sender
- (NSString *) senderProfileImageURL {
	return [[self firstNodeForXPath:@".//sender/profile_image_url"] 
			stringValue];
}

// Returns the URL of the sender
- (NSString *) senderURL {
	return [[self firstNodeForXPath:@".//sender/url"] stringValue];
}

// Returns the protected status of the sender
- (NSString *) senderProtected {
	return [[self firstNodeForXPath:@".//sender/protected"] stringValue];
}

// Returns the followers count of the sender
- (NSString *) senderFollowersCount {
	return [[self firstNodeForXPath:@".//sender/followers_count"] stringValue];
}
 
// Returns the name of the recipient
- (NSString *) recipientName {
	return [[self firstNodeForXPath:@".//recipient/name"] stringValue];
}

// Returns the location of the recipient
- (NSString *) recipientLocation {
	return [[self firstNodeForXPath:@".//recipient/location"] stringValue];
}

// Returns the description of the recipient
- (NSString *) recipientDescription {
	return [[self firstNodeForXPath:@".//recipient/description"] stringValue];
}
 
// Returns the profile image URL of the recipient
- (NSString *) recipientProfileImageURL {
	return [[self firstNodeForXPath:@".//recipient/profile_image_url"] 
			stringValue];
}

// Returns the URL of the recipient
- (NSString *) recipientURL {
	return [[self firstNodeForXPath:@".//recipient/url"] stringValue];
}

// Returns the protected status of the recipient
- (NSString *) recipientProtected {
	return [[self firstNodeForXPath:@".//recipient/protected"] stringValue];
}

// Returns the followers count of the recipient
- (NSString *) recipientFollowersCount {
	return [[self firstNodeForXPath:@".//recipient/followers_count"] stringValue];
}

@end
