//
//  ORSCanaryController.m
//  Canary
//
//  Created by Nicholas Toumpelis on 20/02/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.2 - 16/04/2008
//  0.3 - 19/09/2008
//  0.4 - 23/09/2008
//  0.5 - 03/10/2008

#import "ORSCanaryController.h"

@implementation ORSCanaryController

@synthesize statuses, receivedDirectMessages, sentDirectMessages, visibleUserID,
			previousTimeline, authenticator, twitterEngine, urlShortener, 
			updateDispatcher, cacheManager, aboutWindow, statusTextField, 
			statusView, statusBox, dateDifferenceTextField, indicator,
			mainTimelineCollectionView, mainTimelineScrollView, tweetButton,
			newStatusTextField, charsLeftIndicator, timelineButton, sentDMBox,
			contentView, mainTimelineCollectionViewItem, sentDMTextField,
			receivedDMsCollectionView, receivedDMsScrollView, sentDMView,
			sentDMsCollectionView, sentDMsScrollView, receivedDMTextField, 
			receivedDMView, receivedDMBox, receivedDMDateDifferenceTextField,
			sentDMDateDifferenceTextField, statusArrayController, defaults, 
			refreshTimer, loginItem, prevUserID, prevPassword, spokenCommands,
			recognizer, firstBackgroundReceivedDMRetrieval, betweenUsers,
			realSelectedRange;

static ORSCanaryController *sharedCanaryController = nil;

// sharedController
+ (ORSCanaryController *) sharedController {
    @synchronized(self) {
        if (sharedCanaryController == nil) {
            [[self alloc] init];
        }
    }
    return sharedCanaryController;
}

// allocWithZone
+ (id) allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedCanaryController == nil) {
			return [super allocWithZone:zone];
        }
    }
	return sharedCanaryController;
}

// copyWihtZone
- (id) copyWithZone:(NSZone *)zone {
	return self;
}

// Initialize
+ (void) initialize {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *appDefaults = [NSMutableDictionary dictionary];
	[appDefaults setObject:[NSNumber numberWithFloat:0.0]
					forKey:@"CanaryWindowX"];
	[appDefaults setObject:[NSNumber numberWithFloat:0.0]
					forKey:@"CanaryWindowY"];
	[appDefaults setObject:[NSNumber numberWithFloat:339.0]
					forKey:@"CanaryWindowWidth"];
	[appDefaults setObject:[NSNumber numberWithFloat:530.0]
					forKey:@"CanaryWindowHeight"];
	[appDefaults setObject:@"Every minute" forKey:@"CanaryRefreshPeriod"];
	[appDefaults setObject:@"250" forKey:@"CanaryMaxShownUpdates"];
	[appDefaults setObject:@"Cli.gs" forKey:@"CanarySelectedURLShortener"];
	[appDefaults setObject:[NSNumber numberWithBool:NO]
									forKey:@"CanaryWillRetrieveAllUpdates"];
	[appDefaults setObject:[NSNumber numberWithBool:YES]
					forKey:@"CanaryFirstTimeUser"];
	[defaults registerDefaults:appDefaults];
}

// Init
- (id) init {
	Class canaryControllerClass = [self class];
	@synchronized(canaryControllerClass) {
		if (sharedCanaryController == nil) {
			if (self = [super init]) {
				sharedCanaryController = self;
				[GrowlApplicationBridge setGrowlDelegate:@""];
				connectionErrorShown = NO;
		
				defaults = [NSUserDefaults standardUserDefaults];
				authenticator = [[ORSCredentialsManager alloc] init];
				cacheManager = [[ORSTimelineCacheManager alloc] init];
		
				// NotificationCenter stuff -- need to determine a way to find
				// which method to call
				NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
				[nc addObserver:self
					   selector:@selector(setStatusesAsynchronously:)
						   name:@"OTEStatusesDidFinishLoading"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(setUsersAsynchronously:)
						   name:@"OTEUsersDidFinishLoading"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(setDMsAsynchronously:)
						   name:@"OTEDMsDidFinishLoading"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(addSentStatusAsynchronously:)
						   name:@"OTEStatusDidFinishLoading"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(addSentDMsAsynchronously:)
						   name:@"OTEDMDidFinishSending"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(showConnectionFailure:)
						   name:@"OTEConnectionFailure"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(showReceivedResponse:)
						   name:@"OTEReceivedResponse"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(textDidEndEditing:)
						   name:@"NSTextDidEndEditingNotification"
						 object:nil];
		
				spokenCommands = [NSArray 
					arrayWithObjects:@"Tweet", @"Home", @"Refresh", nil];
		
				previousTimeline = @"";
				
				[self updateMaxNoOfShownUpdates];
		
				if ([defaults stringForKey:@"CanaryCurrentUserID"]) {
					NSString *sessionUserID = 
						[defaults stringForKey:@"CanaryCurrentUserID"];
					NSString *sessionPassword = NULL;
					if ([authenticator hasPasswordForUser:sessionUserID]) {
						sessionPassword = [authenticator 
										   passwordForUser:sessionUserID];
						twitterEngine = [[ORSTwitterEngine alloc] 
							initSynchronously:NO
								withUserID:sessionUserID 
									andPassword:sessionPassword];
						[self setVisibleUserID:[NSString 
								stringWithFormat:@"  %@",
									twitterEngine.sessionUserID]];
					} else {
						twitterEngine = [[ORSTwitterEngine alloc] 
							initSynchronously:NO 
								withUserID:sessionUserID 
									andPassword:NULL];
					}
				} else {
					loginItem = nil;
					twitterEngine = [[ORSTwitterEngine alloc] 
						initSynchronously:NO 
							withUserID:NULL 
								andPassword:NULL];
					[self setVisibleUserID:@"  Click here to login"];
				}
				[self updateSelectedURLShortener];
		
				updateDispatcher = [[ORSUpdateDispatcher alloc] 
										initWithEngine:twitterEngine];
		
				if ([self willRetrieveAllUpdates]) {
					cacheManager.firstFollowingCall = NO;
					cacheManager.lastFollowingStatusID = 
						[self statusIDSinceLastExecution];
				}
		
				firstBackgroundReceivedDMRetrieval = YES;
		
				NSString *lastExecutionID = [self 
								receivedDMIDSinceLastExecution];
				cacheManager.lastReceivedMessageID = lastExecutionID;
		
				betweenUsers = NO;
			}
		}
	}
	return sharedCanaryController;
}

// Awake From Nib
- (void) awakeFromNib {
	if ([defaults floatForKey:@"CanaryWindowX"]) {
		NSRect newFrame = NSMakeRect([defaults floatForKey:@"CanaryWindowX"],
							[defaults floatForKey:@"CanaryWindowY"],
							[defaults floatForKey:@"CanaryWindowWidth"],
							[defaults floatForKey:@"CanaryWindowHeight"]);
		[[self window] setFrame:newFrame display:YES];
	}
	
	ORSDateDifferenceFormatter *dateDiffFormatter = 
					[[ORSDateDifferenceFormatter alloc] init];
	
	[[dateDifferenceTextField cell] setFormatter:dateDiffFormatter];
	[[receivedDMDateDifferenceTextField cell] setFormatter:dateDiffFormatter];
	[[sentDMDateDifferenceTextField cell] setFormatter:dateDiffFormatter];
}

// Delegate: calls all the necessary methods when the app starts
- (void) applicationDidFinishLaunching:(NSNotification *)aNotification {
	if (![defaults objectForKey:@"CanaryFirstTimeUser"] ||
		[[defaults objectForKey:@"CanaryFirstTimeUser"] isEqualToNumber:[NSNumber numberWithBool:YES]] || ![twitterEngine sessionUserID]) {
		[self showNewUserWindow];
		[defaults setObject:[NSNumber numberWithBool:NO]
					 forKey:@"CanaryFirstTimeUser"];
	}
	[self changeTimeline:self];
}

// Delegate: closes the application when the window is closed
- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *) 
sender {
	return [defaults boolForKey:@"CanaryWillExitOnWindowClose"];
}

// Action: allows the user to send an update to Twitter
- (IBAction) sendUpdate:sender {
	if ([twitterEngine sessionUserID]) {
		// Counter readjustment
		[charsLeftIndicator setIntValue:0];
		[charsLeftIndicator setMaxValue:140];
		[charsLeftIndicator setCriticalValue:140];
		[charsLeftIndicator setWarningValue:125];
		
		[updateDispatcher addMessage:[newStatusTextField stringValue]];
		[tweetButton setTitle:@"Tweet!"];
		
		[charsLeftIndicator setHidden:YES];
		[indicator startAnimation:self];
	}
}

// Action: allows the user to change the active timeline
- (IBAction) changeTimeline:sender {
	if (([[timelineButton titleOfSelectedItem] isEqualToString:[self 
			previousTimeline]]) && [sender isEqualTo:timelineButton]) {
		return;
	}
	if ([[timelineButton titleOfSelectedItem] isEqualToString:@"Friends"]) {
		if ([sender isEqualTo:timelineButton] && 
				[cacheManager.followingStatusCache count] > 0) {
			[sentDMsScrollView setHidden:YES];
			[receivedDMsScrollView setHidden:YES];
			[mainTimelineScrollView setHidden:NO];
			[self setStatuses:cacheManager.followingStatusCache];
		}
		[self getFriendsTimeline];
	} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Archive"]) {
		if ([sender isEqualTo:timelineButton] && 
				[cacheManager.archiveStatusCache count] > 0) {
			[sentDMsScrollView setHidden:YES];
			[receivedDMsScrollView setHidden:YES];
			[mainTimelineScrollView setHidden:NO];
			[self setStatuses:cacheManager.archiveStatusCache];
		}
		[self getUserTimeline];
	} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Public"]) {
		if ([sender isEqualTo:timelineButton] && 
				[cacheManager.publicStatusCache count] > 0) {
			[sentDMsScrollView setHidden:YES];
			[receivedDMsScrollView setHidden:YES];
			[mainTimelineScrollView setHidden:NO];
			[self setStatuses:cacheManager.publicStatusCache];
		}
		[self getPublicTimeline];
	} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Replies"]) {
		if ([sender isEqualTo:timelineButton] && 
				[cacheManager.repliesStatusCache count] > 0) {
			[sentDMsScrollView setHidden:YES];
			[receivedDMsScrollView setHidden:YES];
			[mainTimelineScrollView setHidden:NO];
			[self setStatuses:cacheManager.repliesStatusCache];
		}
		[self getReplies];
	} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Favorites"]) {
		if ([sender isEqualTo:timelineButton] && 
				[cacheManager.favoritesStatusCache count] > 0) {
			[sentDMsScrollView setHidden:YES];
			[receivedDMsScrollView setHidden:YES];
			[mainTimelineScrollView setHidden:NO];
			[self setStatuses:cacheManager.favoritesStatusCache];
		}
		[self getFavorites];
	} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Received messages"]) {
		if ([sender isEqualTo:timelineButton] && 
				[[cacheManager receivedMessagesCache] count] > 0) {
			[mainTimelineScrollView setHidden:YES];
			[sentDMsScrollView setHidden:YES];
			[receivedDMsScrollView setHidden:NO];
			[self setReceivedDirectMessages:[cacheManager 
											 receivedMessagesCache]];
		}
		[self getReceivedMessages];
		[statusBarTextField setHidden:YES];
		[statusBarImageView setHidden:YES];
		[statusBarButton setEnabled:NO];
	} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Sent messages"]) {
		if ([sender isEqualTo:timelineButton] && 
				[cacheManager.sentMessagesCache count] > 0) {
			[mainTimelineScrollView setHidden:YES];
			[receivedDMsScrollView setHidden:YES];
			[sentDMsScrollView setHidden:NO];
			[self setSentDirectMessages:cacheManager.sentMessagesCache];
		}
		[self getSentMessages];
	}
	[self updateTimer];
}

// Scrolls timeline to the top
- (void) scrollToTop {
    NSPoint newScrollOrigin;
	NSScrollView *scrollView;
	if ([[timelineButton titleOfSelectedItem] 
		 isEqualToString:@"Received messages"]) {
		scrollView = receivedDMsScrollView;
	} else if ([[timelineButton titleOfSelectedItem] 
		 isEqualToString:@"Sent messages"]) {
		scrollView = sentDMsScrollView;
	} else {
		scrollView = mainTimelineScrollView;
	}
    if ([[scrollView documentView] isFlipped]) {
        newScrollOrigin = NSMakePoint(0.0,0.0);
    } else {
        newScrollOrigin = NSMakePoint(0.0,
			NSMaxY([[scrollView documentView] frame]) - NSHeight([[scrollView 
					contentView] bounds]));
    }
    [[scrollView documentView] scrollPoint:newScrollOrigin];
}

// Updates the current timer (according to the user's settings)
- (void) updateTimer {
	float refreshPeriod = [self timelineRefreshPeriod];
	[refreshTimer invalidate];
	refreshTimer = nil;
	if (![backgroundReceivedDMTimer isValid])
		[self setupReceivedDMTimer];
	if (refreshPeriod > -1.0) {
		if ([[timelineButton titleOfSelectedItem] isEqualToString:@"Friends"]) {
			refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshPeriod 
				target:self selector:@selector(getFriendsTimeline) userInfo:nil 
														   repeats:YES];
		} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Archive"]) {
			refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshPeriod
					target:self selector:@selector(getUserTimeline) userInfo:nil 
														   repeats:YES];
		} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Public"]) {
			refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshPeriod
				target:self selector:@selector(getPublicTimeline) userInfo:nil
														   repeats:YES];
		} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Replies"]) {
			refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshPeriod
					target:self selector:@selector(getReplies) userInfo:nil 
														   repeats:YES];
		} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Favorites"]) {
			refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshPeriod
				target:self selector:@selector(getFavorites) userInfo:nil 
														   repeats:YES];
		} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Received messages"]) {
			refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshPeriod
				target:self selector:@selector(getReceivedMessages) userInfo:nil 
														   repeats:YES];
		} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Sent messages"]) {
			refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshPeriod
				target:self selector:@selector(getSentMessages) userInfo:nil 
														   repeats:YES];
		}
	}
}

// Sets up the timer for background tracking of direct messages
- (void) setupReceivedDMTimer {
	[backgroundReceivedDMTimer invalidate];
	backgroundReceivedDMTimer = [NSTimer scheduledTimerWithTimeInterval:300.0
		target:self selector:@selector(getReceivedMessages) 
								userInfo:nil repeats:YES];
	[self performSelector:@selector(getReceivedMessages)
			   withObject:nil
			   afterDelay:3.0];
}

// Updates the maximum number of shown updates (according to the user's 
// settings)
- (void) updateMaxNoOfShownUpdates {
	int maxNoOfShownUpdates = [self maxShownUpdates];
	[mainTimelineCollectionView setMaxNumberOfRows:maxNoOfShownUpdates];
	[receivedDMsCollectionView setMaxNumberOfRows:maxNoOfShownUpdates];
	[sentDMsCollectionView setMaxNumberOfRows:maxNoOfShownUpdates];
}

// Updates the selected URL shortener (according to the user's settings)
- (void) updateSelectedURLShortener {
	urlShortener = [ORSShortenerFactory getShortener:[self
													  selectedURLShortener]];
}

// Sets the statuses asynchronously
- (void) setStatusesAsynchronously:(NSNotification *)note {	
	if (connectionErrorShown) {
		[statusBarTextField setHidden:YES];
		[statusBarImageView setHidden:YES];
		[statusBarButton setEnabled:NO];
		connectionErrorShown = NO;
	}
	
	NSPoint oldScrollOrigin = [[mainTimelineScrollView contentView] 
							   bounds].origin;
	if ([[timelineButton titleOfSelectedItem] isEqualToString:@"Friends"]) {
		[self setStatuses:[cacheManager 
				setStatusesForTimelineCache:ORSFollowingTimelineCacheType
										   withNotification:note]];
		[self postStatusUpdatesReceived:note];
	} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Archive"]) {
		[self setStatuses:[cacheManager 
			setStatusesForTimelineCache:ORSArchiveTimelineCacheType
						 withNotification:note]];
	} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Public"]) {
		[self setStatuses:[cacheManager 
				setStatusesForTimelineCache:ORSPublicTimelineCacheType
							 withNotification:note]];
		[self postStatusUpdatesReceived:note];
	} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Replies"]) {
		[self setStatuses:[cacheManager 
				setStatusesForTimelineCache:ORSRepliesTimelineCacheType
											withNotification:note]];
		[self postRepliesReceived:note];
	} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Favorites"]) {
		[self setStatuses:[cacheManager 
			setStatusesForTimelineCache:ORSFavoritesTimelineCacheType 
						   withNotification:note]];
	}
	[indicator stopAnimation:self];
	[[mainTimelineScrollView documentView] scrollPoint:oldScrollOrigin];
	[charsLeftIndicator setHidden:NO];
	[receivedDMsScrollView setHidden:YES];
	[sentDMsScrollView setHidden:YES];
	[mainTimelineScrollView setHidden:NO];
	
	if (![[timelineButton titleOfSelectedItem] isEqualToString:[self
														previousTimeline]]) {
		[self scrollToTop];
	}
	previousTimeline = [timelineButton titleOfSelectedItem];
	
	if ([[newStatusTextField stringValue] isEqualToString:@"d "]) {
		[newStatusTextField setStringValue:@""];
	}
}

// Sets the users asynchronously
- (void) setUsersAsynchronously:(NSNotification *)note {
	// Not implemented yet
	if (connectionErrorShown) {
		[statusBarTextField setHidden:YES];
		[statusBarImageView setHidden:YES];
		[statusBarButton setEnabled:NO];
		connectionErrorShown = NO;
	}
	
	NSPoint oldScrollOrigin = [[mainTimelineScrollView contentView] 
							   bounds].origin;
	[indicator stopAnimation:self];
	[charsLeftIndicator setHidden:NO];
	[[mainTimelineScrollView documentView] scrollPoint:oldScrollOrigin];
}

// Sets the DMs asynchronously
- (void) setDMsAsynchronously:(NSNotification *)note {
	if (connectionErrorShown) {
		[statusBarTextField setHidden:YES];
		[statusBarImageView setHidden:YES];
		[statusBarButton setEnabled:NO];
		connectionErrorShown = NO;
	}
	
	NSPoint oldScrollOrigin;
	if ([[timelineButton titleOfSelectedItem] 
			isEqualToString:@"Received messages"]) {
		oldScrollOrigin = [[receivedDMsScrollView contentView] 
								   bounds].origin;
		[self setReceivedDirectMessages:[cacheManager 
			setStatusesForTimelineCache:ORSReceivedMessagesTimelineCacheType 
										 withNotification:note]];
		[self postDMsReceived:note];
		[mainTimelineScrollView setHidden:YES];
		[sentDMsScrollView setHidden:YES];
		[receivedDMsScrollView setHidden:NO];
		[[receivedDMsScrollView documentView] scrollPoint:oldScrollOrigin];
		
		if (![[timelineButton titleOfSelectedItem] isEqualToString:[self
													previousTimeline]]) {
			[self scrollToTop];
		}
		previousTimeline = [timelineButton titleOfSelectedItem];
		if ([[newStatusTextField stringValue] length] == 0) {
			[newStatusTextField setStringValue:@"d "];
		}
	} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Sent messages"]) {
		oldScrollOrigin = [[sentDMsScrollView contentView] 
						   bounds].origin;
		[self setSentDirectMessages:[cacheManager
		setStatusesForTimelineCache:ORSSentMessagesTimelineCacheType
									 withNotification:note]];	
		[mainTimelineScrollView setHidden:YES];
		[receivedDMsScrollView setHidden:YES];
		[sentDMsScrollView setHidden:NO];
		[[sentDMsScrollView documentView] scrollPoint:oldScrollOrigin];
		
		if (![[timelineButton titleOfSelectedItem] isEqualToString:[self
													previousTimeline]]) {
			[self scrollToTop];
		}
		previousTimeline = [timelineButton titleOfSelectedItem];
		if ([[newStatusTextField stringValue] length] == 0) {
			[newStatusTextField setStringValue:@"d "];
		}
	} else {
		if ([(NSArray *)[note object] count] > 0) {
			if (firstBackgroundReceivedDMRetrieval) {
				NSString *lastExecutionID = [self 
											 receivedDMIDSinceLastExecution];
				NSString *currentExecutionID = [[(NSArray *)[note 
											object] objectAtIndex:0] ID];
				//NSLog(@"lastExecutionID: %@", lastExecutionID);
				//NSLog(@"currentExecutionID: %@", currentExecutionID);
				if ([lastExecutionID intValue] < [currentExecutionID 
													 intValue]) {
					[statusBarTextField 
						setStringValue:@"New direct message received"];
					[statusBarTextField setHidden:NO];
					[statusBarImageView setImage:[NSImage imageNamed:@"email"]];
					[statusBarImageView setHidden:NO];
					[statusBarButton setEnabled:YES];
					[cacheManager setStatusesForTimelineCache:
						ORSReceivedMessagesTimelineCacheType 
											 withNotification:note];
					[self postDMsReceived:note
								  afterID:lastExecutionID];
				}
				firstBackgroundReceivedDMRetrieval = NO;
			} else {
				NSString *lastExecutionID = [self 
											 receivedDMIDSinceLastExecution];
				NSString *currentExecutionID = [[(NSArray *)[note 
									object] objectAtIndex:0] ID];
				//NSLog(@"lastExecutionID: %@", lastExecutionID);
				//NSLog(@"currentExecutionID: %@", currentExecutionID);
				if ([lastExecutionID intValue] < [currentExecutionID 
												  intValue]) {
					[statusBarTextField 
						setStringValue:@"New direct message received"];
					[statusBarTextField setHidden:NO];
					[statusBarImageView setImage:[NSImage imageNamed:@"email"]];
					[statusBarImageView setHidden:NO];
					[statusBarButton setEnabled:YES];
					[cacheManager setStatusesForTimelineCache:
						ORSReceivedMessagesTimelineCacheType 
										 withNotification:note];
					[self postDMsReceived:note];
				}
			}
			connectionErrorShown = NO;
		}
	}
	[indicator stopAnimation:self];
	[charsLeftIndicator setHidden:NO];
}

// Sets the sent status asynchronously
- (void) addSentStatusAsynchronously:(NSNotification *)note {
	[newStatusTextField setStringValue:@""];
	
	if (connectionErrorShown) {
		[statusBarTextField setHidden:YES];
		[statusBarImageView setHidden:YES];
		[statusBarButton setEnabled:NO];
		connectionErrorShown = NO;
	}
	
	if ([[timelineButton titleOfSelectedItem] isEqualToString:@"Friends"]
		|| [[timelineButton titleOfSelectedItem] isEqualToString:@"Archive"] ) {
		NSPoint oldScrollOrigin = [[mainTimelineScrollView contentView] 
								   bounds].origin;
		NSMutableArray *cache = [NSMutableArray arrayWithArray:[self statuses]];
		[cache insertObject:[note object] atIndex:0];
		[self setStatuses:cache];
		[[mainTimelineScrollView documentView] scrollPoint:oldScrollOrigin];
	}
	
	NSString *msg = [NSString stringWithFormat:@"Update sent"];
	[statusBarTextField setStringValue:msg];
	[statusBarImageView setImage:[NSImage imageNamed:@"comment"]];
	[statusBarTextField setHidden:NO];
	[statusBarImageView setHidden:NO];
	
	[self postStatusUpdatesSent:note];
	[indicator stopAnimation:self];
	[charsLeftIndicator setHidden:NO];
}

// Sets the sent direct messages asynchronously
- (void) addSentDMsAsynchronously:(NSNotification *)note {
	[newStatusTextField setStringValue:@""];
	
	if (connectionErrorShown) {
		[statusBarTextField setHidden:YES];
		[statusBarImageView setHidden:YES];
		[statusBarButton setEnabled:NO];
		connectionErrorShown = NO;
	}
	
	if ([[timelineButton titleOfSelectedItem] 
			isEqualToString:@"Sent Messages"]) {		
		NSPoint oldScrollOrigin = [[sentDMsScrollView contentView] 
								   bounds].origin;
		NSMutableArray *cache = [NSMutableArray 
							 arrayWithArray:[self sentDirectMessages]];
	
		[cache insertObject:[note object] atIndex:0];
		[self setSentDirectMessages:cache];
		[mainTimelineScrollView setHidden:YES];
		[receivedDMsScrollView setHidden:YES];
		[sentDMsScrollView setHidden:NO];
		[[sentDMsScrollView documentView] scrollPoint:oldScrollOrigin];
		[indicator stopAnimation:self];
		[charsLeftIndicator setHidden:NO];
	}
	[self postDMsSent:note];
	[indicator stopAnimation:self];
	[charsLeftIndicator setHidden:NO];
	
	NSString *msg = [NSString stringWithFormat:@"Direct message sent"];
	[statusBarTextField setStringValue:msg];
	[statusBarImageView setImage:[NSImage imageNamed:@"email"]];
	[statusBarTextField setHidden:NO];
	[statusBarImageView setHidden:NO];
}

// Gets the friends timeline
- (void) getFriendsTimeline {
	if ([twitterEngine sessionUserID]) {
		[charsLeftIndicator setHidden:YES];
		[indicator startAnimation:self];
		if (cacheManager.firstFollowingCall) {
			[twitterEngine getFriendsTimeline];
		} else {
			[twitterEngine 
			 getFriendsTimelineSinceStatus:cacheManager.lastFollowingStatusID];
		}
	}
}

// Gets the user timeline
- (void) getUserTimeline {
	if ([twitterEngine sessionUserID]) {
		[charsLeftIndicator setHidden:YES];
		[indicator startAnimation:self];
		if (cacheManager.firstArchiveCall) {
			[twitterEngine getUserTimelineForUser:[twitterEngine sessionUserID]];
		} else {
			[twitterEngine 
			 getUserTimelineSinceStatus:cacheManager.lastArchiveStatusID];
		}
	}
}

// Gets the public timeline
- (void) getPublicTimeline {
	if ([twitterEngine sessionUserID]) {
		[charsLeftIndicator setHidden:YES];
		[indicator startAnimation:self];
		if (cacheManager.firstPublicCall) {
			[twitterEngine getPublicTimeline];
		} else {
			[twitterEngine 
			 getPublicTimelineSinceStatus:cacheManager.lastPublicStatusID];
		}
	}
}

// Gets the replies
- (void) getReplies {
	if ([twitterEngine sessionUserID]) {
		[charsLeftIndicator setHidden:YES];
		[indicator startAnimation:self];
		if (cacheManager.firstRepliesCall) {
			[twitterEngine getReplies];
		} else {
			[twitterEngine 
			 getRepliesSinceStatus:cacheManager.lastReplyStatusID];
		}
	}
}

// Gets the favorites
- (void) getFavorites {
	if ([twitterEngine sessionUserID]) {
		[charsLeftIndicator setHidden:YES];
		[indicator startAnimation:self];
		if (cacheManager.firstFavoriteCall) {
			[twitterEngine getFavoritesForUser:[twitterEngine sessionUserID]];
		} else {
			[twitterEngine 
			 getFavoritesSinceStatus:cacheManager.lastFavoriteStatusID];
		}
	}
}

// Gets the received messages
- (void) getReceivedMessages {
	if ([twitterEngine sessionUserID]) {
		[charsLeftIndicator setHidden:YES];
		[indicator startAnimation:self];
		if (cacheManager.firstReceivedMessagesCall) {
			[twitterEngine getReceivedDMs];
		} else {
			[twitterEngine 
			 getReceivedDMsSinceDM:cacheManager.lastReceivedMessageID];
		}
	}
}

// Gets the sent messages
- (void) getSentMessages {
	if ([twitterEngine sessionUserID]) {
		[charsLeftIndicator setHidden:YES];
		[indicator startAnimation:self];
		if (cacheManager.firstSentMessagesCall) {
			[twitterEngine getSentDMs];
		} else {
			[twitterEngine getSentDMsSinceDM:cacheManager.lastSentMessageID];
		}
	}
}

// Action: opens the user's home page (if they are logged in)
- (IBAction) goHome:sender {
	NSURL *homeURL = [[NSURL alloc] initWithString:@"http://twitter.com/home"];
	[[NSWorkspace sharedWorkspace] openURL:homeURL];
}

// Action: Called when the user wants to autotype the user id to reply to.
- (IBAction) typeUserID:sender {
	NSTextView *fieldEditor = (NSTextView *)[[self window] fieldEditor:YES 
										   forObject:newStatusTextField];
	[[self window] makeFirstResponder:newStatusTextField];
	[[self window] makeFirstResponder:fieldEditor];
	
	NSString *username = [NSString stringWithFormat:@"@%@ ", sender];
	
	[fieldEditor setSelectedRange:self.realSelectedRange];
	[fieldEditor insertText:username];
	
	[fieldEditor setNeedsDisplay:YES];
	[fieldEditor didChangeText];
}

// Action: Called when the user wants to autotype "d" + user id to send 
// message to.
- (IBAction) dmUserID:sender {
	[newStatusTextField setStringValue:@""];
	NSTextView *fieldEditor = (NSTextView *)[[self window] fieldEditor:YES 
											forObject:newStatusTextField];
	[[self window] makeFirstResponder:newStatusTextField];
	[[self window] makeFirstResponder:fieldEditor];
	
	NSString *username = username = [NSString stringWithFormat:@"d %@ ", 
									 sender];
	
	[fieldEditor setSelectedRange:self.realSelectedRange];
	[fieldEditor insertText:username];
	
	[fieldEditor setNeedsDisplay:YES];
	[fieldEditor didChangeText];
}

// Action: This shortens the given URL using a shortener service.
- (IBAction) shortenURL:sender {
	NSText *editor = [newStatusTextField currentEditor];
	NSRange selectedRange = [(NSTextView *)editor selectedRange];
	if ([[[(NSTextView *)editor attributedSubstringFromRange:selectedRange]
		  string] hasPrefix:@"http://"]) {
		[editor copy:self];
		[editor replaceCharactersInRange:[editor selectedRange] 
			withString:[urlShortener generateURLFrom:[[editor string] 
								substringWithRange:[editor selectedRange]]]];
		[self controlTextDidChange:nil];
	}
}

// Action: This is called whenever the user wishes to open a user url.
- (IBAction) openUserURL:sender {
	NSURL *userURL = [[NSURL alloc] initWithString:(NSString *)sender];
	[[NSWorkspace sharedWorkspace] openURL:userURL];
}

// Delegate: This is called whenever the application terminates
- (void) applicationWillTerminate:(NSNotification *)notification {
	[defaults setFloat:[[self window] frame].origin.x
				forKey:@"CanaryWindowX"];
	[defaults setFloat:[[self window] frame].origin.y
				forKey:@"CanaryWindowY"];
	[defaults setFloat:[[self window] frame].size.width
				forKey:@"CanaryWindowWidth"];
	[defaults setFloat:[[self window] frame].size.height
				forKey:@"CanaryWindowHeight"];
	[self saveLastIDs];
	[twitterEngine endSession];
}

// Saves the last IDs in the user preferences when called
- (void) saveLastIDs {
	NSMutableDictionary *followingStatusIDs, *lastReceivedDMIDs;
	if (cacheManager.lastFollowingStatusID != NULL &&
		cacheManager.lastFollowingStatusID != @"" &&
		cacheManager.lastFollowingStatusID != nil) {
		if (followingStatusIDs = [NSMutableDictionary dictionaryWithDictionary:
			[defaults dictionaryForKey:@"CanaryLastFollowingStatusID"]]) {
			if (twitterEngine.sessionUserID != nil) {
				[followingStatusIDs setValue:cacheManager.lastFollowingStatusID 
								  forKey:[twitterEngine sessionUserID]];
				[defaults setObject:followingStatusIDs 
						 forKey:@"CanaryLastFollowingStatusID"];
			}
		} else {
			followingStatusIDs = [NSMutableDictionary dictionaryWithCapacity:1];
			[followingStatusIDs setValue:cacheManager.lastFollowingStatusID 
								  forKey:[twitterEngine sessionUserID]];
			[defaults setObject:followingStatusIDs 
						 forKey:@"CanaryLastFollowingStatusID"];
		}
	}
	if (cacheManager.lastReceivedMessageID != NULL &&
		cacheManager.lastReceivedMessageID != @"" &&
		cacheManager.lastReceivedMessageID != @" " &&
		cacheManager.lastReceivedMessageID != nil) {
		if (lastReceivedDMIDs = [NSMutableDictionary dictionaryWithDictionary:
			[defaults dictionaryForKey:@"CanaryLastReceivedDMID"]]) {
			if (twitterEngine.sessionUserID != nil) {
				[lastReceivedDMIDs setValue:cacheManager.lastReceivedMessageID 
								 forKey:[twitterEngine sessionUserID]];
				[defaults setObject:lastReceivedDMIDs 
						 forKey:@"CanaryLastReceivedDMID"];
			}
		} else {
			lastReceivedDMIDs = [NSMutableDictionary dictionaryWithCapacity:1];
			[lastReceivedDMIDs setValue:cacheManager.lastReceivedMessageID 
								 forKey:[twitterEngine sessionUserID]];
			[defaults setObject:lastReceivedDMIDs 
						 forKey:@"CanaryLastReceivedDMID"];
		}
	}
}

// Retweets the given status text from the given userID
- (void) retweetStatus:(NSString *)statusText
		fromUserWithID:(NSString *)userID {
	NSString *message = [NSString stringWithFormat:@"Retweeting from @%@: %@", 
						 userID, statusText];
	if ([twitterEngine sessionUserID]) {
		[charsLeftIndicator setIntValue:0];
		[updateDispatcher addMessage:message];
		
		NSString *msg = [NSString stringWithFormat:@"Retweeted from %@",
			userID];
		[statusBarTextField setStringValue:msg];
		[statusBarImageView setImage:[NSImage imageNamed:@"comments"]];
		[statusBarTextField setHidden:NO];
		[statusBarImageView setHidden:NO];
	}
}

// Delegate: Changes the green bar and enables/disables the tweet button.
- (void) controlTextDidChange:(NSNotification *)aNotification {
	NSText *fieldEditor = [newStatusTextField currentEditor];
	self.realSelectedRange = [fieldEditor selectedRange];
	
	int charsWritten = [[newStatusTextField stringValue] length];
	
	// Counter readjustment
	[charsLeftIndicator setMaxValue:(140*((charsWritten/140)+1))];
	[charsLeftIndicator setCriticalValue:(140*((charsWritten/140)+1))];
	[charsLeftIndicator setWarningValue:(140*((charsWritten/140)+1))-15];
	
	[charsLeftIndicator setToolTip:[NSString 
		stringWithFormat:@"Characters written: %i\nCharacters left: %i",
			charsWritten, (((charsWritten / 140)+1)*140 - charsWritten)]];
	if (charsWritten > 0) {
		[tweetButton setEnabled:YES];
	} else {
		[tweetButton setEnabled:NO];
	}
	int charsLeft = 140 - charsWritten;
	[charsLeftIndicator setIntValue:charsWritten];
	if ([[newStatusTextField stringValue] hasPrefix:@"d "] ||
			[[newStatusTextField stringValue] hasPrefix:@"D "]) {
		[tweetButton setTitle:@"Message!"];
		if (charsLeft < 0)
			[tweetButton setEnabled:NO];
		else {
			if ([tweetButton isEnabled])
				return;
			else
				[tweetButton setEnabled:YES];
		}
	} else {
		if (charsLeft < 0)
			[tweetButton setTitle:[NSString stringWithFormat:@"Twt ×%i", 
								   (charsWritten / 140)+1]];
		else {
			if ([[tweetButton title] isEqualToString:@"Tweet!"])
				return;
			else
				[tweetButton setTitle:@"Tweet!"];
		}
	}
}

// Delegate: Called when the selection range changes in a text view
- (void) textDidEndEditing:(NSNotification *)notification {
	NSText *fieldEditor = [newStatusTextField currentEditor];
	self.realSelectedRange = [fieldEditor selectedRange];
	
	int charsWritten = [[newStatusTextField stringValue] length];
	
	// Counter readjustment
	[charsLeftIndicator setMaxValue:(140*((charsWritten/140)+1))];
	[charsLeftIndicator setCriticalValue:(140*((charsWritten/140)+1))];
	[charsLeftIndicator setWarningValue:(140*((charsWritten/140)+1))-15];
	
	[charsLeftIndicator setToolTip:[NSString 
									stringWithFormat:@"Characters written: %i\nCharacters left: %i",
									charsWritten, (((charsWritten / 140)+1)*140 - charsWritten)]];
	if (charsWritten > 0) {
		[tweetButton setEnabled:YES];
	} else {
		[tweetButton setEnabled:NO];
	}
	int charsLeft = 140 - charsWritten;
	[charsLeftIndicator setIntValue:charsWritten];
	if ([[newStatusTextField stringValue] hasPrefix:@"d "] ||
		[[newStatusTextField stringValue] hasPrefix:@"D "]) {
		[tweetButton setTitle:@"Message!"];
		if (charsLeft < 0)
			[tweetButton setEnabled:NO];
		else {
			if ([tweetButton isEnabled])
				return;
			else
				[tweetButton setEnabled:YES];
		}
	} else {
		if (charsLeft < 0)
			[tweetButton setTitle:[NSString stringWithFormat:@"Twt ×%i", 
								   (charsWritten / 140)+1]];
		else {
			if ([[tweetButton title] isEqualToString:@"Tweet!"])
				return;
			else
				[tweetButton setTitle:@"Tweet!"];
		}
	}
}

// Used for enabling/disabling menu items according to the controller state
- (BOOL)validateMenuItem:(NSMenuItem *)item {
	NSText *fieldEditor = [newStatusTextField currentEditor];
	NSRange selectedRange = [(NSTextView *)fieldEditor selectedRange];
    if ([item action] == @selector(shortenURL:)) {
		if ([[[(NSTextView *)fieldEditor 
				attributedSubstringFromRange:selectedRange] string] 
			  hasPrefix:@"http://"]) {
			return YES;
		} else {
			return NO;
		}
	} else {
		return YES;
	}
       
}

// Action: This is called whenever the user performs an action on a status
// or user.
- (IBAction) invokeActionOnUser:sender {
	NSString *userScreenName, *userURL;
	if ([[timelineButton titleOfSelectedItem] 
		 isEqualToString:@"Received messages"]) {
		userScreenName = [(NSXMLNode *)[sender toolTip] senderScreenName];
		userURL = [(NSXMLNode *)[sender toolTip] senderURL];
	} else if ([[timelineButton titleOfSelectedItem] 
				isEqualToString:@"Sent messages"]) {
		userScreenName = [(NSXMLNode *)[sender toolTip] recipientScreenName];
		userURL = [(NSXMLNode *)[sender toolTip] recipientURL];
	} else {
		userScreenName = [(NSXMLNode *)[sender toolTip] userScreenName];
		userURL = [(NSXMLNode *)[sender toolTip] userURL];
	}
	
	if ([[sender titleOfSelectedItem] isEqualToString:@"Add"]) {
		[self createFriendshipWithUser:userScreenName];
	} else if ([[sender titleOfSelectedItem] isEqualToString:@"Remove"]) {
		[self destroyFriendshipWithUser:userScreenName];
	} else if ([[sender titleOfSelectedItem] isEqualToString:@"Follow"]) {
		[self followUserWithID:userScreenName];	
	} else if ([[sender titleOfSelectedItem] isEqualToString:@"Leave"]) {
		[self leaveUserWithID:userScreenName];	
	} else if ([[sender titleOfSelectedItem] isEqualToString:@"Block"]) {
		[self showUserBlockAlertSheet:userScreenName];
	} else if ([[sender titleOfSelectedItem] isEqualToString:@"Unblock"]) {
		[self unblockUserWithID:userScreenName];
	} else if ([[sender titleOfSelectedItem] isEqualToString:@"Reply to"]) {
		[self typeUserID:userScreenName];
	} else if ([[sender titleOfSelectedItem] 
				isEqualToString:@"Message directly"]) {
		[self dmUserID:userScreenName];
	} else if ([[sender titleOfSelectedItem] 
				isEqualToString:@"Favorite this"]) {
		[self favoriteStatusWithID:[(NSXMLNode *)[sender toolTip] ID]];
	} else if ([[sender titleOfSelectedItem] 
				isEqualToString:@"Go to Web page"]) {
		[self openUserURL:userURL];
	} else if ([[sender titleOfSelectedItem] 
				isEqualToString:@"Go to Twitter page"]) {
		[self openUserURL:[NSString stringWithFormat:@"http://twitter.com/%@",
						   userScreenName]];
	} else if ([[sender titleOfSelectedItem] isEqualToString:@"Retweet this"]) {
		[self retweetStatus:[(NSXMLNode *)[sender toolTip] text]
			 fromUserWithID:userScreenName];
	}
}

// Shows the user block alert sheet
- (void) showUserBlockAlertSheet:(NSString *)userScreenName {
	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"Block"];
	[alert addButtonWithTitle:@"Cancel"];
	NSString *messageText = [NSString 
		stringWithFormat:@"Do you really want to block user \"%@\"?",
							 userScreenName];
	[alert setMessageText:messageText];
	[alert setInformativeText:@"Blocked users can be unblocked later."];
	[alert setAlertStyle:NSInformationalAlertStyle];
	
	CFRetain(userScreenName);
	
	[alert beginSheetModalForWindow:self.window
					  modalDelegate:self
					 didEndSelector:@selector(
		blockUserAlertDidEnd:returnCode:contextInfo:)
						contextInfo:userScreenName];
}

// Acts upon the result of the user block alert sheet
- (void) blockUserAlertDidEnd:(NSAlert *)alert
					   returnCode:(int)returnCode
					  contextInfo:(void *)contextInfo {
	id contextObject = (id)contextInfo;
	if (returnCode == NSAlertFirstButtonReturn) {
		[self blockUserWithID:(NSString *)contextInfo];
	}
	CFRelease(contextObject);
}

// Action: This is called when the about window needs to be shown.
- (IBAction) showAboutWindow:sender {
	ORSCanaryAboutController *aboutController =
		[[ORSCanaryAboutController alloc] initWithWindowNibName:@"About"];
	[[aboutController window] makeKeyAndOrderFront:sender];
}

// Action: This is called when the preferences window needs to be shown.
- (IBAction) showPreferencesWindow:sender {
	ORSCanaryPreferencesController *preferencesController =
	[[ORSCanaryPreferencesController alloc] 
			initWithWindowNibName:@"Preferences"];
	[[preferencesController window] makeKeyAndOrderFront:sender];
}

// Action: This is called when the login window needs to be shown.
- (IBAction) showLoginWindow:sender {
	prevUserID = [twitterEngine sessionUserID];
	prevPassword = [twitterEngine sessionPassword];
	
	ORSCanaryLoginController *loginController = 
	[[ORSCanaryLoginController alloc] initWithWindowNibName:@"LoginWindow"];
	[NSApp beginSheet:[loginController window]
	   modalForWindow:[NSApp mainWindow]
		modalDelegate:loginController
	   didEndSelector:@selector(didEndUserManagerSheet:returnCode:contextInfo:)
		  contextInfo:nil];
	
	[loginController fillPasswordTextField];
}

// This is called when the new user window needs to be shown.
- (void) showNewUserWindow {
	[NSApp beginSheet:newUserWindow
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(didEndNewUserSheet:returnCode:contextInfo:)
		  contextInfo:nil];
}

// Action: This is called when the "Signup for a new Twitter account" button in
// the new user sheet is clicked
- (IBAction) signupForNewAccountCall:sender {
	[self createNewTwitterAccount:self];
}

// Action: This is called when the "Login" button in the new user sheet is
// clicked
- (IBAction) loginCall:sender {
	[newUserWindow orderOut:sender];
	[NSApp endSheet:newUserWindow returnCode:1];
}

// Action: This is called when the "Close" button in the new user sheet is
// clicked
- (IBAction) closeCall:sender {
	[newUserWindow orderOut:sender];
	[NSApp endSheet:newUserWindow returnCode:2];
}

// Action: This is called when the "Quit" button in the new user sheet is
// clicked
- (IBAction) quitCall:sender {
	[newUserWindow orderOut:sender];
	[NSApp endSheet:newUserWindow returnCode:3];
}

// This method is called when the sheet closes
- (void) didEndNewUserSheet:(NSWindow *)sheet
				 returnCode:(int)returnCode
				contextInfo:(void *)contextInfo {
	if (returnCode == 0) {
		return;
	} else if (returnCode == 1) {
		[self showLoginWindow:self];
	} else if (returnCode == 2) {
		return;
	} else if (returnCode == 3) {
		[NSApp terminate:self];
	}
}

// Action: This is called when the user sends feedback
- (IBAction) sendFeedback:sender {
	NSURL *url = [NSURL URLWithString:@"mailto:nicktoumpelis@gmail.com"
		"?subject=Feedback%20for%20Canary"
		"&body=Please%20write%20your%20feedback%20here..."];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

// Action: This is called when the user clicks on the message that new messages
// have been received
- (IBAction) changeToReceivedDMs:sender {
	[timelineButton selectItemWithTitle:@"Received messages"];
	[self changeTimeline:self];
}

// Action: This creates a new Twitter account
- (IBAction) createNewTwitterAccount:sender {
	[self openUserURL:@"https://twitter.com/signup"];
}

// Action: This sends an image to TwitPic
- (IBAction) sendImageToTwitPic:sender {
	NSArray *acceptableFileTypes = [NSArray arrayWithObjects:@"jpg", @"jpeg", 
		@"png", @"gif", @"jpe", nil];
	NSOpenPanel *oPanel = [NSOpenPanel openPanel];
	[oPanel setAllowsMultipleSelection:NO];
	int result = [oPanel runModalForDirectory:NSHomeDirectory() 
										 file:nil
										types:acceptableFileTypes];
	if (result = NSOKButton) {
		[self executeCallToTwitPicWithFile:[oPanel filename]];
	}
}

// This method executes the call to twitpic and adds the resulting url in the
// text field
- (void) executeCallToTwitPicWithFile:(NSString *)filename {
	NSData *imageData = [[NSData alloc] initWithContentsOfFile:filename];
	ORSTwitPicDispatcher *twitPicDispatcher = [[ORSTwitPicDispatcher alloc]
											   init];
	NSString *twitPicURLString = [twitPicDispatcher uploadData:imageData
		withUsername:[twitterEngine sessionUserID]
			password:[twitterEngine sessionPassword]
				filename:filename];
	
	NSText *fieldEditor = [[self window] fieldEditor:YES 
										   forObject:newStatusTextField];
	int location = [fieldEditor selectedRange].location;
	[[self window] makeFirstResponder:nil];
	[[self window] makeFirstResponder:newStatusTextField];
	[fieldEditor setSelectedRange:[fieldEditor selectedRange]];
	NSMutableString *statusString = [NSMutableString 
									 stringWithString:[newStatusTextField stringValue]];
	NSCharacterSet *whitespaceCharset = 
	[NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSString *string;
	if ((location == 0) || ([whitespaceCharset characterIsMember:[statusString characterAtIndex:location-1]]))
		string = [NSString stringWithFormat:@"%@ ", twitPicURLString];
	else
		string = [NSString stringWithFormat:@" %@ ", twitPicURLString];
	
	[statusString insertString:string atIndex:location];
	[newStatusTextField setStringValue:statusString];
	[self controlTextDidChange:nil];
	[fieldEditor setSelectedRange:NSMakeRange(location+[string length], 0)];
	[fieldEditor setNeedsDisplay:YES];
	NSString *msg = [NSString 
					 stringWithFormat:@"Picture has been sent to Twitpic"];
	[statusBarTextField setStringValue:msg];
	[statusBarImageView setImage:[NSImage imageNamed:@"picture_link"]];
	[statusBarTextField setHidden:NO];
	[statusBarImageView setHidden:NO];
}

// This method executes the call to twitpic and adds the resulting url in the
// text field
- (void) executeCallToTwitPicWithData:(NSData *)imageData {
	ORSTwitPicDispatcher *twitPicDispatcher = [[ORSTwitPicDispatcher alloc]
											   init];
	NSString *twitPicURLString = [twitPicDispatcher uploadData:imageData
		withUsername:[twitterEngine sessionUserID]
			password:[twitterEngine sessionPassword]
				filename:@"user_selection.jpeg"];
	
	NSText *fieldEditor = [[self window] fieldEditor:YES 
										   forObject:newStatusTextField];
	int location = [fieldEditor selectedRange].location;
	[[self window] makeFirstResponder:nil];
	[[self window] makeFirstResponder:newStatusTextField];
	[fieldEditor setSelectedRange:[fieldEditor selectedRange]];
	NSMutableString *statusString = [NSMutableString 
									 stringWithString:[newStatusTextField stringValue]];
	NSCharacterSet *whitespaceCharset = 
	[NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSString *string;
	if ((location == 0) || ([whitespaceCharset characterIsMember:[statusString characterAtIndex:location-1]]))
		string = [NSString stringWithFormat:@"%@ ", twitPicURLString];
	else
		string = [NSString stringWithFormat:@" %@ ", twitPicURLString];
	
	[statusString insertString:string atIndex:location];
	[newStatusTextField setStringValue:statusString];
	[self controlTextDidChange:nil];
	[fieldEditor setSelectedRange:NSMakeRange(location+[string length], 0)];
	[fieldEditor setNeedsDisplay:YES];
	NSString *msg = [NSString 
		stringWithFormat:@"Picture has been sent to Twitpic"];
	[statusBarTextField setStringValue:msg];
	[statusBarImageView setImage:[NSImage imageNamed:@"picture_link"]];
	[statusBarTextField setHidden:NO];
	[statusBarImageView setHidden:NO];
}

// Shows that there is a connection problem
- (void) showConnectionFailure:(NSNotification *)note {
	[statusBarTextField setStringValue:@"Connection problem"];
	[statusBarTextField setHidden:NO];
	[statusBarImageView setImage:[NSImage imageNamed:@"error"]];
	[statusBarImageView setHidden:NO];
	[statusBarButton setEnabled:NO];
	connectionErrorShown = YES;
	[indicator stopAnimation:self];
	[charsLeftIndicator setHidden:NO];
	[receivedDMsScrollView setHidden:YES];
}

// Shows the server response when there is an error
- (void) showReceivedResponse:(NSNotification *)note {
	if (betweenUsers) {
		betweenUsers = NO;
		return;
	}

	NSHTTPURLResponse *response = (NSHTTPURLResponse *)[note object];
	NSInteger statusCode = [response statusCode];
	
	if (statusCode != 200 && statusCode != 304) {
		if (statusCode == 503) {
			[statusBarTextField setStringValue:@"Twitter is overloaded"];
			[indicator stopAnimation:self];
			[charsLeftIndicator setHidden:NO];
			[receivedDMsScrollView setHidden:YES];
		} else if (statusCode == 502) {
			[statusBarTextField setStringValue:@"Twitter is down"];
			[indicator stopAnimation:self];
			[charsLeftIndicator setHidden:NO];
			[receivedDMsScrollView setHidden:YES];
		} else if (statusCode == 500) {
			[statusBarTextField setStringValue:@"Twitter internal error"];
			[indicator stopAnimation:self];
			[charsLeftIndicator setHidden:NO];
			[receivedDMsScrollView setHidden:YES];
		} else if (statusCode == 404) {
			[statusBarTextField setStringValue:@"Requested resource not found"];
		} else if (statusCode == 403) {
			[statusBarTextField 
				setStringValue:@"Request not allowed by Twitter"];
		} else if (statusCode == 401) {
			[statusBarTextField 
			 setStringValue:@"Authorization required or invalid"];
		} else if (statusCode == 400) {
			[statusBarTextField 
					setStringValue:@"Request invalid or rate exceeded"];
		}
		
		[statusBarTextField setHidden:NO];
		[statusBarImageView setImage:[NSImage imageNamed:@"error"]];
		[statusBarImageView setHidden:NO];
		[statusBarButton setEnabled:NO];
		connectionErrorShown = YES;
	}
	
	[indicator stopAnimation:self];
	[charsLeftIndicator setHidden:NO];
}

// Action: shows the picture taker to the user
- (IBAction) showPictureTaker:sender {
	IKPictureTaker *pictureTaker = [IKPictureTaker pictureTaker];
	[pictureTaker setValue:[NSNumber numberWithBool:NO]
              forKey:IKPictureTakerShowEffectsKey];
	[pictureTaker setValue:[NSNumber numberWithBool:YES]
					forKey:IKPictureTakerAllowsEditingKey];
	[pictureTaker setValue:[NSNumber numberWithBool:YES]
					forKey:IKPictureTakerAllowsVideoCaptureKey];
	[pictureTaker beginPictureTakerSheetForWindow:self.window
									 withDelegate:self
								   didEndSelector:@selector(
		pictureTakerDidEnd:returnCode:contextInfo:)
									  contextInfo:nil];
}

// This gets called when the picture taker has an output image
- (void) pictureTakerDidEnd:(IKPictureTaker *)picker
				 returnCode:(NSInteger)code
				contextInfo:(void *)contextInfo {
	if (code == NSOKButton) { 
		NSImage *image = [picker outputImage];
		NSData *dataTiffRep = [image TIFFRepresentation];
		NSBitmapImageRep *bitmapRep = [NSBitmapImageRep 
									   imageRepWithData:dataTiffRep];
		NSData *jpegData = [bitmapRep representationUsingType:NSJPEGFileType
												   properties:nil];
		[self executeCallToTwitPicWithData:jpegData];
	}
}

// This gets called when the main application window is called and the
// user clicks on the dock icon.
- (BOOL) applicationShouldHandleReopen:(NSApplication *)theApplication	
					 hasVisibleWindows:(BOOL)flag {
	[[self window] makeKeyAndOrderFront:self];
	return YES;
}

// Speech-related methods

// Action: This is called 
- (IBAction) listen:sender {
	if ([sender state] == NSOffState) {
		// Speech recognition
		recognizer = [[NSSpeechRecognizer alloc] init];
		[recognizer setCommands:spokenCommands];
		[recognizer setDelegate:self];
		[recognizer startListening];
		[sender setState:NSOnState];
	} else {
		[recognizer stopListening];
		[recognizer release];
		recognizer = NULL;
		[sender setState:NSOffState];
	}
}

// Delegate: acts upon the recognition of certain commands
- (void) speechRecognizer:(NSSpeechRecognizer *)sender
	  didRecognizeCommand:(id)command {
	if ([(NSString *)command isEqualToString:@"Tweet"]) {
		[self sendUpdate:sender];
		return;
	}
	if ([(NSString *)command isEqualToString:@"Home"]) {
		[self goHome:sender];
		return;
	}
	if ([(NSString *)command isEqualToString:@"Refresh"]) {
		[self changeTimeline:sender];
		return;
	}
}


// Friendship methods

// Add user with given ID from friends list (following)
- (void) createFriendshipWithUser:(NSString *)userID {
	if ([twitterEngine sessionUserID]) {
		//BOOL result = 
		[twitterEngine createFriendshipWithUser:userID];
		//NSLog(@"CanaryController:: createFriendshipWithUser: %@", 
		//	  result ? @"YES" : @"NO");
		NSString *msg = [NSString stringWithFormat:@"%@ has been added",
						 userID];
		[statusBarTextField setStringValue:msg];
		[statusBarImageView setImage:[NSImage imageNamed:@"user_add"]];
		[statusBarTextField setHidden:NO];
		[statusBarImageView setHidden:NO];
	}
}

// Remove user with given ID from friends list (following)
- (void) destroyFriendshipWithUser:(NSString *)userID {
	if ([twitterEngine sessionUserID]) {
		//BOOL result = 
		[twitterEngine destroyFriendshipWithUser:userID];
		//NSLog(@"CanaryController:: destroyFriendshipWithUser: %@", 
		//	  result ? @"YES" : @"NO");
		NSString *msg = [NSString stringWithFormat:@"%@ has been removed",
						 userID];
		[statusBarTextField setStringValue:msg];
		[statusBarImageView setImage:[NSImage imageNamed:@"user_delete"]];
		[statusBarTextField setHidden:NO];
		[statusBarImageView setHidden:NO];
	}
}


// Block methods

// Block the user owning the status
- (void) blockUserWithID:(NSString *)userID { 
	if ([twitterEngine sessionUserID]) {
		//BOOL result = 
		[twitterEngine blockUser:userID];
		//NSLog(@"CanaryController:: blockUserWithID: %@", 
		//	result ? @"YES" : @"NO");
		NSString *msg = [NSString stringWithFormat:@"%@ has been blocked",
			userID];
		[statusBarTextField setStringValue:msg];
		[statusBarImageView setImage:[NSImage imageNamed:@"user_red"]];
		[statusBarTextField setHidden:NO];
		[statusBarImageView setHidden:NO];
	}
}

// Unblock the user owning the status
- (void) unblockUserWithID:(NSString *)userID {
	if ([twitterEngine sessionUserID]) {
		//BOOL result = 
		[twitterEngine unblockUser:userID];
		//NSLog(@"CanaryController:: unblockUserWithID: %@", 
		//	result ? @"YES" : @"NO");
		NSString *msg = [NSString stringWithFormat:@"%@ has been unblocked",
			userID];
		[statusBarTextField setStringValue:msg];
		[statusBarImageView setImage:[NSImage imageNamed:@"user_green"]];
		[statusBarTextField setHidden:NO];
		[statusBarImageView setHidden:NO];
	}
}


// Notification methods

// Follow the user owning the status
- (void) followUserWithID:(NSString *)userID {
	if ([twitterEngine sessionUserID]) {
		//BOOL result = 
		[twitterEngine followUser:userID];
		//NSLog(@"CanaryController:: followUserWithID: %@", 
		//	  result ? @"YES" : @"NO");
	}
}

// Leave the user owning the status
- (void) leaveUserWithID:(NSString *)userID {
	if ([twitterEngine sessionUserID]) {
		//BOOL result = 
		[twitterEngine leaveUser:userID];
		//NSLog(@"CanaryController:: leaveUserWithID: %@", 
		//	  result ? @"YES" : @"NO");
	}
}


// Favorite methods

// Favorite the selected status
- (void) favoriteStatusWithID:(NSString *)statusID {
	if ([twitterEngine sessionUserID]) {
		[twitterEngine createBlindFavorite:statusID];
		NSString *msg = [NSString 
			stringWithFormat:@"A new favorite has been added", statusID];
		[statusBarTextField setStringValue:msg];
		[statusBarImageView setImage:[NSImage imageNamed:@"fave_star"]];
		[statusBarTextField setHidden:NO];
		[statusBarImageView setHidden:NO];
	}
}


// Methods using the main preferences

// Returns the refresh rate selected by the user.
- (float) timelineRefreshPeriod {
	NSString *timelineRefreshPeriodString = (NSString *)[defaults 
									objectForKey:@"CanaryRefreshPeriod"];
	if ([timelineRefreshPeriodString isEqualToString:@"Manually"])
		return -1.0;
	else if ([timelineRefreshPeriodString isEqualToString:@"Every minute"])
		return 60.0;
	else if ([timelineRefreshPeriodString isEqualToString:@"Every two minutes"])
		return 120.0;
	else if ([timelineRefreshPeriodString 
			  isEqualToString:@"Every three minutes"])
		return 180.0;
	else if ([timelineRefreshPeriodString 
			  isEqualToString:@"Every five minutes"])
		return 300.0;
	else if ([timelineRefreshPeriodString isEqualToString:@"Every ten minutes"])
		return 600.0;
	else
		return -1.0;
}

// Returns the number of number of updates kept in the timeline
- (int) maxShownUpdates {
	NSString *maxShownUpdatesString = (NSString *)[defaults 
						objectForKey:@"CanaryMaxShownUpdates"];
	return [maxShownUpdatesString integerValue];
}

// Returns the selected URL shortener
- (int) selectedURLShortener {
	NSString *selectedURLShortener = (NSString *)[defaults 
								objectForKey:@"CanarySelectedURLShortener"];
	if ([selectedURLShortener isEqualToString:@"Adjix"])
		return ORSAdjixShortenerType;
	else if ([selectedURLShortener isEqualToString:@"Bit.ly"])
		return ORSBitlyShortenerType;
	else if ([selectedURLShortener isEqualToString:@"Cli.gs"])
		return ORSCligsShortenerType;
	else if ([selectedURLShortener isEqualToString:@"Is.gd"])
		return ORSIsgdShortenerType;
	else
		return ORSTinyURLShortenerType;
}

// Returns whether Canary is set to retrieve all updates since last execution
- (BOOL) willRetrieveAllUpdates {
	return [defaults boolForKey:@"CanaryWillRetrieveAllUpdates"];
}

// Returns the last status id shown
- (NSString *) statusIDSinceLastExecution {
	NSDictionary *lastFollowingStatusIDs;
	if (lastFollowingStatusIDs = 
			[defaults dictionaryForKey:@"CanaryLastFollowingStatusID"]) {
		NSString *statusID;
		if (statusID = [lastFollowingStatusIDs valueForKey:[twitterEngine
				sessionUserID]]) {
			return statusID;
		} else {
			return NULL;
		}
	} else {
		return NULL;
	}
}

// Returns the id of the last received direct message since last execution
- (NSString *) receivedDMIDSinceLastExecution {
	NSDictionary *lastReceivedDMIDs;
	if (lastReceivedDMIDs = 
		[defaults dictionaryForKey:@"CanaryLastReceivedDMID"]) {
		NSString *messageID;
		if (messageID = [lastReceivedDMIDs valueForKey:[twitterEngine
															sessionUserID]]) {
			return messageID;
		} else {
			return NULL;
		}
	} else {
		return NULL;
	}
}


// Growl-related methods

// Posts notifications that status updates have been received
- (void) postStatusUpdatesReceived:(NSNotification *)note {
	NSMutableArray *newStatuses = [[NSMutableArray alloc] init];
	for (NSXMLNode *node in (NSArray *)[note object]) {
		if ([[node ID] intValue] > 
				[[self statusIDSinceLastExecution] intValue]) {
			[newStatuses addObject:node];
		}
	}
	if ([newStatuses count] > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Status Updates Received"
									description:[NSString 
			stringWithFormat:@"%i status updates received", 
						 [(NSArray *)[note object] count]]
							   notificationName:@"Status Updates Received"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:nil];
	} else {
		for (NSXMLNode *node in newStatuses) {
			[GrowlApplicationBridge notifyWithTitle:[node userName]
										description:[node text]
								   notificationName:@"Status Updates Received"
										   iconData:nil
										   priority:1
										   isSticky:NO
									   clickContext:nil];
		}
	}
}

// Posts notifications that replies have been received
- (void) postRepliesReceived:(NSNotification *)note {
	if ([(NSArray *)[note object] count] > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Replies Received"
			description:[NSString stringWithFormat:@"%i replies received", 
										[(NSArray *)[note object] count]]
							   notificationName:@"Replies Received"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:nil];
	} else {
		for (NSXMLNode *node in (NSArray *)[note object]) {
			[GrowlApplicationBridge notifyWithTitle:[node userName]
									description:[node text]
							   notificationName:@"Replies Received"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:nil];
		}
	}
}

// Posts notifications that messages have been received
- (void) postDMsReceived:(NSNotification *)note {
	if ([(NSArray *)[note object] count] > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Direct Messages Received"
									description:[NSString 
							stringWithFormat:@"%i direct messages received", 
										 [(NSArray *)[note object] count]]
							   notificationName:@"Direct Messages Received"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:nil];
	} else {
		for (NSXMLNode *node in (NSArray *)[note object]) {
			[GrowlApplicationBridge notifyWithTitle:[node senderScreenName]
										description:[node text]
								   notificationName:@"Direct Messages Received"
										   iconData:nil
										   priority:2
										   isSticky:NO
									   clickContext:nil];
		}
	}
}

// Posts notifications that messages with larger id that the given have been
// received
- (void) postDMsReceived:(NSNotification *)note
				 afterID:(NSString *)messageID {
	// This can be optimised
	int count = 0;
	for (NSXMLNode *node in (NSArray *)[note object]) {
		if ([[node ID] intValue] > [messageID intValue]) {
			count++;
		}
	}
	
	if (count > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Direct Messages Received"
									description:[NSString 
							stringWithFormat:@"%i direct messages received", 
										 [(NSArray *)[note object] count]]
								notificationName:@"Direct Messages Received"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:nil];
	} else {
		for (NSXMLNode *node in (NSArray *)[note object]) {
			if ([[node ID] intValue] > [messageID intValue]) {
				[GrowlApplicationBridge notifyWithTitle:[node senderScreenName]
											description:[node text]
									notificationName:@"Direct Messages Received"
											   iconData:nil
											   priority:2
											   isSticky:NO
										   clickContext:nil];
			}
		}
	}
}

// Posts a notification that a status update has been sent
- (void) postStatusUpdatesSent:(NSNotification *)note {
	if ([(NSArray *)[note object] count] > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Status Updates Sent"
			description:[NSString stringWithFormat:@"%i status updates sent", 
												 [(NSArray *)[note object] count]]
							   notificationName:@"Status Updates Sent"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:nil];
	} else {
		for (NSXMLNode *node in (NSArray *)[note object]) {
			[GrowlApplicationBridge notifyWithTitle:[node userName]
										description:[node text]
								   notificationName:@"Status Updates Sent"
										   iconData:nil
										   priority:0
										   isSticky:NO
									   clickContext:nil];
		}
	}
}

// Posts a notification that a message has been sent
- (void) postDMsSent:(NSNotification *)note {
	if ([(NSArray *)[note object] count] > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Direct Messages Sent"
			description:[NSString stringWithFormat:@"%i direct messages sent", 
											[(NSArray *)[note object] count]]
							   notificationName:@"Direct Messages Sent"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:nil];
	} else {
		for (NSXMLNode *node in (NSArray *)[note object]) {
			[GrowlApplicationBridge notifyWithTitle:[node userName]
										description:[node text]
								   notificationName:@"Direct Messages Sent"
										   iconData:nil
										   priority:0
										   isSticky:NO
									   clickContext:nil];
		}
	}
}

@end
