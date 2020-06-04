//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (rd_wid)
// base64
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
+ (NSData *)base64DecodedDataForString:(NSString *)string;

// encrypt
- (NSData *)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSData *)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSData *)encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSData *)decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;

// gzip
- (NSData *)gzip:(NSError *__autoreleasing *)error;

// hash
- (NSString *)md5String;
- (NSString *)sha1String;
- (NSString *)sha256String;
- (NSString *)sha512String;

// json
- (NSString *)UTF8String;

- (id)JSONObject;
@end
