//
//  RDBookRecommendApi.m
//  Reader
//
//  Created by yuenov on 2020/3/11.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBookRecommendApi.h"
#import "RDLibraryDetailModel.h"

@implementation RDBookRecommendApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.size = 20;
    }
    
    return self;
}
- (id)requestArgument {
    return @{
        @"pageNum": @(self.page),
        @"pageSize": @(self.size),
        @"bookId":@(self.bookId)
    };
}
- (NSString *)requestUrl {
    return @"/app/open/api/book/getRecommend";
}
-(NSArray <RDLibraryDetailModel *>*)list
{
    return [[RDModelAgent agent] createModel:RDLibraryDetailModel.class fromJson:self.httpModel.data[@"list"]];
}
@end
