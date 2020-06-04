//
//  RDAllCategoryApi.h
//  Reader
//
//  Created by yuenov on 2020/2/25.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseApi.h"
#import "RDChannelModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RDAllCategoryApi : RDBaseApi

-(NSArray <RDChannelModel *>*)channel;
@end

NS_ASSUME_NONNULL_END
