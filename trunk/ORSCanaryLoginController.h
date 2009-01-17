//
//  ORSCanaryLoginController.h
//  Canary
// 
//  Created by Nicholas Toumpelis on 06/12/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  O.6 - 6/12/2008

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
