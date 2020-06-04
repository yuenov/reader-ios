//
//  RDBookRecommendApi.h
//  Reader
//
//  Created by yuenov on 2020/3/11.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseApi.h"
@class RDLibraryDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface RDBookRecommendApi : RDBaseApi
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger size;
@property (nonatomic,assign) NSInteger bookId;
-(NSArray <RDLibraryDetailModel *>*)list;
@end

NS_ASSUME_NONNULL_END
