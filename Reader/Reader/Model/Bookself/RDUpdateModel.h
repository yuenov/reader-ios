//
//  RDUpdateModel.h
//  Reader
//
//  Created by yuenov on 2020/3/24.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDModel.h"

@interface RDUpdateModel : RDModel
@property (nonatomic,strong) NSString *appUrl;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *versionCode;
@property (nonatomic,assign) BOOL force;
@end
