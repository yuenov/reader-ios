//
//  RDSpecialApi.m
//  Reader
//
//  Created by yuenov on 2020/4/1.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSpecialApi.h"

@implementation RDSpecialApi
- (instancetype)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.size = 20;
    }
    
    return self;
}
- (NSString *)requestUrl {
    return @"/app/open/api/book/getSpecialList";
}
- (id)requestArgument {
    return @{
        @"pageNum": @(self.page),
        @"pageSize": @(self.size)
             };
}
-(NSArray <RDSpecialModel *>*)list
{
    return [[RDModelAgent agent] createModel:RDSpecialModel.class fromJson:self.httpModel.data[@"specialList"]];
}
@end
