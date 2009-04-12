//
//  ORSCanaryLoginController.h
//  Canary
// 
//  Created by Nicholas Toumpelis on 12/04/2009.
//  Copyright 2009 Ocean Road Software. All rights reserved.
//
//  Version 0.7

#import <Cocoa/Cocoa.h>
#import "ORSCanaryController.h"
#import "ORSTwitterEngine.h"
#import "ORSCredentialsManager.h"

@interface ORSCanaryLoginController : NSWindowController {
	ORSCredentialsManager *authenticator;
	NSUserDefaults *defaults;
	ORSTwitterEngine *twitterEngine;
	
	IBOutlet NSComboBox *userIDComboBox;
	IBOutlet NSSecureTextField *passwordSecureTextField;
	IBOutlet NSTextField *authenticatedTextField;
}

- (id) initWithWindow:(NSWindow *)window;
- (void) controlTextDidChange:(NSNotification *)aNotification;
- (IBAction) closeUserManagerSheet:sender;
- (IBAction) login:sender;
- (void) didEndUserManagerSheet:(NSWindow *)sheet
					 returnCode:(int)returnCode
					contextInfo:(void *)contextInfo;
- (void) comboBoxSelectionDidChange:(NSNotification *)notification;
- (void) fillPasswordTextField;

@end
