//
//  ORSDateDifferenceFormatter.m
//  Canary Controller
//
//  Created by Nicholas Toumpelis on 03/11/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//
//  0.6 - 04/11/2008

#import "ORSDateDifferenceFormatter.h"

@implementation ORSDateDifferenceFormatter

- (NSString *) stringForObjectValue:(id)anObject {
	// Get time difference
	int currentDateAsSeconds = (int) [NSDate timeIntervalSinceReferenceDate];
	int statusDateAsSeconds = (int)[(NSString *)anObject doubleValue];
	int seconds = currentDateAsSeconds - statusDateAsSeconds;
	
	// Check whether it's years away
	int yearInSecs = 12 * 4 * 7 * 24 * 60 * 60;
	int years = seconds / yearInSecs;
	if (years > 0) {
		if (years > 1) {
			return @"> a year";
		} else {
			return @"a year";
		}
	}
	
	// check whether it's months away
	int monthInSecs = 4 * 7 * 24 * 60 * 60;
	int months = seconds / monthInSecs;
	int secsAfterMonths = seconds % monthInSecs;
	if (secsAfterMonths > 2 * 7 * 24 * 60 * 60) {
		months++;
	}
	if (months > 0) {
		if (months > 1) {
			return [NSString stringWithFormat:@"%i months", months];
		} else {
			return @"a month";
		}
	}
	
	// check whether it's weeks away
	int weekInSecs = 7 * 24 * 60 * 60;
	int weeks = seconds / weekInSecs;
	int secsAfterWeeks = seconds % weekInSecs;
	if (secsAfterWeeks > 4 * 24 * 60 * 60) {
		weeks++;
	}
	if (weeks > 0) {
		if (weeks > 1) {
			return [NSString stringWithFormat:@"%i weeks", weeks];
		} else {
			return @"a week";
		}
	}
	
	// check whether it's days away
	int dayInSecs = 24 * 60 * 60;
	int days = seconds / dayInSecs;
	int secsAfterDays = seconds % dayInSecs;
	if (secsAfterDays > 12 * 60 * 60) {
		days++;
	}
	if (days > 0) {
		if (days > 1) {
			return [NSString stringWithFormat:@"%i days", days];
		} else {
			return @"a day";
		}
	}
	
	// check whether it's hours away
	int hourInSecs = 60 * 60;
	int hours = seconds / hourInSecs;
	int secsAfterHours = seconds % hourInSecs;
	if (secsAfterHours > 30 * 60) {
		hours++;
	}
	if (hours > 0) {
		if (hours > 1) {
			return [NSString stringWithFormat:@"%i hrs", hours];
		} else {
			return @"an hr";
		}
	}
	
	// check whether it's minutes away
	int minuteInSecs = 60;
	int minutes = seconds / minuteInSecs;
	if (minutes > 0) {
		if (minutes > 1) {
			return [NSString stringWithFormat:@"%i mins", minutes];
		} else {
			return @"a min";
		}
	}
	
	// if not any of the above, it's seconds away
	if (seconds > 1) {
		return [NSString stringWithFormat:@"%i secs", seconds];
	} else if (seconds == 1) {
		return @"a sec";
	} else {
		return @"< a sec";
	}
}

- (BOOL) getObjectValue:(id *)anObject 
			  forString:(NSString *)string
	   errorDescription:(NSString **)error {
	return YES;
}

- (NSAttributedString *) attributedStringForObjectValue:(id)anObject
						withDefaultAttributes:(NSDictionary *)attributes {

	return [[NSAttributedString alloc] 
			initWithString:[self stringForObjectValue:anObject] 
			attributes:attributes];
}

@end
