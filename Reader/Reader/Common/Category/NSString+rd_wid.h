//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@class UIFont;

@interface NSString (rd_wid)
// trim
- (NSString *)trimmingWhitespace;
- (NSString *)trimmingWhitespaceAndNewlines;

// url
- (NSString *)urlEncode;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)urlDecode;
- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding;
- (NSDictionary *)urlParameters;

// base64
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

// Encrypt
- (NSString*)encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSString*)decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSString*)encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSString*)decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;

// hash
- (NSString *)md5String;
- (NSString *)sha1String;
- (NSString *)sha256String;
- (NSString *)sha512String;

// JSON
- (id)JSONObject;
- (id)JSONObjectWithEncoding:(NSStringEncoding)encoding;

// scan
- (BOOL)isPureInt;
- (BOOL)isPureFloat;
+ (NSString *)stringFromIndex:(NSInteger)index;

// 计算文本size
- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size;
- (CGSize)sizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxWidth:(CGFloat)maxWidth;
- (CGSize)sizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxSize:(CGSize)maxSize;

// 根据字体及行间距获取AttributedString
- (NSMutableAttributedString *)strWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace;
- (NSMutableAttributedString *)strWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxWidth:(CGFloat)maxWidth;
- (NSMutableAttributedString *)strWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace maxSize:(CGSize)maxSize;

@end
