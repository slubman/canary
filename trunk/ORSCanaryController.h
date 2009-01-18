//
//  ORSCanaryController.h
//  Canary
//
//  Created by Nicholas Toumpelis on 20/02/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.2 - 16/04/2008
//  0.3 - 13/09/2008
//  0.4 - 23/09/2008
//  0.5 - 03/10/2008
//  0.6 - 10/11/2008
//  0.7 - 18/01/2008

#import <Cocoa/Cocoa.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <Quartz/Quartz.h>
#import "ORSShortener.h"
#import "ORSCredentialsManager.h"
#import "ORSTwitterEngine.h"
#import "ORSShortenerFactory.h"
#import "ORSUpdateDispatcher.h"
#import "ORSDateDifferenceFormatter.h"
#import "NSXMLNode+ORSTwitterStatusAdditions.h"
#import "NSXMLNode+ORSTwitterDMAdditions.h"
#import "ORSCanaryPreferencesController.h"
#import "ORSCanaryAboutController.h"
#import "ORSTimelineCacheManager.h"
#import <Growl/GrowlApplicationBridge.h>
#import "ORSCanaryLoginController.h"
#import "ORSTwitPicDispatcher.h" 

@interface ORSCanaryController : NSWindowController {
	// Fundamentals
	ORSCredentialsManager *authenticator;
	ORSTwitterEngine *twitterEngine;
	id <ORSShortener> urlShortener;
	ORSUpdateDispatcher *updateDispatcher;
	ORSTimelineCacheManager *cacheManager;
	// Extra Windows
	IBOutlet NSWindow *aboutWindow;
	IBOutlet NSWindow *newUserWindow;
	// Status View Outlets
	IBOutlet NSTextField *statusTextField;
	IBOutlet NSView *statusView;
	IBOutlet NSBox *statusBox;
	IBOutlet NSTextField *dateDifferenceTextField;
	// Main Window Outlets
	IBOutlet NSCollectionView *mainTimelineCollectionView;
	IBOutlet NSScrollView *mainTimelineScrollView;
	IBOutlet NSTextField *newStatusTextField;
	IBOutlet NSButton *tweetButton;
	IBOutlet NSLevelIndicator *charsLeftIndicator;
	IBOutlet NSPopUpButton *timelineButton;
	IBOutlet NSProgressIndicator *indicator;
	IBOutlet NSView *contentView;
	IBOutlet NSCollectionViewItem *mainTimelineCollectionViewItem;
	IBOutlet NSImageView *statusBarImageView;
	IBOutlet NSTextField *statusBarTextField;
	IBOutlet NSButton *statusBarButton;
	// Received DMs Collection View Outletss
	IBOutlet NSCollectionView *receivedDMsCollectionView;
	IBOutlet NSScrollView *receivedDMsScrollView;
	// Sent DMs Collection View Outlets
	IBOutlet NSCollectionView *sentDMsCollectionView;
	IBOutlet NSScrollView *sentDMsScrollView;
	// Received DMs View Outlets
	IBOutlet NSTextField *receivedDMTextField;
	IBOutlet NSView *receivedDMView;
	IBOutlet NSBox *receivedDMBox;
	IBOutlet NSTextField *receivedDMDateDifferenceTextField;
	// Sent DMs View Outlets
	IBOutlet NSTextField *sentDMTextField;
	IBOutlet NSView *sentDMView;
	IBOutlet NSBox *sentDMBox;
	IBOutlet NSTextField *sentDMDateDifferenceTextField;
	// Array Controllers
	IBOutlet NSArrayController *statusArrayController;
	
	NSArray *statuses;
	NSArray *receivedDirectMessages;
	NSArray *sentDirectMessages;
	NSUserDefaults *defaults;
	
	NSTimer *refreshTimer;
	NSTimer *backgroundReceivedDMTimer;
	SecKeychainItemRef loginItem;
	NSString *visibleUserID;
	
	NSString *prevUserID;
	NSString *prevPassword;
	
	NSArray *spokenCommands;
	NSSpeechRecognizer *recognizer;
	NSString *previousTimeline;
	
	BOOL firstBackgroundReceivedDMRetrieval;
	BOOL connectionErrorShown;
	BOOL betweenUsers;
	
	// Selected status update text field
	NSRange realSelectedRange;
}

+ (ORSCanaryController *) sharedController;
+ (id) allocWithZone:(NSZone *)zone;
- (id) copyWithZone:(NSZone *)zone;
- (void) applicationDidFinishLaunching:(NSNotification *)aNotification;
- (IBAction) sendUpdate:sender;
- (IBAction) changeTimeline:sender;
- (void) scrollToTop;
- (void) updateTimer;
- (void) setupReceivedDMTimer;
- (void) updateMaxNoOfShownUpdates;
- (void) updateSelectedURLShortener;
- (void) setStatusesAsynchronously:(NSNotification *)note;
- (void) setUsersAsynchronously:(NSNotification *)note;
- (void) setDMsAsynchronously:(NSNotification *)note;
- (void) addSentStatusAsynchronously:(NSNotification *)note;
- (void) addSentDMsAsynchronously:(NSNotification *)note;
- (void) getFriendsTimeline;
- (void) getUserTimeline;
- (void) getPublicTimeline;
- (void) getReplies;
- (void) getFavorites;
- (void) getReceivedMessages;
- (void) getSentMessages;
- (IBAction) goHome:sender;
- (IBAction) typeUserID:sender;
- (IBAction) dmUserID:sender;
- (IBAction) shortenURL:sender;
- (IBAction) openUserURL:sender; 
- (void) applicationWillTerminate:(NSNotification *)notification;
- (void) saveLastIDs;
- (void) retweetStatus:(NSString *)statusText
		fromUserWithID:(NSString *)userID;
- (IBAction) invokeActionOnUser:sender;
- (void) showUserBlockAlertSheet:(NSString *)userScreenName;
- (void) blockUserAlertDidEnd:(NSAlert *)alert
				   returnCode:(int)returnCode
				  contextInfo:(void *)contextInfo;
- (IBAction) showAboutWindow:sender;
- (IBAction) showPreferencesWindow:sender;
- (IBAction) showLoginWindow:sender;
- (void) showNewUserWindow;
- (IBAction) signupForNewAccountCall:sender;
- (IBAction) loginCall:sender;
- (IBAction) closeCall:sender;
- (IBAction) quitCall:sender;
- (void) didEndNewUserSheet:(NSWindow *)sheet
				 returnCode:(int)returnCode
				contextInfo:(void *)contextInfo;
- (IBAction) sendFeedback:sender;
- (IBAction) changeToReceivedDMs:sender;
- (IBAction) createNewTwitterAccount:sender;
- (IBAction) sendImageToTwitPic:sender;
- (void) executeCallToTwitPicWithFile:(NSString *)filename;
- (void) executeCallToTwitPicWithData:(NSData *)imageData;
- (void) showConnectionFailure:(NSNotification *)note;
- (void) showReceivedResponse:(NSNotification *)note;
- (IBAction) showPictureTaker:sender;

- (IBAction) listen:sender;
- (void) speechRecognizer:(NSSpeechRecognizer *)sender
	  didRecognizeCommand:(id)aCommand;

// Friendship methods
- (void) createFriendshipWithUser:(NSString *)userID;
- (void) destroyFriendshipWithUser:(NSString *)userID;

// Block methods
- (void) blockUserWithID:(NSString *)userID;
- (void) unblockUserWithID:(NSString *)userID;

// Notification methods
- (void) followUserWithID:(NSString *)userID;
- (void) leaveUserWithID:(NSString *)userID;

// Favorite methods
- (void) favoriteStatusWithID:(NSString *)statusID;

// Methods using the main preferences
- (float) timelineRefreshPeriod ;
- (int) maxShownUpdates;
- (int) selectedURLShortener;
- (BOOL) willRetrieveAllUpdates;
- (NSString *) statusIDSinceLastExecution;
- (NSString *) receivedDMIDSinceLastExecution;

// Growl-related methods
- (void) postStatusUpdatesReceived:(NSNotification *)note;
- (void) postRepliesReceived:(NSNotification *)note;
- (void) postDMsReceived:(NSNotification *)note;
- (void) postDMsReceived:(NSNotification *)note
				 afterID:(NSString *)messageID;
- (void) postStatusUpdatesSent:(NSNotification *)note;
- (void) postDMsSent:(NSNotification *)note;

@property(copy) NSArray *statuses;
@property(copy) NSArray *receivedDirectMessages;
@property(copy) NSArray *sentDirectMessages;
@property(copy) NSString *visibleUserID;
@property(copy) NSString *previousTimeline;

@property (retain) ORSCredentialsManager *authenticator;
@property (retain) ORSTwitterEngine *twitterEngine;
@property (retain) id <ORSShortener> urlShortener;
@property (retain) ORSUpdateDispatcher *updateDispatcher;
@property (retain) ORSTimelineCacheManager *cacheManager;
@property (retain) NSWindow *aboutWindow;
@property (retain) NSTextField *statusTextField;
@property (retain) NSView *statusView;
@property (retain) NSBox *statusBox;
@property (retain) NSTextField *dateDifferenceTextField;
@property (retain) NSCollectionView *mainTimelineCollectionView;
@property (retain) NSScrollView *mainTimelineScrollView;
@property (retain) NSTextField *newStatusTextField;
@property (retain) NSButton *tweetButton;
@property (retain) NSLevelIndicator *charsLeftIndicator;
@property (retain) NSPopUpButton *timelineButton;
@property (retain) NSProgressIndicator *indicator;
@property (retain) NSView *contentView;
@property (retain) NSCollectionViewItem *mainTimelineCollectionViewItem;
@property (retain) NSCollectionView *receivedDMsCollectionView;
@property (retain) NSScrollView *receivedDMsScrollView;
@property (retain) NSCollectionView *sentDMsCollectionView;
@property (retain) NSScrollView *sentDMsScrollView;
@property (retain) NSTextField *receivedDMTextField;
@property (retain) NSView *receivedDMView;
@property (retain) NSBox *receivedDMBox;
@property (retain) NSTextField *receivedDMDateDifferenceTextField;
@property (retain) NSTextField *sentDMTextField;
@property (retain) NSView *sentDMView;
@property (retain) NSBox *sentDMBox;
@property (retain) NSTextField *sentDMDateDifferenceTextField;
@property (retain) NSArrayController *statusArrayController;
@property (retain) NSUserDefaults *defaults;
@property (retain) NSTimer *refreshTimer;
@property SecKeychainItemRef loginItem;
@property (retain) NSString *prevUserID;
@property (retain) NSString *prevPassword;
@property (retain) NSArray *spokenCommands;
@property (retain) NSSpeechRecognizer *recognizer;
@property () BOOL firstBackgroundReceivedDMRetrieval;
@property () BOOL betweenUsers;
@property () NSRange realSelectedRange;

@end
