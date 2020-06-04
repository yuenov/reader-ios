//
//  RDRankContentApi.m
//  Reader
//
//  Created by yuenov on 2020/2/27.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDRankContentApi.h"

@implementation RDRankContentApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.size = 20;
    }
    
    return self;
}
- (NSString *)requestUrl {
    return @"/app/open/api/rank/getPage";
}
- (id)requestArgument {
    return @{
             @"pageNum": @(self.page),
             @"pageSize": @(self.size),
             @"rankId":@(self.rankId),
             @"channelId":@(self.channelId)
             };
}
-(NSArray <RDLibraryDetailModel *>*)list
{
    return [[RDModelAgent agent] createModel:RDLibraryDetailModel.class fromJson:self.httpModel.data[@"list"]];
}
@end
