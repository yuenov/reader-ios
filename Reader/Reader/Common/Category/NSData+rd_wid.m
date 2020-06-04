//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import "NSData+rd_wid.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import <zlib.h>
NSString* const GzipErrorDomain = @"org.skyfox.Gzip";

@implementation NSData (rd_wid)
#pragma mark - base64

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    if (![self length]) return nil;
    NSString *encoded = nil;
    switch (wrapWidth) {
        case 64:
            return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        case 76:
            return [self base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
        default:
            encoded = [self base64EncodedStringWithOptions:(NSDataBase64EncodingOptions) 0];
    }
    if (!wrapWidth || wrapWidth >= [encoded length]) {
        return encoded;
    }
    wrapWidth = (wrapWidth / 4) * 4;
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < [encoded length]; i += wrapWidth) {
        if (i + wrapWidth >= [encoded length]) {
            [result appendString:[encoded substringFromIndex:i]];
            break;
        }
        [result appendString:[encoded substringWithRange:NSMakeRange(i, wrapWidth)]];
        [result appendString:@"\r\n"];
    }
    return result;
}

- (NSString *)base64EncodedString
{
    return [self base64EncodedStringWithWrapWidth:0];
}

+ (NSData *)base64DecodedDataForString:(NSString *)string
{
    if (![string length]) return nil;
    NSData *decoded = [[self alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [decoded length] ? decoded : nil;
}

#pragma mark - Encrypt

- (NSData *)encryptedWithAESUsingKey:(NSString *)key andIV:(NSData *)iv
{

    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];

    size_t dataMoved;
    NSMutableData *encryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSizeAES128];

    CCCryptorStatus status = CCCrypt(kCCEncrypt,                    // kCCEncrypt or kCCDecrypt
            kCCAlgorithmAES128,
            kCCOptionPKCS7Padding,         // Padding option for CBC Mode
            keyData.bytes,
            keyData.length,
            iv.bytes,
            self.bytes,
            self.length,
            encryptedData.mutableBytes,    // encrypted data out
            encryptedData.length,
            &dataMoved);                   // total data moved

    if (status == kCCSuccess) {
        encryptedData.length = dataMoved;
        return encryptedData;
    }

    return nil;

}

- (NSData *)decryptedWithAESUsingKey:(NSString *)key andIV:(NSData *)iv
{

    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];

    size_t dataMoved;
    NSMutableData *decryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSizeAES128];

    CCCryptorStatus result = CCCrypt(kCCDecrypt,                    // kCCEncrypt or kCCDecrypt
            kCCAlgorithmAES128,
            kCCOptionPKCS7Padding,         // Padding option for CBC Mode
            keyData.bytes,
            keyData.length,
            iv.bytes,
            self.bytes,
            self.length,
            decryptedData.mutableBytes,    // encrypted data out
            decryptedData.length,
            &dataMoved);                   // total data moved

    if (result == kCCSuccess) {
        decryptedData.length = dataMoved;
        return decryptedData;
    }

    return nil;

}

- (NSData *)encryptedWith3DESUsingKey:(NSString *)key andIV:(NSData *)iv
{

    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];

    size_t dataMoved;
    NSMutableData *encryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSize3DES];

    CCCryptorStatus result = CCCrypt(kCCEncrypt,                    // kCCEncrypt or kCCDecrypt
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding,         // Padding option for CBC Mode
            keyData.bytes,
            keyData.length,
            iv.bytes,
            self.bytes,
            self.length,
            encryptedData.mutableBytes,    // encrypted data out
            encryptedData.length,
            &dataMoved);                   // total data moved

    if (result == kCCSuccess) {
        encryptedData.length = dataMoved;
        return encryptedData;
    }

    return nil;

}

- (NSData *)decryptedWith3DESUsingKey:(NSString *)key andIV:(NSData *)iv
{

    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];

    size_t dataMoved;
    NSMutableData *decryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSize3DES];

    CCCryptorStatus result = CCCrypt(kCCDecrypt,                    // kCCEncrypt or kCCDecrypt
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding,         // Padding option for CBC Mode
            keyData.bytes,
            keyData.length,
            iv.bytes,
            self.bytes,
            self.length,
            decryptedData.mutableBytes,    // encrypted data out
            decryptedData.length,
            &dataMoved);                   // total data moved

    if (result == kCCSuccess) {
        decryptedData.length = dataMoved;
        return decryptedData;
    }

    return nil;

}

#pragma mark - gzip

- (NSData *)gzip:(NSError *__autoreleasing *)error
{
    /* stream setup */
    z_stream stream;
    memset(&stream, 0, sizeof(stream));
    /* 31 below means generate gzip (16) with a window size of 15 (16 + 15) */
    int iResult = deflateInit2(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY);
    if (iResult != Z_OK) {
        if (error)
            *error = [NSError errorWithDomain:GzipErrorDomain code:iResult userInfo:nil];
        return nil;
    }
    /* input buffer setup */
    stream.next_in = (Bytef *) self.bytes;
    stream.avail_in = (uint)self.length;
    /* output buffer setup */
    uLong nMaxOutputBytes = deflateBound(&stream, stream.avail_in);
    NSMutableData *zipOutput = [NSMutableData dataWithLength:nMaxOutputBytes];
    stream.next_out = (Bytef *) zipOutput.bytes;
    stream.avail_out = (uint)zipOutput.length;
    /* compress */
    iResult = deflate(&stream, Z_FINISH);
    if (iResult != Z_STREAM_END) {
        if (error)
            *error = [NSError errorWithDomain:GzipErrorDomain code:iResult userInfo:nil];
        zipOutput = nil;
    }
    zipOutput.length = zipOutput.length - stream.avail_out;
    deflateEnd(&stream);
    return zipOutput;
}

#pragma mark - hash

- (NSString *)md5String
{
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (CC_LONG)[self length], bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)sha1String
{
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([self bytes], (CC_LONG)[self length], bytes);
    return [self stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha256String
{
    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([self bytes], (CC_LONG)[self length], bytes);
    return [self stringFromBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)sha512String
{
    unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512([self bytes], (CC_LONG)[self length], bytes);
    return [self stringFromBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}

#pragma mark - other

- (NSString *)UTF8String
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (id)JSONObject
{
    if (self.length == 0) {
        return nil;
    }

    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:self options:0 error:&error];
    if (error) {
        NSLog(@"ERROR: failed to parse json : %@\n%@", error, [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding]);
    }

    return obj;
}
@end
