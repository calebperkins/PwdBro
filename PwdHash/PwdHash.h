//
//  PwdHash.h
//  PwdHash
//
//  Created by Nathaniel Nutter on 9/16/11.
//  Copyright 2011 Nathaniel Nutter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PwdHash : NSObject {
	
	NSString *urlString;
	NSString *pwdString;
	NSString *extras;
	NSString *result;
    
}

@property (retain) NSString* pwdString;
@property (retain) NSString* urlString;

+ (NSString*)getHashedPasswordWithPasswordAndURL:(NSString*)thePassword
                                             url:(NSString*)theURL;

- (id) initWithPasswordAndURL:(NSString *)thePassword url:(NSString *)theURL;
+ (PwdHash *)PwdHashWithPasswordAndURL:(NSString *)thePassword pwd:(NSString *)theURL;
+ (NSString *)extractDomainFromURL:(NSString *)theURL;
- (NSString *)applyConstraints:(NSString *)theString size:(NSUInteger)theSize;
- (NSString *)getHashedPassword;
+ (NSString *)stringByMatching:(NSString *) string toRegexPattern:(NSString *)regexPattern;

// Base64 Methods
+ (NSData *)decodeBase64WithString:(NSString *)strBase64;
+ (NSString *)encodeBase64WithData:(NSData *)objData;
+ (NSString *)encodeBase64WithString:(NSString *)strData;

// MD5 Methods
+ (NSData *)calculateHMACMD5WithKey:(NSString *)key andData:(NSString *)data;
+ (NSString *)b64_hmac_md5:(NSString *)password realm:(NSString *)realm;
+ (NSString *)hex_hmac_md5:(NSString *)password realm:(NSString *)realm;

@end
