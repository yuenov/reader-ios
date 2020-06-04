//
//  RDRankApi.m
//  Reader
//
//  Created by yuenov on 2020/2/26.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDRankApi.h"

@implementation RDRankApi
- (NSString *)requestUrl {
    return @"/app/open/api/rank/getList";
}
-(NSArray <RDChannelModel *>*)channel
{
    return [[RDModelAgent agent] createModel:RDChannelModel.class fromJson:self.httpModel.data[@"channels"]];
}
@end
