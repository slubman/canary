/*!
 @header ORSShortenerFactory
 @abstract Generates a URL shortener that corresponds to a given type.
 @author Nicholas Toumpelis
 @copyright Ocean Road Software
 @version 0.6
 @updated 2008-10-18
 */

#import <Cocoa/Cocoa.h>
#import "ORSShortener.h"
#import "ORSTinyURLShortener.h"
#import "ORSBitlyShortener.h"
#import "ORSCligsShortener.h"
#import "ORSAdjixShortener.h"
#import "ORSIsgdShortener.h"

/*!
 @enum ORSShortenerTypes
 Contains constants for all available URL shorteners.
 */
enum {
	ORSTinyURLShortenerType = 1,
	ORSBitlyShortenerType = 2,
	ORSCligsShortenerType = 3,
	ORSAdjixShortenerType = 6,
	ORSIsgdShortenerType = 7
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