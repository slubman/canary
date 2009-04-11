/*!
 @header ORSSnipURLShortener
 @abstract Represents a SnipURL shortener.
 @author Nicholas Toumpelis
 @copyright Ocean Road Software
 @version 0.6
 @updated 2009-02-23
 */

#import <Cocoa/Cocoa.h>
#import "ORSAbstractShortener.h"

/*!
 @class ORSSnipURLShortener
 @group URL Shorteners
 @abstract Represents a SnipURL shortener.
 @author Nicholas Toumpelis
 @version 0.6
 @updated 2009-02-23
 */
@interface ORSSnipURLShortener : ORSAbstractShortener {
	
}

/*!
 @method getShortener:
 Returns the URL shortener that corresponds to the given shortener type.
 */
- (NSString *) generateURLFrom:(NSString *)originalURL;
- (NSString *) generateAuthenticatedURLFrom:(NSString *)originalURL;

@end
