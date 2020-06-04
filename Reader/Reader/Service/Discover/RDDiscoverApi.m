//
//  RDDiscoverApi.m
//  Reader
//
//  Created by yuenov on 2020/2/26.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDDiscoverApi.h"

@implementation RDDiscoverApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.size = 20;
    }
    
    return self;
}
- (NSString *)requestUrl {
    return @"/app/open/api/category/discovery";
}
- (id)requestArgument {
    return @{
             @"pageNum": @(self.page),
             @"pageSize": @(self.size),
             };
}
-(NSArray <RDDiscoverItemModel *>*)list
{
    return [[RDModelAgent agent] createModel:RDDiscoverItemModel.class fromJson:self.httpModel.data[@"list"]];
}
@end
