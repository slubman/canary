/*!
 @header ORSTinyURLShortener
 @abstract Represents a TinyURL shortener.
 @author Nicholas Toumpelis
 @copyright Nicholas Toumpelis, Ocean Road Software
 @version 0.7
 @updated 2009-04-12
 */

#import <Cocoa/Cocoa.h>
#import "ORSAbstractShortener.h"

/*!
 @class ORSTinyURLShortener
 @group URL Shorteners
 @abstract Represents a TinyURL shortener.
 @author Nicholas Toumpelis
 @version 0.6
 @updated 2008-10-18
 */
@interface ORSTinyURLShortener : ORSAbstractShortener {

}

/*!
 @method getShortener:
 Returns the URL shortener that corresponds to the given shortener type.
 */
- (NSString *) generateURLFrom:(NSString *)originalURL;

@end
