//
//  RDChapterListModel.m
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDChapterListModel.h"

@implementation RDChapterListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"bookId": @"id",
    };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"charpters": [RDCharpterModel class]};
}
@end
