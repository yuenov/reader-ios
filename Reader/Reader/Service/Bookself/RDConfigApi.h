//
//  RDConfigApi.h
//  Reader
//
//  Created by yuenov on 2020/3/6.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseApi.h"
@class RDConfigModel;
NS_ASSUME_NONNULL_BEGIN

@interface RDConfigApi : RDBaseApi
-(RDConfigModel *)configModel;
@end

NS_ASSUME_NONNULL_END
