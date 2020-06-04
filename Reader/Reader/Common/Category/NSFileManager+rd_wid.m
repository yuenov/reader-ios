//
//  NSFileManager+rd_wid.m
//  Reader
//
//  Created by yuenov on 2019/10/26.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "NSFileManager+rd_wid.h"

#import <UIKit/UIKit.h>
#import <sys/xattr.h>

@implementation NSFileManager (rd_wid)

+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory
{
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)pathForDirectory:(NSSearchPathDirectory)directory
{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

+ (NSURL *)documentsURL
{
    return [self URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)documentsPath
{
    return [self pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)libraryURL
{
    return [self URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)libraryPath
{
    return [self pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)cachesURL
{
    return [self URLForDirectory:NSCachesDirectory];
}

+ (NSString *)cachesPath
{
    return [self pathForDirectory:NSCachesDirectory];
}

+ (BOOL)addSkipBackupAttributeToPath:(NSString *)path
{
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        return NO;
    }

    NSURL *URL = [NSURL fileURLWithPath:path isDirectory:isDirectory];
    return [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];

//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.1) {
//        return [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
//    }
//    else {
//        const char *filePath = [[URL path] fileSystemRepresentation];
//        u_int8_t attrValue = 1;
//        return setxattr(filePath, "com.apple.MobileBackup", &attrValue, sizeof(attrValue), 0, 0) == 0;
//    }
}

+ (double)availableDiskSpace
{
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.documentsPath error:nil];

    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double) 0x100000;
}

+ (double)totalDiskSpace
{
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.documentsPath error:nil];

    return [attributes[NSFileSystemSize] unsignedLongLongValue] / (double) 0x100000;
}


#define kDiskTotalSize @"total"
#define kDiskFreeSize @"free"
#define kDiskUsedSize @"used"
#define kDiskAppSize @"appSize"

+ (NSDictionary *)diskUsagesInfos
{
    NSString *app = NSHomeDirectory();
    NSError *__autoreleasing error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *sysdic = [fm attributesOfFileSystemForPath:app error:&error];
    // OS fie system
    unsigned long long free = [[sysdic objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    unsigned long long total = [[sysdic objectForKey:NSFileSystemSize] unsignedLongLongValue];
    // map app folder
    NSArray *subfiles = [fm subpathsOfDirectoryAtPath:app error:&error];
    NSEnumerator *iter = [subfiles objectEnumerator];
    NSString *subone = nil;
    unsigned long long apptotal = 0;

    while (subone = [iter nextObject]) {
        //if ([[[subone pathComponents] lastObject] rangeOfString:@".vec"].length != 0) {
        unsigned long long sz = [[[fm attributesOfItemAtPath:[app stringByAppendingPathComponent:subone] error:&error] objectForKey:NSFileSize] unsignedLongLongValue];
        apptotal += sz;
        //}
    }

    NSDictionary *infos = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [NSNumber numberWithUnsignedLongLong:total], kDiskTotalSize,
                                                [NSNumber numberWithUnsignedLongLong:free], kDiskFreeSize,
                                                [NSNumber numberWithUnsignedLongLong:total - free], kDiskUsedSize,
                                                [NSNumber numberWithUnsignedLongLong:apptotal], kDiskAppSize,
                                                nil];

    return infos;
}
@end
