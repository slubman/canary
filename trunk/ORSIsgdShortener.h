/*!
 @header ORSIsgdShortener
 @abstract Represents an is.gd URL shortener.
 @author Nicholas Toumpelis
 @copyright Ocean Road Software
 @version 0.6
 @updated 2008-10-18
 */

#import <Cocoa/Cocoa.h>
#import "ORSAbstractShortener.h"

/*!
 @class ORSIsgdShortener
 @group URL Shorteners
 @abstract Represents an is.gd URL shortener.
 @author Nicholas Toumpelis
 @version 0.6
 @updated 2008-10-18
 */
//@interface ORSIsgdShortener : NSObject < ORSShortener > {
@interface ORSIsgdShortener: ORSAbstractShortener {

}

/*!
 @method getShortener:
 Returns the URL shortener that corresponds to the given shortener type.
 */
- (NSString *) generateURLFrom:(NSString *)originalURL;

@end
