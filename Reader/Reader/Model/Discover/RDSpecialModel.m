//
//  RDSpecialModel.m
//  Reader
//
//  Created by yuenov on 2020/4/1.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSpecialModel.h"

@implementation RDSpecialModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"specialId": @"id",
    };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"bookList": [RDLibraryDetailModel class]
    };
}
@end
