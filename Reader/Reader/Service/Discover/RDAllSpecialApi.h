//
//  RDAllSpecialApi.h
//  Reader
//
//  Created by yuenov on 2020/4/1.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseApi.h"
#import "RDLibraryDetailModel.h"
//查看所有专题
@interface RDAllSpecialApi : RDBaseApi
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger size;
@property (nonatomic,assign) NSInteger specialId;
-(NSArray <RDLibraryDetailModel *>*)list;
@end

