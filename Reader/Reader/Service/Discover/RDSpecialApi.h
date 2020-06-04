//
//  RDSpecialApi.h
//  Reader
//
//  Created by yuenov on 2020/4/1.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseApi.h"
#import "RDSpecialModel.h"

@interface RDSpecialApi : RDBaseApi
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger size;
-(NSArray <RDSpecialModel *>*)list;
@end

