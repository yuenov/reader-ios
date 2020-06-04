//
//  RDUserModel.m
//  Reader
//
//  Created by yuenov on 2019/10/29.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDUserModel.h"
#import "RDModelAgent.h"

@implementation RDUserModel

+ (instancetype)getModel
{
    static RDUserModel *model = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        model = [[RDModelAgent agent] readModelForClass:[self class]];
        if (!model) {
            model = [RDUserModel new];
        }
    });
    
    return model;
}
@end
