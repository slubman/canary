/*!
 @header ORSUrlborgShortener
 @abstract Represents a urlBorg shortener.
 @author Nicholas Toumpelis
 @copyright Ocean Road Software
 @version 0.6
 @updated 2009-02-24
 */

#import <Cocoa/Cocoa.h>
#import "ORSAbstractShortener.h"

/*!
 @class ORSUrlborgShortener
 @group URL Shorteners
 @abstract Represents a urlBorg shortener.
 @author Nicholas Toumpelis
 @version 0.6
 @updated 2009-02-24
 */
@interface ORSUrlborgShortener : ORSAbstractShortener {
	
}

/*!
 @method getShortener:
 Returns the URL shortener that corresponds to the given shortener type.
 */
- (NSString *) generateURLFrom:(NSString *)originalURL;
- (NSString *) generateAuthenticatedURLFrom:(NSString *)originalURL;

@end

