//
//  RDCommParamManager.h
//  Reader
//
//  Created by yuenov on 2020/4/5.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDModel.h"


@interface RDCommParamManager : RDModel
@property (nonatomic,strong) NSString *port;
+ (instancetype)sharedInstance;
@end

