//
//  RDCacheModel.h
//  Reader
//
//  Created by yuenov on 2020/3/6.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDModel.h"
#import "RDModelAgent.h"

@interface RDCacheModel : RDModel
DEF_SINGLETON(RDCacheModel)
//书城所有的分类第一页数据缓存
@property (nonatomic,strong) NSMutableDictionary *catagories;
//发现页第一页数据缓存
@property (nonatomic,strong) NSArray *discovers;
//应用退出时是否正在阅读书籍
@property (nonatomic,strong) RDBookDetailModel *book;
@end

