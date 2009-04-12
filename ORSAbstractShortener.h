/*!
 @header ORSAbstractShortener
 @abstract Abstract superclass used for defining URL shorteners. All shorteners
 should be subclasses of this.
 @author Nicholas Toumpelis
 @copyright Nicholas Toumpelis, Ocean Road Software
 @version 0.7
 @updated 2009-04-12
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
 @method generateURLFromRequestURL:
 This should be used by all concrete classes that implement generateURLFrom:. It
 generates the actual request that is sent to the remote server.
 */
- (NSString *) generateURLFromRequestURL:(NSString *)requestURL;

/*!
 @method generateURLFromPostRequestURL:
 This should be used by all concrete classes that implement generateURLFrom: and 
 would like to send POST requests. It generates the actual request that is sent 
 to the remote server.
 */
- (NSString *) generateURLFromPostRequestURL:(NSString *)requestURL;

@end
