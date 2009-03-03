//
//  NSString+ORSCanaryAdditions.m
//  Canary
//
//  Created by Nicholas Toumpelis on 04/10/2008.
//  Copyright 2008 Ocean Road Software. All rights reserved.
//

#import "NSString+ORSCanaryAdditions.h"

@implementation NSString ( ORSCanaryAdditions )

// Detects and replaces HTML Character Entities
+ (NSString *) replaceHTMLEntities:(NSString *)string {
	NSRange range = [string rangeOfString:@"&"];
	if (range.location == NSNotFound)
		return string;
	else {
		range = [string rangeOfString:@"&lt;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&lt;"
													 withString:@"<"];
		range = [string rangeOfString:@"&gt;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&gt;"
													 withString:@">"];
		range = [string rangeOfString:@"&amp;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&amp;"
													 withString:@"&"];
		range = [string rangeOfString:@"&quot;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&quot;"
													 withString:@"\""];
		range = [string rangeOfString:@"&apos;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&apos;"
													 withString:@"\'"];
		range = [string rangeOfString:@"&cent;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&cent;"
													 withString:@"¢"];
		range = [string rangeOfString:@"&pound;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&pound;"
													 withString:@"£"];
		range = [string rangeOfString:@"&yen;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&yen;"
													 withString:@"¥"];
		range = [string rangeOfString:@"&euro;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&euro;"
													 withString:@"€"];
		range = [string rangeOfString:@"&sect;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&sect;"
													 withString:@"§"];
		range = [string rangeOfString:@"&copy;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&copy;"
													 withString:@"©"];
		range = [string rangeOfString:@"&reg;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&reg;"
													 withString:@"®"];
		range = [string rangeOfString:@"&times;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&times;"
													 withString:@"×"];
		range = [string rangeOfString:@"&divide;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&divide;"
													 withString:@"÷"];
		
		range = [string rangeOfString:@"&laquo;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&laquo;"
													withString:@"«"];
		range = [string rangeOfString:@"&not;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&not;"
													withString:@"¬"];
		range = [string rangeOfString:@"&curren;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&curren;"
													withString:@"¤"];
		range = [string rangeOfString:@"&macr;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&macr;"
													withString:@"¯"];
		range = [string rangeOfString:@"&deg;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&deg;"
													withString:@"°"];
		range = [string rangeOfString:@"&plusmn;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&plusmn;"
													withString:@""];
		range = [string rangeOfString:@"&uml;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&uml;"
													withString:@"¨"];
		range = [string rangeOfString:@"&ordf;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&ordf;"
													withString:@"ª"];
		range = [string rangeOfString:@"&sup3;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&sup3;"
													withString:@"³"];
		range = [string rangeOfString:@"&acute;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&acute;"
													withString:@"´"];
		range = [string rangeOfString:@"&micro;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&micro;"
													withString:@"µ"];
		range = [string rangeOfString:@"&para;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&para;"
													withString:@"¶"];
		range = [string rangeOfString:@"&middot;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&middot;"
													withString:@"·"];
		range = [string rangeOfString:@"&cedil;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&cedil;"
													withString:@"¸"];
		range = [string rangeOfString:@"&sup1;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&sup1;"
													withString:@"¹"];
		range = [string rangeOfString:@"&ordm;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&ordm;"
													withString:@"º"];
		range = [string rangeOfString:@"&raquo;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&raquo;"
													withString:@"»"];
		range = [string rangeOfString:@"&frac14;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&frac14;"
													withString:@"¼"];
		range = [string rangeOfString:@"&frac12;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&frac12;"
													withString:@"¹"];
		range = [string rangeOfString:@"&frac34;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&frac34;"
													withString:@"¾"];
		range = [string rangeOfString:@"&iquest;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&iquest;"
													withString:@"¿"];
		range = [string rangeOfString:@"&#8217;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&#8217;"
													withString:@"’"];
		range = [string rangeOfString:@"&iexcl;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurencesOfString:@"&iexcl;"
													withString:@"¡"];
		
		return string;
	}
}

@end
