/*!
 @header ORSBitlyShortener
 @abstract Represents a bit.ly URL shortener.
 @author Nicholas Toumpelis
 @copyright Ocean Road Software
 @version 0.6
 @updated 2008-10-18
 */

#import <Cocoa/Cocoa.h>
#import "ORSAbstractShortener.h"

/*!
 @class ORSBitlyShortener
 @group URL Shorteners
 @abstract Represents a bit.ly URL shortener.
 @author Nicholas Toumpelis
 @version 0.6
 @updated 2008-10-18
 */
@interface ORSBitlyShortener : ORSAbstractShortener {

}

/*!
 @method getShortener:
 Returns the URL shortener that corresponds to the given shortener type.
 */
- (NSString *) generateURLFrom:(NSString *)originalURL;
- (NSString *) generateAuthenticatedURLFrom:(NSString *)originalURL;

@end
