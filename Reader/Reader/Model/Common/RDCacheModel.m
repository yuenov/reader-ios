//
//  RDCacheModel.m
//  Reader
//
//  Created by yuenov on 2020/3/6.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDCacheModel.h"

@implementation RDCacheModel

+ (RDCacheModel *)sharedInstance {
    static RDCacheModel *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[RDModelAgent agent] readModelForClass:[self class]];
        if (!sharedInstance) {
           sharedInstance = [RDCacheModel new];
        }
    });

    return sharedInstance;
}

-(NSMutableDictionary *)catagories
{
    if (!_catagories) {
        _catagories = [NSMutableDictionary dictionary];
    }
    return _catagories;
}
@end
