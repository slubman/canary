/*!
 @header ORSShortener
 @abstract Protocol to which URL shorteners should comply.
 @author Nicholas Toumpelis
 @copyright Ocean Road Software
 @version 0.6
 @updated 2008-10-18
 */

#import <Cocoa/Cocoa.h>

/*!
 @protocol ORSShortener
 @group URL Shorteners
 @abstract Protocol to which URL shorteners should comply.
 @author Nicholas Toumpelis
 @version 0.6
 @updated 2008-10-18
 */
@protocol ORSShortener

@required

/*!
 @method generateURLFrom:
 This method returns the generated (shortened) URL that corresponds to the given
 (original) URL.
 */
- (NSString *) generateURLFrom:(NSString *)originalURL;

@end
