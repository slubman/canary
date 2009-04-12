/*!
 @header ORSShortenerFactory
 @abstract Generates a URL shortener that corresponds to a given type.
 @author Nicholas Toumpelis
 @copyright Nicholas Toumpelis, Ocean Road Software
 @version 0.7
 @updated 2009-04-12
 */

#import <Cocoa/Cocoa.h>
#import "ORSShortener.h"
#import "ORSAdjixShortener.h"
#import "ORSBitlyShortener.h"
#import "ORSCligsShortener.h"
#import "ORSIsgdShortener.h"
#import "ORSSnipURLShortener.h"
#import "ORSTinyURLShortener.h"
#import "ORSTrimShortener.h"
#import "ORSUrlborgShortener.h"

/*!
 @enum ORSShortenerTypes
 Contains constants for all available URL shorteners.
 */
enum {
	ORSAdjixShortenerType = 1,
	ORSBitlyShortenerType = 2,
	ORSCligsShortenerType = 3,
	ORSIsgdShortenerType = 4,
	ORSSnipURLShortenerType = 5,
	ORSTinyURLShortenerType = 6,
	ORSTrimShortenerType = 7,
	ORSUrlborgShortenerType = 8
};

/*!
 @typedef ORSShortenerTypes
 Defines the type for constants for all available URL shorteners.
 */
typedef NSUInteger ORSShortenerTypes;

/*!
 @class ORSShortenerFactory
 @group URL Shorteners
 @abstract Generates a URL shortener that corresponds to a given type.
 @author Nicholas Toumpelis
 @version 0.6
 @updated 2008-10-18
 */
@interface ORSShortenerFactory : NSObject {

}

/*!
 @method getShortener:
 Returns the URL shortener that corresponds to the given shortener type.
 */
+ (id <ORSShortener>) getShortener:(NSUInteger)shortenerType;

@end