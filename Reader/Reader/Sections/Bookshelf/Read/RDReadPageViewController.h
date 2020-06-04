//
//  RDReadPageViewController.h
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBaseViewController.h"
#import "RDBookDetailModel.h"
#import "RDCharpterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RDReadPageViewController : RDBaseViewController
@property (nonatomic,strong) RDBookDetailModel *bookDetail; //书籍详情与阅读进度
@end

NS_ASSUME_NONNULL_END
