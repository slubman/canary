/*!
 @header ORSAbstractShortener
 @abstract Abstract superclass used for defining URL shorteners. All shorteners
 should be subclasses of this.
 @author Nicholas Toumpelis
 @copyright Ocean Road Software
 @version 0.6
 @updated 2008-12-27
 */

#import <Cocoa/Cocoa.h>
#import "ORSShortener.h"

/*!
 @class ORSAbstractShortener
 @group URL Shorteners
 @abstract Abstract superclass used for defining URL shorteners. All shorteners
 should be subclasses of this.
 @author Nicholas Toumpelis
 @version 0.6
 @updated 2008-12-27
 */
@interface ORSAbstractShortener : NSObject <ORSShortener> {

}

/*!
 @method getShortener:
 Returns the URL shortener that corresponds to the given shortener type. This
 method is abstract and if not overloaded (by a concrete URL shortener) returns
 NULL.
 */
- (NSString *) generateURLFrom:(NSString *)originalURL;

/*!
 @method generateURKFromRequestURL:
 This should be used by all concrete classes that implement generateURLFrom:. It
 generates the actual request that is sent to the remote server.
 */
- (NSString *) generateURLFromRequestURL:(NSString *)requestURL;

@end
