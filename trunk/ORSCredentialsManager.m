//
//  ORSCredentialsManager.m
//  Credentials Manager
//
//  Created by Nicholas Toumpelis on 18/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 18/10/2008

#import "ORSCredentialsManager.h"

@implementation ORSCredentialsManager

// Determines whether the specified user has a password in the keychain.
- (BOOL) hasPasswordForUser:(NSString *)username {
	passwordData = nil;
	OSStatus result;
	@synchronized(self) {
		result = SecKeychainFindGenericPassword(NULL, APP_CNAME_LENGTH,
			APP_CNAME, 
			[username lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
			[username cStringUsingEncoding:NSASCIIStringEncoding], 
			&passwordLength, &passwordData, &loginItem);
	}
	lastCheckedUsername = username;
	if (result == 0) {
		return YES;
	} else {
		return NO;
	}
}

// Retrieves the password for the specified user.
- (NSString *) passwordForUser:(NSString *)username {
	if (![username isEqualToString:lastCheckedUsername]) {
		passwordData = nil;
		@synchronized(self) {
			SecKeychainFindGenericPassword(NULL, APP_CNAME_LENGTH, APP_CNAME, 
				[username lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
				[username cStringUsingEncoding:NSASCIIStringEncoding], 
					&passwordLength, &passwordData, &loginItem);
		}
	}
	NSString *password = [[NSString alloc] initWithBytes:passwordData 
												  length:passwordLength
												encoding:NSASCIIStringEncoding];
	return password;
}

// Adds a password to the keychain manager for the specified username.
- (BOOL) addPassword:(NSString *)password
			 forUser:(NSString *)username {
	OSStatus result;
	@synchronized(self) {
		result = SecKeychainAddGenericPassword(NULL, APP_CNAME_LENGTH, 
			APP_CNAME, 
			[username lengthOfBytesUsingEncoding:NSASCIIStringEncoding], 
			[username cStringUsingEncoding:NSASCIIStringEncoding], 
			[password lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
			[password cStringUsingEncoding:NSASCIIStringEncoding], &loginItem);
	}
	if (result == 0) {
		return YES;
	} else {
		return NO;
	}
}

// Sets a password in the keychain manager for the specified username.
- (BOOL) setPassword:(NSString *)password
			 forUser:(NSString *)username {
	[self hasPasswordForUser:username]; // gets loginItem
	OSStatus result;
	@synchronized(self) {
		result = SecKeychainItemModifyAttributesAndData(loginItem, 
			NULL, [password lengthOfBytesUsingEncoding:NSASCIIStringEncoding], 
			[password cStringUsingEncoding:NSASCIIStringEncoding]);
	}
	if (result == 0) {
		return YES;
	} else {
		return NO;
	}
}

// Determines whether the specified user has a twitter password in
// the keychain
- (BOOL) hasStoredTwitterPasswordForUser:(NSString *)username {
	twitterPasswordData = nil;
	OSStatus result;
	@synchronized(self) {
		result = SecKeychainFindInternetPassword(NULL, 11, 
			"twitter.com", 0, NULL, 
			[username lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
			[username cStringUsingEncoding:NSASCIIStringEncoding], 1, "/", 0,
			kSecProtocolTypeHTTPS, kSecAuthenticationTypeDefault, 
			&twitterPasswordLength, &twitterPasswordData, NULL);
	}
	lastCheckedTwitterUsername = username;
	if (result == 0) {
		return YES;
	} else {
		return NO;
	}
}

// Retrieves the current Twitter web password (saved in the keychain).
- (NSString *) storedTwitterPasswordForUser:(NSString *)username {
	if (![username isEqualToString:lastCheckedTwitterUsername]) {
		twitterPasswordData = nil;
		@synchronized(self) {
			SecKeychainFindInternetPassword(NULL, 11, "twitter.com", 0, NULL,
				[username lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
				[username cStringUsingEncoding:NSASCIIStringEncoding], 1, "/", 
				0, kSecProtocolTypeHTTPS, kSecAuthenticationTypeDefault, 
				&twitterPasswordLength, &twitterPasswordData, NULL);
		}
	}
	NSString *password = [[NSString alloc] initWithBytes:twitterPasswordData 
												  length:twitterPasswordLength
												encoding:NSASCIIStringEncoding];
	return password;
}

// Returns the previously retrieved password. 
- (NSString *) fetchedPassword {
	NSString *password = [[NSString alloc] initWithBytes:passwordData 
												  length:passwordLength
												encoding:NSASCIIStringEncoding];
	return password;
}

// Frees the data buffer. 
- (void) freeBuffer {
	@synchronized(self) {
		SecKeychainItemFreeContent(NULL, passwordData);
		SecKeychainItemFreeContent(NULL, twitterPasswordData);
	}
}

@end
