//
//  RDMarcos.pch
//  Reader
//
//  Created by yuenov on 2019/10/24.
//  Copyright © 2019 yuenov. All rights reserved.
//
// singleton
#define DEF_SINGLETON(className) \
\
+ (className *)sharedInstance;

#define IMP_SINGLETON(className) \
\
+ (className *)sharedInstance { \
static className *sharedInstance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[self alloc] init]; \
}); \
return sharedInstance; \
}

#define SYSTEM_VERSION_EQUAL_TO(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// check
#define MakeNSNumber(__obj)                        [(__obj)isKindOfClass :[NSNumber class]] ? (__obj) : nil
#define MakeNSString(__obj)                        [(__obj)isKindOfClass :[NSString class]] ? (__obj) : nil
#define MakeNSStringNoNull(__obj)                  [(__obj)isKindOfClass :[NSString class]] ? (__obj) : @""
#define MakeNSDictionary(__obj)                    [(__obj)isKindOfClass :[NSDictionary class]] ? (__obj) : nil
#define MakeNSArray(__obj)                         [(__obj)isKindOfClass :[NSArray class]] ? (__obj) : nil

#define CheckValidString(__OBJ)          ([(__OBJ) isKindOfClass:[NSString class]])
#define CheckValidData(__OBJ)            ([(__OBJ) isKindOfClass:[NSData class]])
#define CheckValidDictionary(__OBJ)      ([(__OBJ) isKindOfClass:[NSDictionary class]])
#define CheckValidArray(__OBJ)           ([(__OBJ) isKindOfClass:[NSArray class]])
#define CheckValidNumber(__OBJ)          ([(__OBJ) isKindOfClass:[NSNumber class]])

// screen
#define ScreenWidth                             [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                            [[UIScreen mainScreen] bounds].size.height
#define ScreenSize                              [[UIScreen mainScreen] bounds].size


// path
#define PATH_APP_HOME       NSHomeDirectory()
#define PATH_TEMP           NSTemporaryDirectory()
#define PATH_BUNDLE         [[NSBundle mainBundle] bundlePath]
#define PATH_CACHES         [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define PATH_LIBRARY        [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
#define PATH_DOCUMENT       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define  adjustsContentInsets(scrollView)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
}\
_Pragma("clang diagnostic pop") \
} while (0)



#define kAppID      @"1505061125"
