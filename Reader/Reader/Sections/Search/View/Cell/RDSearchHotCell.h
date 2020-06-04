//
//  RDSearchHistoryCell.h
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchBaseCell.h"
@class RDBookDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface RDSearchHotCell : RDSearchBaseCell
@property (nonatomic,strong) RDBookDetailModel *bookDetail;
@property (nonatomic,assign) NSUInteger index;
@end

NS_ASSUME_NONNULL_END
