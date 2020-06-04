//
//  RDBookDetailModel.mm
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBookDetailModel+WCTTableCoding.h"
#import "RDBookDetailModel.h"
#import <WCDB/WCDB.h>

@implementation RDBookDetailModel

WCDB_IMPLEMENTATION(RDBookDetailModel)

WCDB_SYNTHESIZE_COLUMN(RDBookDetailModel, bookId, "bookId") // Custom column name
WCDB_SYNTHESIZE_COLUMN(RDBookDetailModel, coverImg, "coverImg")
WCDB_SYNTHESIZE_COLUMN(RDBookDetailModel, title, "title")
WCDB_SYNTHESIZE_COLUMN(RDBookDetailModel, author, "author")
WCDB_SYNTHESIZE_COLUMN(RDBookDetailModel, desc, "desc")
WCDB_SYNTHESIZE_COLUMN(RDBookDetailModel, bookUpdate, "bookUpdate")
WCDB_SYNTHESIZE_COLUMN(RDBookDetailModel, charpterModel, "charpterModel")
WCDB_SYNTHESIZE_COLUMN(RDBookDetailModel, page, "page")
WCDB_SYNTHESIZE_COLUMN(RDBookDetailModel, readTime, "readTime")
WCDB_SYNTHESIZE_COLUMN(RDBookDetailModel, onBookshelf, "onBookshelf")

WCDB_PRIMARY(RDBookDetailModel, bookId)

WCDB_INDEX(RDBookDetailModel, "_onBookshelf_index", onBookshelf)

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"charpter": @"update.chapterName",
            @"time": @"update.time",
            @"updateCharpterId":@"update.chapterId",
            @"total": @"chapterNum",
            @"category":@"categoryName"
    };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"recommend":RDLibraryDetailModel.class
    };
}

-(BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    NSString *end = dic[@"update"][@"chapterStatus"];
    if ([end isKindOfClass:NSString.class] && [end isEqualToString:@"END"]) {
        self.updateEnd = YES;
    }
    NSString *end1 = dic[@"chapterStatus"];
    if ([end1 isKindOfClass:NSString.class] && [end1 isEqualToString:@"END"]) {
        self.end = YES;
    }
    return YES;
}

-(BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if ([object isKindOfClass:self.class]){
        RDBookDetailModel *model = object;
           if (self.bookId == model.bookId && self.bookId!=0) {
               return YES;
           }
    }
   
    return NO;
}

@end
