//
//  RDCategoryController.h
//  Reader
//
//  Created by yuenov on 2019/12/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBaseViewController.h"
#import "RDBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RDCatalogController : RDBaseViewController
@property (nonatomic,strong) RDBookDetailModel *model;
@end

NS_ASSUME_NONNULL_END
