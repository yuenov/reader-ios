//
//  RDHttpModel.h
//  Reader
//
//  Created by yuenov on 2019/12/23.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDHttpModel : RDModel
@property(nonatomic, assign) NSInteger code;
@property(nonatomic, strong) NSString *msg;
@property(nonatomic, strong) NSDictionary *data;
@end

NS_ASSUME_NONNULL_END
