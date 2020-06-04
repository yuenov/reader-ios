//
//  RDCharpterApi.m
//  Reader
//
//  Created by yuenov on 2019/12/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDCharpterApi.h"
#import "RDCharpterModel.h"
@implementation RDCharpterApi
- (NSString *)requestUrl {
    return @"/app/open/api/chapter/getByBookId";
}
-(id)requestArgument
{
    return @{
        @"bookId":@(self.bookId),
        @"chapterId":@(self.chapterId)
    };
}
-(NSString *)name
{
    return self.httpModel.data[@"title"];
}
-(NSString *)author
{
    return self.httpModel.data[@"author"];
}
-(NSArray *)charpters
{
    NSArray *charpters = [[RDModelAgent agent] createModel:RDCharpterModel.class fromJson:self.httpModel.data[@"chapters"]];
    if (charpters.count>0) {
        [charpters setValue:@(self.bookId) forKeyPath:@"bookId"];
        [charpters setValue:self.name forKeyPath:@"bookName"];
        [charpters setValue:self.author forKeyPath:@"author"];
    }
    return charpters;
}
@end
