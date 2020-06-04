//
//  RDLibraryDetailModel.mm
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDLibraryDetailModel.h"


@implementation RDLibraryDetailModel
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
        @"category":@"categoryName"
    };
}
-(BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    NSString *end = dic[@"chapterStatus"];
    if ([end isKindOfClass:NSString.class] && [end isEqualToString:@"END"]) {
        self.end = YES;
    }
    return YES;
}

@end
