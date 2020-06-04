//
//  RDSpecialModel.h
//  Reader
//
//  Created by yuenov on 2020/4/1.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDDiscoverItemModel.h"

//专题Model
@interface RDSpecialModel : RDDiscoverItemModel
@property (nonatomic,assign) NSInteger specialId;   //专题ID
@property (nonatomic,strong) NSString *name;        //专题名称
@property (nonatomic,strong) NSArray <RDLibraryDetailModel *>*bookList; //书籍列表
@end
