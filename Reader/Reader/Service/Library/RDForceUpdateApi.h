//
//  RDForceUpdateApi.h
//  Reader
//
//  Created by yuenov on 2020/4/5.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseApi.h"

NS_ASSUME_NONNULL_BEGIN
//更新章节内容
@interface RDForceUpdateApi : RDBaseApi
@property (nonatomic,assign) NSInteger bookId;
@property (nonatomic,strong) NSArray *charpters;
-(NSArray *)charptersContent;
@end

NS_ASSUME_NONNULL_END
