//
//  RDDiscoverApi.h
//  Reader
//
//  Created by yuenov on 2020/2/26.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseApi.h"
#import "RDDiscoverItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RDDiscoverApi : RDBaseApi
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger size;
-(NSArray <RDDiscoverItemModel *>*)list;
@end

NS_ASSUME_NONNULL_END
