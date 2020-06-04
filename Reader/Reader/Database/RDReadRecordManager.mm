//
//  RDReadRecordManager.m
//  Reader
//
//  Created by yuenov on 2020/1/31.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDReadRecordManager.h"
#import "RDBookDetailModel.h"
#import "RDBookDetailModel+WCTTableCoding.h"
#import "RDDatabaseManager.h"
#import "RDCharpterDataManager.h"
#import "RDCharpterModel.h"
@implementation RDReadRecordManager

+(void)insertOrReplaceModel:(RDBookDetailModel *)model
{
    model.readTime = [NSDate date].timeIntervalSince1970;
    [[RDDatabaseManager sharedInstance].database insertOrReplaceObject:model into:kReadRecordTable];
}

+(void)updateBookshelfState:(RDBookDetailModel *)model
{
    model.readTime = [NSDate date].timeIntervalSince1970;
    [[RDDatabaseManager sharedInstance].database updateRowsInTable:kReadRecordTable onProperties:{RDBookDetailModel.onBookshelf,RDBookDetailModel.readTime} withObject:model where:RDBookDetailModel.bookId.is(model.bookId)];
}

+(void)updateReadTime:(RDBookDetailModel *)model
{
    model.readTime = [NSDate date].timeIntervalSince1970;
    [[RDDatabaseManager sharedInstance].database updateRowsInTable:kReadRecordTable onProperties:RDBookDetailModel.readTime withObject:model where:RDBookDetailModel.bookId.is(model.bookId)];
}

+(RDBookDetailModel *)getReadRecordWithBookId:(NSInteger)bookid
{
    return [[RDDatabaseManager sharedInstance].database getOneObjectOfClass:RDBookDetailModel.class fromTable:kReadRecordTable where:RDBookDetailModel.bookId.is(bookid)];
}

+(NSArray *)getAllOnBookshelf
{
    return [[RDDatabaseManager sharedInstance].database getObjectsOfClass:RDBookDetailModel.class fromTable:kReadRecordTable where:RDBookDetailModel.onBookshelf.is(YES) orderBy:RDBookDetailModel.readTime.order(WCTOrderedDescending)];
}

+(NSArray *)getAllOnBookshelfPram
{
    NSMutableArray *array = [NSMutableArray array];
    [[RDDatabaseManager sharedInstance].database runTransaction:^BOOL{
        NSArray *books = [self getAllOnBookshelf];
        for (RDBookDetailModel *book in books) {
            RDCharpterModel *chapter = [RDCharpterDataManager getLastChapterWithBookId:book.bookId];
            if (!chapter || chapter.bookId==0) {
                continue;
            }
            [array addObjectSafely:chapter];
        }
        
        return YES;
    }];
    return array.copy;
}

+(void)removeBookFromBookShelfWithBookId:(NSInteger)bookid
{
    [[RDDatabaseManager sharedInstance].database deleteObjectsFromTable:kReadRecordTable where:RDBookDetailModel.bookId.is(bookid)];
}
+(void)updateOnBookselfUpdateWithBookId:(NSInteger)bookid update:(BOOL)update
{
    [[RDDatabaseManager sharedInstance].database updateRowsInTable:kReadRecordTable onProperty:RDBookDetailModel.bookUpdate withValue:@(update) where:RDBookDetailModel.bookId.is(bookid)];
}
@end
