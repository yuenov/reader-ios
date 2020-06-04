//
//  RDDatabaseManager.h
//  Reader
//
//  Created by yuenov on 2019/12/29.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>
#define kBookDatabase @"book"
#define kCharpterTable @"chapter"
#define kReadRecordTable @"read"
#define kHistoryRecordTable @"history"

@interface RDDatabaseManager : NSObject
@property (nonatomic,strong) WCTDatabase *database;

+ (RDDatabaseManager *)sharedInstance;
@end

