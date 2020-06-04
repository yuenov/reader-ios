//
//  RDAllSpecialApi.m
//  Reader
//
//  Created by yuenov on 2020/4/1.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDAllSpecialApi.h"

@implementation RDAllSpecialApi
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        self.size = 10;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"/app/open/api/book/getSpecialPage";
}

-(id)requestArgument
{
    return @{
        @"pageNum":@(self.page),
        @"pageSize":@(self.size),
        @"id":@(self.specialId)
    };
}

-(NSArray <RDLibraryDetailModel *>*)list
{
    return [[RDModelAgent agent] createModel:RDLibraryDetailModel.class fromJson:self.httpModel.data[@"list"]];
}
@end
