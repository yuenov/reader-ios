//
//  RDConfigApi.m
//  Reader
//
//  Created by yuenov on 2020/3/6.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDConfigApi.h"
#import "RDConfigModel.h"

@implementation RDConfigApi
- (NSString *)requestUrl {
    return @"/app/open/api/system/getAppConfig";
}
-(RDConfigModel *)configModel
{
    NSArray *arr =  [[RDModelAgent agent] createModel:RDConfigModel.class fromJson:self.httpModel.data];
    return [arr objectAtIndexSafely:0];
}
@end
