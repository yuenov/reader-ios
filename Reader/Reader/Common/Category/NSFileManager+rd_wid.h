//
//  NSFileManager+rd_wid.h
//  Reader
//
//  Created by yuenov on 2019/10/26.
//  Copyright © 2019 yuenov. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (rd_wid)
+ (NSURL *)documentsURL;

+ (NSString *)documentsPath;

+ (NSURL *)libraryURL;

+ (NSString *)libraryPath;

+ (NSURL *)cachesURL;

+ (NSString *)cachesPath;

+ (BOOL)addSkipBackupAttributeToPath:(NSString *)path;

+ (double)availableDiskSpace;

+ (double)totalDiskSpace;
@end

NS_ASSUME_NONNULL_END
