//
//  RDDiscoverAllApi.m
//  Reader
//
//  Created by yuenov on 2020/3/10.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDDiscoverAllApi.h"

@implementation RDDiscoverAllApi

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
    return @"/app/open/api/category/discoveryAll";
}

-(id)requestArgument
{
    return @{
        @"pageNum":@(self.page),
        @"pageSize":@(self.size),
        @"categoryId":@(self.categoryId),
        @"type":MakeNSStringNoNull(self.type)
    };
}

-(NSArray <RDLibraryDetailModel *>*)list
{
    return [[RDModelAgent agent] createModel:RDLibraryDetailModel.class fromJson:self.httpModel.data[@"list"]];
}


@end
