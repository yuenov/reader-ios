//
//  RDCharpterModel.mm
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDCharpterModel+WCTTableCoding.h"
#import "RDCharpterModel.h"
#import <WCDB/WCDB.h>


@implementation RDCharpterModel

WCDB_IMPLEMENTATION(RDCharpterModel)
WCDB_SYNTHESIZE_COLUMN(RDCharpterModel, primaryId,"primaryId")
WCDB_SYNTHESIZE_COLUMN(RDCharpterModel, charpterId,"charpterId")
WCDB_SYNTHESIZE_COLUMN(RDCharpterModel, name,"name")
WCDB_SYNTHESIZE_COLUMN(RDCharpterModel, content,"content")
WCDB_SYNTHESIZE_COLUMN(RDCharpterModel, bookId,"bookId")
WCDB_SYNTHESIZE_COLUMN(RDCharpterModel, bookName,"bookName")
WCDB_SYNTHESIZE_COLUMN(RDCharpterModel, author,"author")


WCDB_PRIMARY(RDCharpterModel, primaryId)


WCDB_INDEX(RDCharpterModel, "_bookId_charpterId_index", bookId)
WCDB_INDEX(RDCharpterModel, "_bookId_charpterId_index", charpterId)

WCDB_INDEX(RDCharpterModel, "_bookId_content_index", bookId)
WCDB_INDEX(RDCharpterModel, "_bookId_content_index", content)

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"charpterId" : @"id"};
}

-(NSString *)primaryId
{
    if (!_primaryId) {
        _primaryId = [NSString stringWithFormat:@"%@%@",@(_bookId),@(_charpterId)];
    }
    return _primaryId;
}
-(BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if ([object isKindOfClass:self.class]) {
        RDCharpterModel *model = object;
           if (self.charpterId == model.charpterId && self.charpterId!=0) {
               return YES;
           }
    }
   
    return NO;
}
@end
