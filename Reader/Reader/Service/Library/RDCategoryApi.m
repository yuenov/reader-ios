//
//  RDCategoryApi.m
//  Reader
//
//  Created by yuenov on 2019/12/23.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDCategoryApi.h"

@implementation RDCategoryApi

- (instancetype)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.size = 20;
        self.channelId = -1;
    }
    
    return self;
}

- (NSString *)requestUrl {
    return @"/app/open/api/book/getCategoryId";
}

- (id)requestArgument {
    NSMutableDictionary *request = @{
    @"pageNum": @(self.page),
    @"pageSize": @(self.size),
    @"categoryId":@(self.type)
    }.mutableCopy;
    if (_channelId!=-1) {
        request[@"channelId"] = @(self.channelId);
    }
    switch (self.filter) {
        case RDCategoryNewFilter:
            request[@"orderBy"] = @"NEWEST";
            break;
        case RDCategoryHotFilter:
            request[@"orderBy"] = @"HOT";
            break;
        case RDCategoryEndFilter:
            request[@"orderBy"] = @"END";
            break;
        default:
            break;
    }
    return request.copy;
}

-(NSArray <RDLibraryDetailModel *>*)categories
{
    return [[RDModelAgent agent] createModel:RDLibraryDetailModel.class fromJson:self.httpModel.data[@"list"]];
}
@end
