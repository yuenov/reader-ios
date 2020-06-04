//
//  RDSearchApi.h
//  Reader
//
//  Created by yuenov on 2020/3/2.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseApi.h"
#import "RDBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RDSearchApi : RDBaseApi
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger size;
@property (nonatomic,strong) NSString *word;
-(NSArray <RDBookDetailModel *>*)list;
@end

NS_ASSUME_NONNULL_END
