//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+rd_wid.h"
#import "Reader.pch"
#import "NSAttributedString+rd_wid.h"


@implementation NSString (rd_wid)
#pragma mark - trim

- (NSString *)trimmingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimmingWhitespaceAndNewlines
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - url

- (NSString *)urlEncode
{
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL,
            (__bridge CFStringRef) self, NULL, (CFStringRef) @"!*'\"();:@&=+$,/?%#[]% ",
            CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)urlDecode
{
    return [self urlDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding
{
    return (__bridge_transfer NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
            (__bridge CFStringRef) self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSDictionary *)urlParameters
{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];

        NSString *key = [kv objectAtIndexSafely:0];
        NSString *val = [[kv objectAtIndexSafely:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        if (key.length > 0) {
            params[key] = (val ?: @"");
        }
    }
    return params;
}

#pragma mark - base64

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedString];
}

- (NSString *)base64DecodedString
{
    NSData *data = [NSData base64DecodedDataForString:self];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSData *)base64DecodedData
{
    return [NSData base64DecodedDataForString:self];
}

#pragma mark - Encrypt

- (NSString *)encryptedWithAESUsingKey:(NSString *)key andIV:(NSData *)iv
{
    NSData *encrypted = [[self dataUsingEncoding:NSUTF8StringEncoding] encryptedWithAESUsingKey:key andIV:iv];
    NSString *encryptedString = [encrypted base64EncodedString];

    return encryptedString;
}

- (NSString *)decryptedWithAESUsingKey:(NSString *)key andIV:(NSData *)iv
{
    NSData *decrypted = [[NSData base64DecodedDataForString:self] decryptedWithAESUsingKey:key andIV:iv];
    NSString *decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];

    return decryptedString;
}

- (NSString *)encryptedWith3DESUsingKey:(NSString *)key andIV:(NSData *)iv
{
    NSData *encrypted = [[self dataUsingEncoding:NSUTF8StringEncoding] encryptedWith3DESUsingKey:key andIV:iv];
    NSString *encryptedString = [encrypted base64EncodedString];

    return encryptedString;
}

- (NSString *)decryptedWith3DESUsingKey:(NSString *)key andIV:(NSData *)iv
{
    NSData *decrypted = [[NSData base64DecodedDataForString:self] decryptedWith3DESUsingKey:key andIV:iv];
    NSString *decryptedString = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];

    return decryptedString;
}

#pragma mark - hash

- (NSString *)md5String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5String];
}

- (NSString *)sha1String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1String];
}

- (NSString *)sha256String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256String];
}

- (NSString *)sha512String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha512String];
}

#pragma mark - JSONObject

- (id)JSONObject
{
    return [self JSONObjectWithEncoding:NSUTF8StringEncoding];
}

- (id)JSONObjectWithEncoding:(NSStringEncoding)encoding
{
    NSData *data = [self dataUsingEncoding:encoding];
    if (!data) {
        return nil;
    }

    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"ERROR: failed to parse json : %@\n%@", error, self);
    }

    return obj;
}

#pragma mark - scan

- (BOOL)isPureInt
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;

    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;

    return [scan scanFloat:&val] && [scan isAtEnd];
}

+ (NSString *)stringFromIndex:(NSInteger)index
{
    char character = 'A' + index;

    return [NSString stringWithFormat:@"%c", character];
}

#pragma mark - sizeWithFont

- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    return [self sizeWithFont:font size:CGSizeMake(maxWidth, CGFLOAT_MAX)];
}

- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size
{
    if (self.length == 0 || !font) {
        return CGSizeZero;
    }

    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGSize boundingBox = [self boundingRectWithSize:size
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes context:nil].size;
    return CGSizeMake(ceilf(boundingBox.width), ceilf(boundingBox.height));
}

- (CGSize)sizeWithFont:(UIFont *)font
             lineSpace:(CGFloat)lineSpace
              maxWidth:(CGFloat)maxWidth
{
    return [self sizeWithFont:font lineSpace:lineSpace maxSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
}

- (CGSize)sizeWithFont:(UIFont *)font
             lineSpace:(CGFloat)lineSpace
               maxSize:(CGSize)maxSize
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    return [str sizewithFont:font lineSpace:lineSpace maxSize:maxSize];
}

#pragma mark - AttributedString

- (NSMutableAttributedString *)strWithFont:(UIFont *)font
                                 lineSpace:(CGFloat)lineSpace
                                  maxWidth:(CGFloat)maxWidth
{
    return [self strWithFont:font lineSpace:lineSpace maxSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
}

- (NSMutableAttributedString *)strWithFont:(UIFont *)font
                                 lineSpace:(CGFloat)lineSpace
                                   maxSize:(CGSize)maxSize
{
    return [NSMutableAttributedString strWithFont:font lineSpace:lineSpace string:self maxSize:maxSize];
}

- (NSMutableAttributedString *)strWithFont:(UIFont *)font
                                 lineSpace:(CGFloat)lineSpace
{
    return [NSMutableAttributedString strWithFont:font lineSpace:lineSpace string:self];
}

@end
