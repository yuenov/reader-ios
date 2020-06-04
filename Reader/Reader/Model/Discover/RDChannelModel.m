//
//  RDChannelModel.m
//  Reader
//
//  Created by yuenov on 2020/2/25.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDChannelModel.h"

@implementation RDChannelItem
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
        @"category":@"categoryName",
        @"rank":@"rankName"
    };
}

@end

@implementation RDChannelModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
        @"channel":@"channelName"
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"categories": [RDChannelItem class],
             @"ranks":[RDChannelItem class]
    };
}
@end
