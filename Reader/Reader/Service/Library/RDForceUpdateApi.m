//
//  RDForceUpdateApi.m
//  Reader
//
//  Created by yuenov on 2020/4/5.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDForceUpdateApi.h"
#import "RDCharpterModel.h"

@implementation RDForceUpdateApi
- (NSString *)requestUrl {
    return @"/app/open/api/chapter/updateForce";
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
-(id)requestArgument
{
    
    return @{
        @"chapterIdList":MakeNSArray(self.charpters),
        @"bookId":@(self.bookId),
    };
}



-(NSArray *)charptersContent
{
    NSArray *charpters = [[RDModelAgent agent] createModel:RDCharpterModel.class fromJson:self.httpModel.data[@"list"]];;
    if (charpters.count>0) {
        [charpters setValue:@(self.bookId) forKeyPath:@"bookId"];
    }
    return charpters;
}
@end
