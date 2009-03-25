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
#import "ORSAsyncTwitPicDispatcher.h"
#import "iTunes.h"
#import "ORSFilter.h"
#import "ORSFilterTransformer.h"
#import "ORSFilterArrayTransformer.h"
#import "ORSScreenNameToBoolTransformer.h"

@interface ORSCanaryController : NSWindowController < GrowlApplicationBridgeDelegate > {
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
	IBOutlet NSButton *statusNameButton;
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
	IBOutlet NSCollectionViewItem *statusTimelineCollectionViewItem;
	IBOutlet NSImageView *statusBarImageView;
	IBOutlet NSTextField *statusBarTextField;
	IBOutlet NSButton *statusBarButton;
	IBOutlet NSMenuItem *switchNamesMenuItem;
	// Received DMs Collection View Item Outlets
	IBOutlet NSCollectionViewItem *receivedDMsCollectionViewItem;
	// Sent DMs Collection View Item Outlets
	IBOutlet NSCollectionViewItem *sentDMsCollectionViewItem;
	// Received DMs View Outlets
	IBOutlet NSButton *receivedDMButton;
	IBOutlet NSTextField *receivedDMTextField;
	IBOutlet NSView *receivedDMView;
	IBOutlet NSBox *receivedDMBox;
	IBOutlet NSTextField *receivedDMDateDifferenceTextField;
	// Sent DMs View Outlets
	IBOutlet NSButton *sentDMButton;
	IBOutlet NSTextField *sentDMTextField;
	IBOutlet NSView *sentDMView;
	IBOutlet NSBox *sentDMBox;
	IBOutlet NSTextField *sentDMDateDifferenceTextField;
	// Array Controllers
	IBOutlet NSArrayController *statusArrayController;
	IBOutlet NSArrayController *receivedDMsArrayController;
	IBOutlet NSArrayController *sentDMsArrayController;
	// View Options
	IBOutlet NSBox *viewOptionsBox;
	IBOutlet NSButton *viewOptionsButton;
	IBOutlet NSSegmentedControl *viewOptionsNamesControl;
	IBOutlet NSMenuItem *filterMenuItem;
	IBOutlet NSMenu *availableFiltersMenu;
	IBOutlet NSSegmentedControl *fontSizeControl;
	int namesSelectedSegment;
	IBOutlet NSPopUpButton *filterPopUpButton;
	IBOutlet NSBox *instaFilterBox;
	IBOutlet NSBox *smallInstaFilterBox;
	IBOutlet NSMenu *viewMenu;
	IBOutlet NSMenu* filterMenu;
	IBOutlet NSSearchField *smallInstaFilterSearchField;
	IBOutlet NSSearchField *largeInstaFilterSearchField;
	IBOutlet NSArrayController *filterArrayController;
	
	NSString *previousUpdateText; // The text of the last attempted update
	NSArray *statuses;
	NSArray *receivedDirectMessages;
	NSArray *sentDirectMessages;
	NSUserDefaults *defaults;
	
	NSTimer *refreshTimer;
	NSTimer *backgroundReceivedDMTimer;
	NSTimer *messageDurationTimer;
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
	
	BOOL firstFollowingTimelineRun;
	BOOL showScreenNames;
}

+ (ORSCanaryController *) sharedController;
+ (id) allocWithZone:(NSZone *)zone;
- (id) copyWithZone:(NSZone *)zone;
- (void) applicationDidFinishLaunching:(NSNotification *)aNotification;
- (IBAction) sendUpdate:sender;
- (IBAction) retypePreviousUpdate:sender;
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
- (void) updateNewStatusTextField;
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
- (void) executeAsyncCallToTwitPicWithFile:(NSString *)filename;
- (void) executeAsyncCallToTwitPicWithData:(NSData *)imageData;
- (void) printTwitPicURL:(NSNotification *)note;
- (void) showConnectionFailure:(NSNotification *)note;
- (void) showReceivedResponse:(NSNotification *)note;
- (IBAction) showPictureTaker:sender;
- (void) pictureTakerDidEnd:(IKPictureTaker *)picker
				 returnCode:(NSInteger)code
				contextInfo:(void *)contextInfo;
- (BOOL) applicationShouldHandleReopen:(NSApplication *)theApplication	
					 hasVisibleWindows:(BOOL)flag;
- (void) hideStatusBar;
- (IBAction) insertITunesCurrentTrackFull:sender;
- (IBAction) insertITunesCurrentTrackName:sender;
- (IBAction) insertITunesCurrentTrackAlbum:sender;
- (IBAction) insertITunesCurrentTrackArtist:sender;
- (IBAction) insertITunesCurrentTrackGenre:sender;
- (IBAction) insertITunesCurrentTrackComposer:sender;
- (void) insertStringTokenInNewStatusTextField:(NSString *)stringToken;
- (IBAction) switchBetweenUserNames:sender;
- (void) changeToUsernames;
- (void) changeToScreenNames;
- (void) populateWithStatuses;
- (void) populateWithReceivedDMs;
- (void) populateWithSentDMs;
- (IBAction) switchViewOptions:sender;
- (IBAction) followMacsphere:sender;
- (IBAction) visitCanaryWebsite:sender;
- (IBAction) switchFontSize:sender;
- (void) changeToSmallFont;
- (void) changeToLargeFont;
- (IBAction) performInstaFiltering:sender;

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
- (NSUInteger) maxShownUpdates;
- (int) selectedURLShortener;
- (BOOL) willRetrieveAllUpdates;
- (NSString *) statusIDSinceLastExecution;
- (NSString *) receivedDMIDSinceLastExecution;

- (IBAction) paste:sender;

- (void) setStatuses:(NSArray *)theStatuses;
- (NSArray *) statuses;
- (void) setReceivedDirectMessages:(NSArray *)receivedDMs;
- (NSArray *) receivedDirectMessages;
- (void) setSentDirectMessages:(NSArray *)sentDMs;
- (NSArray *) sentDirectMessages;

@property (copy) NSArray *statuses;
@property (copy) NSArray *receivedDirectMessages;
@property (copy) NSArray *sentDirectMessages;
@property (copy) NSString *visibleUserID;
@property (copy) NSString *previousTimeline;

@property (assign) ORSCredentialsManager *authenticator;
@property (assign) ORSTwitterEngine *twitterEngine;
@property (assign) id <ORSShortener> urlShortener;
@property (assign) ORSUpdateDispatcher *updateDispatcher;
@property (assign) ORSTimelineCacheManager *cacheManager;
@property (assign) NSWindow *aboutWindow;
@property (assign) NSTextField *statusTextField;
@property (assign) NSView *statusView;
@property (assign) NSBox *statusBox;
@property (assign) NSTextField *dateDifferenceTextField;
@property (assign) NSCollectionView *mainTimelineCollectionView;
@property (assign) NSScrollView *mainTimelineScrollView;
@property (assign) NSTextField *newStatusTextField;
@property (assign) NSButton *tweetButton;
@property (assign) NSLevelIndicator *charsLeftIndicator;
@property (assign) NSPopUpButton *timelineButton;
@property (assign) NSProgressIndicator *indicator;
@property (assign) NSView *contentView;
@property (assign) NSCollectionViewItem *statusTimelineCollectionViewItem;
@property (assign) NSTextField *receivedDMTextField;
@property (assign) NSView *receivedDMView;
@property (assign) NSBox *receivedDMBox;
@property (assign) NSTextField *receivedDMDateDifferenceTextField;
@property (assign) NSTextField *sentDMTextField;
@property (assign) NSView *sentDMView;
@property (assign) NSBox *sentDMBox;
@property (assign) NSTextField *sentDMDateDifferenceTextField;
@property (assign) NSArrayController *statusArrayController;
@property (assign) NSUserDefaults *defaults;
@property (assign) NSTimer *refreshTimer;
@property SecKeychainItemRef loginItem;
@property (assign) NSString *prevUserID;
@property (assign) NSString *prevPassword;
@property (assign) NSArray *spokenCommands;
@property (assign) NSSpeechRecognizer *recognizer;
@property () BOOL firstBackgroundReceivedDMRetrieval;
@property () BOOL betweenUsers;
@property () NSRange realSelectedRange;
@property () BOOL showScreenNames;
@property (assign) NSTextField *statusBarTextField;
@property (assign) NSImageView *statusBarImageView;
@property (assign) NSButton *statusBarButton;

@end
