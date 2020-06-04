//
//  RDDiscoverAllApi.h
//  Reader
//
//  Created by yuenov on 2020/3/10.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseApi.h"
#import "RDLibraryDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDDiscoverAllApi : RDBaseApi
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger size;
@property (nonatomic,assign) NSInteger categoryId;
@property (nonatomic,strong) NSString *type;

-(NSArray <RDLibraryDetailModel *>*)list;
@end

NS_ASSUME_NONNULL_END
