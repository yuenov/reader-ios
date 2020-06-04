//
//  RDDownloadController.h
//  Reader
//
//  Created by yuenov on 2020/2/9.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseViewController.h"
@class RDBookDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface RDDownloadController : RDBaseViewController
@property (nonatomic,strong) RDBookDetailModel *record;
@end

NS_ASSUME_NONNULL_END
