//
//  RDCharpterDataManager.m
//  Reader
//
//  Created by yuenov on 2019/12/29.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDCharpterDataManager.h"
#import "RDDatabaseManager.h"
#import "RDCharpterModel.h"
#import "RDCharpterModel+WCTTableCoding.h"
@implementation RDCharpterDataManager


+(NSArray *)getBriefCharptersWithBookId:(NSInteger)bookid{
    return [[RDDatabaseManager sharedInstance].database getObjectsOnResults:{RDCharpterModel.charpterId,RDCharpterModel.name,RDCharpterModel.bookId} fromTable:kCharpterTable where:RDCharpterModel.bookId.is(bookid) orderBy:RDCharpterModel.charpterId.order(WCTOrderedAscending)];
}


+(BOOL)isExsitWithBookId:(NSInteger)bookid
{
    RDCharpterModel *model = [[RDDatabaseManager sharedInstance].database getOneObjectOnResults:{RDCharpterModel.primaryId} fromTable:kCharpterTable where:RDCharpterModel.bookId.is(bookid)];
    return model?YES:NO;
}

+(BOOL)isExsitWithBookId:(NSInteger)bookid charpterId:(NSInteger)charpterId
{
    RDCharpterModel *model = [[RDDatabaseManager sharedInstance].database getOneObjectOnResults:{RDCharpterModel.primaryId} fromTable:kCharpterTable where:RDCharpterModel.bookId.is(bookid)&&RDCharpterModel.charpterId.is(charpterId)];
    return model?YES:NO;
}

+(RDCharpterModel *)getCharpterWithBookId:(NSInteger)bookId charpterId:(NSInteger)charpterId
{
    return [[RDDatabaseManager sharedInstance].database getOneObjectOfClass:RDCharpterModel.class fromTable:kCharpterTable where:RDCharpterModel.bookId.is(bookId)&&RDCharpterModel.charpterId.is(charpterId)];
}

+(NSInteger)getFirstCharpterIdWirhBookId:(NSInteger)bookId
{
    return [[[RDDatabaseManager sharedInstance].database getOneValueOnResult:RDCharpterModel.charpterId.min() fromTable:kCharpterTable where:RDCharpterModel.bookId.is(bookId)] integerValue];
}
+(void)updateCharpterContentWithModel:(RDCharpterModel *)model
{
    [[RDDatabaseManager sharedInstance].database updateRowsInTable:kCharpterTable onProperty:RDCharpterModel.content withObject:model where:RDCharpterModel.bookId.is(model.bookId)&&RDCharpterModel.charpterId.is(model.charpterId)];
}
+(void)insertObjectWithCharpters:(RDCharpterModel *)charpter
{
    [[RDDatabaseManager sharedInstance].database insertOrReplaceObject:charpter into:kCharpterTable];
}
+(void)insertObjectsWithCharpters:(NSArray *)charpters
{
    if (charpters.count == 0) {
        return;
    }
    [[RDDatabaseManager sharedInstance].database runTransaction:^BOOL{
        for (RDCharpterModel *charpterModel in charpters) {
            RDCharpterModel *model = [self getCharpterWithBookId:charpterModel.bookId charpterId:charpterModel.charpterId];
            if (model) {
                if (charpterModel.content.length>0) {
                    [self updateCharpterContentWithModel:charpterModel];
                }
            }
            else{
                [self insertObjectWithCharpters:charpterModel];
            }
        }
        return YES;
    }];
}
+(NSArray *)getAllNoContentCharpterWithBookId:(NSInteger)bookid
{
   return [[RDDatabaseManager sharedInstance].database getObjectsOfClass:RDCharpterModel.class fromTable:kCharpterTable where:RDCharpterModel.bookId.is(bookid)&&RDCharpterModel.content.isNull()];
}

+(RDCharpterModel *)getLastChapterWithBookId:(NSInteger)bookId
{
    return [[RDDatabaseManager sharedInstance].database getOneObjectOnResults:{RDCharpterModel.charpterId.max(),RDCharpterModel.bookId} fromTable:kCharpterTable where:RDCharpterModel.bookId.is(bookId)];
}

+(void)deleteAllCharpterWithBookId:(NSInteger)bookid
{
    [[RDDatabaseManager sharedInstance].database deleteObjectsFromTable:kCharpterTable where:RDCharpterModel.bookId.is(bookid)];
}
@end
