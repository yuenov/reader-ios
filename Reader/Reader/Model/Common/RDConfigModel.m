//
//  RDConfigModel.m
//  Reader
//
//  Created by yuenov on 2019/12/23.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDConfigModel.h"
#import "RDModelAgent.h"
@implementation RDConfigModel
+ (instancetype)getModel
{
    static RDConfigModel *model = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        model = [[RDModelAgent agent] readModelForClass:[self class]];
        if (!model) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"];
            if (path == nil) {
                NSAssert(NO, @"出错了!");
            }
            NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            NSArray *arr = [[RDModelAgent agent] createModel:[RDConfigModel class] fromJson:[str JSONObject]];
            model = [arr objectAtIndexSafely:0];
            if (!model) {
                model = [RDConfigModel new];
            }
        }
    });
    
    return model;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"categories": [RDCategoryModel class],
             @"hotSearch":[RDBookDetailModel class],
    };
}
@end
