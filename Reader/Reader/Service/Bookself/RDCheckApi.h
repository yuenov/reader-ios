//
//  RDCheckApi.h
//  Reader
//
//  Created by yuenov on 2020/3/6.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseApi.h"

NS_ASSUME_NONNULL_BEGIN
@class RDCharpterModel;
@interface RDCheckApi : RDBaseApi
@property (nonatomic,strong) NSArray <RDCharpterModel *>*books;
-(NSArray *)updateBooks;
@end

NS_ASSUME_NONNULL_END
