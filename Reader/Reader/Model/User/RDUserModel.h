//
//  RDUserModel.h
//  Reader
//
//  Created by yuenov on 2019/10/29.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDUserModel : RDModel

@property (nonatomic,strong) NSString *uid;
@property (nonatomic,assign) RDGenderType gender;
+ (instancetype)getModel;
@end

NS_ASSUME_NONNULL_END
