/*!
 @header ORSCligsShortener
 @abstract Represents a cli.gs URL shortener.
 @author Nicholas Toumpelis
 @copyright Nicholas Toumpelis, Ocean Road Software
 @version 0.7
 @updated 2009-04-12
 */

#import <Cocoa/Cocoa.h>
#import "ORSAbstractShortener.h"

/*!
 @class ORSCligsShortener
 @group URL Shorteners
 @abstract Represents a cli.gs URL shortener.
 @author Nicholas Toumpelis
 @version 0.6
 @updated 2008-10-18
 */
@interface ORSCligsShortener : ORSAbstractShortener {

}

/*!
 @method getShortener:
 Returns the URL shortener that corresponds to the given shortener type.
 */
- (NSString *) generateURLFrom:(NSString *)originalURL;
- (NSString *) generateAuthenticatedURLFrom:(NSString *)originalURL;

@end
