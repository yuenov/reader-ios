//
//  RDReadModel.h
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDReadModel : RDModel
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *chapterTitle;
@property (nonatomic,assign) NSInteger totalPage;
@property (nonatomic,assign) NSInteger currentPage;
@end

NS_ASSUME_NONNULL_END
