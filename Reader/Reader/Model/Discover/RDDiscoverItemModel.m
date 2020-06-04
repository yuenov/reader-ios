//
//  RDDiscoverItemModel.m
//  Reader
//
//  Created by yuenov on 2019/10/28.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDDiscoverItemModel.h"

@implementation RDDiscoverItemModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        self.size = 8;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"categories": @"bookList",
            @"title":@"categoryName",
    };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"categories": [RDLibraryDetailModel class]
    };
}
@end
