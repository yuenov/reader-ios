//
//  RDRankContentApi.h
//  Reader
//
//  Created by yuenov on 2020/2/27.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseApi.h"
#import "RDLibraryDetailModel.h"

@interface RDRankContentApi : RDBaseApi
@property (nonatomic,assign) NSInteger rankId;
@property (nonatomic,assign) NSInteger channelId;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger size;

-(NSArray <RDLibraryDetailModel *>*)list;

@end

