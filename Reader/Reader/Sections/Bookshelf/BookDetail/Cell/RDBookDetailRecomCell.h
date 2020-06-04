//
//  RDBookDetailRecomCell.h
//  Reader
//
//  Created by yuenov on 2019/10/31.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBookDetailBaseCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface RDBookDetailRecomCell : RDBookDetailBaseCell
@property (nonatomic,copy) void (^needReload)(RDBookDetailModel *);
@end

NS_ASSUME_NONNULL_END
