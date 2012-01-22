//
//  PwdHash.m
//  PwdHash
//
//  Created by Nathaniel Nutter on 9/16/11.
//  Copyright 2011 Nathaniel Nutter. All rights reserved.
//

#import "PwdHash.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation PwdHash

@synthesize pwdString;
@synthesize urlString;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (NSString*)getHashedPasswordWithPasswordAndURL:(NSString*)thePassword
                                             url:(NSString*)theURL
{
    PwdHash* pwdHash = [PwdHash PwdHashWithPasswordAndURL:thePassword pwd:theURL];
    return [pwdHash getHashedPassword];
}

// Base64 Methods
// I believe these were from a StackOverflow question. Find out for attribution.

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
	52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
	-2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
	15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
	-2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

+ (NSString *)encodeBase64WithString:(NSString *)strData {
	return [PwdHash encodeBase64WithData:[strData dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)encodeBase64WithData:(NSData *)objData {
	const unsigned char * objRawData = [objData bytes];
	char * objPointer;
	char * strResult;
	
	// Get the Raw Data length and ensure we actually have data
	int intLength = [objData length];
	if (intLength == 0) return nil;
	
	// Setup the String-based Result placeholder and pointer within that placeholder
	strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
	objPointer = strResult;
	
	// Iterate through everything
	while (intLength > 2) { // keep going until we have less than 24 bits
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
		*objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
		*objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
		
		// we just handled 3 octets (24 bits) of data
		objRawData += 3;
		intLength -= 3; 
	}
	
	// now deal with the tail end of things
	if (intLength != 0) {
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		if (intLength > 1) {
			*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
			*objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
			*objPointer++ = '=';
		} else {
			*objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
			*objPointer++ = '=';
			*objPointer++ = '=';
		}
	}
	
	// Terminate the string-based result
	*objPointer = '\0';
	
	// Return the results as an NSString object
	return [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
}

+ (NSData *)decodeBase64WithString:(NSString *)strBase64 {
	const char * objPointer = [strBase64 cStringUsingEncoding:NSASCIIStringEncoding];
	int intLength = strlen(objPointer);
	int intCurrent;
	int i = 0, j = 0, k;
	
	unsigned char * objResult;
	objResult = calloc(intLength, sizeof(char));
	
	// Run through the whole string, converting as we go
	while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) ) {
		if (intCurrent == '=') {
			if (*objPointer != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
				// the padding character is invalid at this point -- so this entire string is invalid
				free(objResult);
				return nil;
			}
			continue;
		}
		
		intCurrent = _base64DecodingTable[intCurrent];
		if (intCurrent == -1) {
			// we're at a whitespace -- simply skip over
			continue;
		} else if (intCurrent == -2) {
			// we're at an invalid character
			free(objResult);
			return nil;
		}
		
		switch (i % 4) {
			case 0:
				objResult[j] = intCurrent << 2;
				break;
				
			case 1:
				objResult[j++] |= intCurrent >> 4;
				objResult[j] = (intCurrent & 0x0f) << 4;
				break;
				
			case 2:
				objResult[j++] |= intCurrent >>2;
				objResult[j] = (intCurrent & 0x03) << 6;
				break;
				
			case 3:
				objResult[j++] |= intCurrent;
				break;
		}
		i++;
	}
	
	// mop things up if we ended on a boundary
	k = j;
	if (intCurrent == '=') {
		switch (i % 4) {
			case 1:
				// Invalid state
				free(objResult);
				return nil;
				
			case 2:
				k++;
				// flow through
			case 3:
				objResult[k] = 0;
		}
	}
	
	// Cleanup and setup the return NSData
    // ARC or no?
    //NSData * objData = [[[NSData alloc] initWithBytes:objResult length:j] autorelease];
    NSData * objData = [[NSData alloc] initWithBytes:objResult length:j];
	free(objResult);
	return objData;
}

// MD5 Methods

+ (NSData *)calculateHMACMD5WithKey:(NSString *)key andData:(NSString *)data {
	const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
	const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
	
	unsigned char cHMAC[CC_MD5_DIGEST_LENGTH];
	
	CCHmac(kCCHmacAlgMD5, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
	
	NSData *hmacmd5 = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];

    // ARC or no?
	//return [hmacmd5 autorelease];
    return hmacmd5;
}

+ (NSString *)b64_hmac_md5:(NSString *)password realm:(NSString *)realm {
	
	NSData *hashedData = [PwdHash calculateHMACMD5WithKey:password andData:realm];
	NSCharacterSet *charsToRemove = [NSCharacterSet characterSetWithCharactersInString:@"="];
	NSString *hashedPwd = [[PwdHash encodeBase64WithData:hashedData] stringByTrimmingCharactersInSet:charsToRemove];
	
	return hashedPwd;
}

+ (NSString *)hex_hmac_md5:(NSString *)password realm:(NSString *)realm {
    
	NSData *hashedData = [PwdHash calculateHMACMD5WithKey:password andData:realm];
    
	NSCharacterSet *charsToRemove = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
	NSString *hashedPwd = [[[hashedData description]
							stringByTrimmingCharactersInSet:charsToRemove]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	return hashedPwd;
}

// PwdHash Methods

- (id)initWithPasswordAndURL:(NSString *)thePassword url:(NSString *)theURL {
    self = [super init];
	if (self) {
		self.pwdString = thePassword;
		self.urlString = theURL;
	}
	return self;
}

+ (PwdHash *)PwdHashWithPasswordAndURL:(NSString *)password pwd:(NSString *)url {
	PwdHash *pwdHash = [[PwdHash alloc] initWithPasswordAndURL:password 
                                                           url:url];
    // ARC or not?
	//return [PwdHash autorelease];
	return pwdHash;
}

+ (NSString *)extractDomainFromURL:(NSString *)theURL {
	NSRegularExpression *protocolRegex = [NSRegularExpression regularExpressionWithPattern:@"^https?://"
																				   options:0
																					 error:NULL];
	NSRegularExpression *pathRegex = [NSRegularExpression regularExpressionWithPattern:@"/.*"
																			   options:0
																				 error:NULL];
	NSString *baseDomain = NULL;
	baseDomain = [protocolRegex stringByReplacingMatchesInString:theURL
														 options:0
														   range:NSMakeRange(0, [theURL length])
													withTemplate:@""];
	baseDomain = [pathRegex stringByReplacingMatchesInString:baseDomain
													 options:0
													   range:NSMakeRange(0, [baseDomain length])
												withTemplate:@""];
	
	NSString *twoPartTLDRegex = @"(?:ab.ca|ac.ac|ac.at|ac.be|ac.cn|ac.il|ac.in|ac.jp|ac.kr|ac.nz|ac.th|ac.uk|ac.za|adm.br|adv.br|agro.pl|ah.cn|aid.pl|alt.za|am.br|arq.br|art.br|arts.ro|asn.au|asso.fr|asso.mc|atm.pl|auto.pl|bbs.tr|bc.ca|bio.br|biz.pl|bj.cn|br.com|cn.com|cng.br|cnt.br|co.ac|co.at|co.il|co.in|co.jp|co.kr|co.nz|co.th|co.uk|co.za|com.au|com.br|com.cn|com.ec|com.fr|com.hk|com.mm|com.mx|com.pl|com.ro|com.ru|com.sg|com.tr|com.tw|cq.cn|cri.nz|de.com|ecn.br|edu.au|edu.cn|edu.hk|edu.mm|edu.mx|edu.pl|edu.tr|edu.za|eng.br|ernet.in|esp.br|etc.br|eti.br|eu.com|eu.lv|fin.ec|firm.ro|fm.br|fot.br|fst.br|g12.br|gb.com|gb.net|gd.cn|gen.nz|gmina.pl|go.jp|go.kr|go.th|gob.mx|gov.br|gov.cn|gov.ec|gov.il|gov.in|gov.mm|gov.mx|gov.sg|gov.tr|gov.za|govt.nz|gs.cn|gsm.pl|gv.ac|gv.at|gx.cn|gz.cn|hb.cn|he.cn|hi.cn|hk.cn|hl.cn|hn.cn|hu.com|idv.tw|ind.br|inf.br|info.pl|info.ro|iwi.nz|jl.cn|jor.br|jpn.com|js.cn|k12.il|k12.tr|lel.br|ln.cn|ltd.uk|mail.pl|maori.nz|mb.ca|me.uk|med.br|med.ec|media.pl|mi.th|miasta.pl|mil.br|mil.ec|mil.nz|mil.pl|mil.tr|mil.za|mo.cn|muni.il|nb.ca|ne.jp|ne.kr|net.au|net.br|net.cn|net.ec|net.hk|net.il|net.in|net.mm|net.mx|net.nz|net.pl|net.ru|net.sg|net.th|net.tr|net.tw|net.za|nf.ca|ngo.za|nm.cn|nm.kr|no.com|nom.br|nom.pl|nom.ro|nom.za|ns.ca|nt.ca|nt.ro|ntr.br|nx.cn|odo.br|on.ca|or.ac|or.at|or.jp|or.kr|or.th|org.au|org.br|org.cn|org.ec|org.hk|org.il|org.mm|org.mx|org.nz|org.pl|org.ro|org.ru|org.sg|org.tr|org.tw|org.uk|org.za|pc.pl|pe.ca|plc.uk|ppg.br|presse.fr|priv.pl|pro.br|psc.br|psi.br|qc.ca|qc.com|qh.cn|re.kr|realestate.pl|rec.br|rec.ro|rel.pl|res.in|ru.com|sa.com|sc.cn|school.nz|school.za|se.com|se.net|sh.cn|shop.pl|sk.ca|sklep.pl|slg.br|sn.cn|sos.pl|store.ro|targi.pl|tj.cn|tm.fr|tm.mc|tm.pl|tm.ro|tm.za|tmp.br|tourism.pl|travel.pl|tur.br|turystyka.pl|tv.br|tw.cn|uk.co|uk.com|uk.net|us.com|uy.com|vet.br|web.za|web.com|www.ro|xj.cn|xz.cn|yk.ca|yn.cn|za.com)$";
	if ([PwdHash stringByMatching:baseDomain toRegexPattern:twoPartTLDRegex]) {
		baseDomain = [PwdHash stringByMatching:baseDomain toRegexPattern:@"[^.]+\\.[^.]+\\.[^.]+$"];
	} else {
		baseDomain = [PwdHash stringByMatching:baseDomain toRegexPattern:@"[^.]+\\.[^.]+$"];
	}
	if (![baseDomain length]) {
		baseDomain = theURL;
	}
	
	return baseDomain;
}

+ (NSString *)stringByMatching:(NSString *)string toRegexPattern:(NSString *)regexPattern {
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern
																		   options:NSRegularExpressionCaseInsensitive
																			 error:NULL];
	NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:string
														 options:0
														   range:NSMakeRange(0, [string length])];
	NSString *substringForFirstMatch = NULL;
	if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
		substringForFirstMatch = [string substringWithRange:rangeOfFirstMatch];
	}
	
	return substringForFirstMatch;
}

+ (NSString *)stringByMatchingCaseSensitive:(NSString *)string toRegexPattern:(NSString *)regexPattern {
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern
																		   options:0
																			 error:NULL];
	NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:string
														 options:0
														   range:NSMakeRange(0, [string length])];
	NSString *substringForFirstMatch = NULL;
	if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
		substringForFirstMatch = [string substringWithRange:rangeOfFirstMatch];
	}
	
	return substringForFirstMatch;
}

- (NSUInteger)nextExtra {
	NSUInteger theNextExtra = 0;
	if ([extras length]) {
		theNextExtra = [extras characterAtIndex:0];
		extras = [extras substringFromIndex:1];
	}
	return theNextExtra;
}

- (NSString *)nextExtraChar {
	return [NSString stringWithFormat:@"%c", [self nextExtra]];
}

- (void)rotate:(NSUInteger)amount {
	while (amount--) {
		result = [[result substringFromIndex:1] stringByAppendingString:[result substringToIndex:1]];
	}
}

+ (NSUInteger)between:(NSUInteger)min interval:(NSUInteger)interval offset:(NSUInteger)offset {
	return min + offset % interval;
}

- (NSString *)nextBetween:(NSString *)base interval:(NSUInteger)interval {
	NSUInteger theNextBetween = [PwdHash between:[base characterAtIndex:0]
												 interval:interval
												   offset:[self nextExtra]];
	return [NSString stringWithFormat:@"%c", theNextBetween];
}

- (BOOL)contains:(NSString *)regexPattern {
	return [[PwdHash stringByMatchingCaseSensitive:result toRegexPattern:regexPattern] length];
}

- (BOOL)nonalphanumeric {
	if([[PwdHash stringByMatching:pwdString toRegexPattern:@"\\W"] length]) {
		return 1;
	} else {
		return 0;
	}
}

- (NSString *)applyConstraints:(NSString *)theString size:(NSUInteger)theSize {
	NSUInteger startingSize = theSize - 4;
	result = [theString substringToIndex:startingSize];
	extras = [theString substringFromIndex:startingSize];
	
	if ([self contains:@"[A-Z]"]) {
		result = [result stringByAppendingString:[self nextExtraChar]];
	} else {
		result = [result stringByAppendingString:[self nextBetween:@"A" interval:26]];
	}
    
	if ([self contains:@"[a-z]"]) {
		result = [result stringByAppendingString:[self nextExtraChar]];
	} else {
		result = [result stringByAppendingString:[self nextBetween:@"a" interval:26]];
	}
	
	if ([self contains:@"[0-9]"]) {
		result = [result stringByAppendingString:[self nextExtraChar]];
	} else {
		result = [result stringByAppendingString:[self nextBetween:@"0" interval:10]];
	}
	
	if ([self contains:@"\\W"] && [self nonalphanumeric]) {
		result = [result stringByAppendingString:[self nextExtraChar]];
	} else {
		result = [result stringByAppendingString:@"+"];
	}
	
	while ([self contains:@"\\W"] && ![self nonalphanumeric]) {
		NSRegularExpression *nonwhiteRegex = [NSRegularExpression regularExpressionWithPattern:@"\\W"
																					   options:NSRegularExpressionCaseInsensitive
																						 error:NULL];
		NSRange rangeOfFirstMatch = [nonwhiteRegex rangeOfFirstMatchInString:result
																	 options:0
																	   range:NSMakeRange(0, [result length])];
		result = [result stringByReplacingCharactersInRange:rangeOfFirstMatch
												 withString:[self nextBetween:@"A" interval:26]];
	}
	
	[self rotate:[self nextExtra]];
	
	return result;
}

- (NSString *)getHashedPassword {
	NSString *domain = @"";
	NSString *hash = @"";
	NSString *theResult = @"";
	
	if ([urlString length]) {
		domain = [PwdHash extractDomainFromURL:urlString];
	}
	
	if ([pwdString length] && [domain length]) {
		hash = [PwdHash b64_hmac_md5:pwdString realm:domain];
	}
	
	if ([hash length]) {
		NSUInteger size = [pwdString length] + 2;
		if (size >= 4) {
			theResult = [self applyConstraints:hash size:size];
		}
	}
    
	return theResult;
}

@end
