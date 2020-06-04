//
//  RDCategoryApi.h
//  Reader
//
//  Created by yuenov on 2019/12/23.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBaseApi.h"
#import "RDLibraryDetailModel.h"
NS_ASSUME_NONNULL_BEGIN




@interface RDCategoryApi : RDBaseApi
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger size;
@property (nonatomic,assign) RDCategoryFilter filter;
@property (nonatomic,assign) NSInteger channelId;
-(NSArray <RDLibraryDetailModel *>*)categories;
@end

NS_ASSUME_NONNULL_END
