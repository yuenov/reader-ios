//
//  RDHistoryRecordManager.m
//  Reader
//
//  Created by yuenov on 2020/3/2.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDHistoryRecordManager.h"
#import "RDBookDetailModel.h"
#import "RDBookDetailModel+WCTTableCoding.h"
#import "RDDatabaseManager.h"
@implementation RDHistoryRecordManager
+(void)insertOrReplaceModel:(RDBookDetailModel *)model
{
    model.readTime = [NSDate date].timeIntervalSince1970;
    [[RDDatabaseManager sharedInstance].database insertOrReplaceObject:model into:kHistoryRecordTable];
}

+(NSInteger)getHisoryCount
{
   return  [[[RDDatabaseManager sharedInstance].database getOneValueOnResult:RDBookDetailModel.AnyProperty.count() fromTable:kHistoryRecordTable] integerValue];
}

+(NSArray *)getAllHistory
{
   return [[RDDatabaseManager sharedInstance].database getObjectsOfClass:RDBookDetailModel.class fromTable:kHistoryRecordTable  orderBy:RDBookDetailModel.readTime.order(WCTOrderedDescending)];
}

+(void)deleteHistoryWithBookId:(NSInteger )bookId
{
    [[RDDatabaseManager sharedInstance].database deleteObjectsFromTable:kHistoryRecordTable where:RDBookDetailModel.bookId.is(bookId)];
}

+(void)deleteAllHistory
{
    [[RDDatabaseManager sharedInstance].database deleteAllObjectsFromTable:kHistoryRecordTable];
}
@end
