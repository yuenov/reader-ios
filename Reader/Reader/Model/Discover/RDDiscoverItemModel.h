//
//  RDDiscoverItemModel.h
//  Reader
//
//  Created by yuenov on 2019/10/28.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDModel.h"
#import "RDLibraryDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RDDiscoverItemModel : RDModel
@property (nonatomic,strong) NSString *categoryId;  //分类id 当type为CATEGORY时才有值
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *type;    //发现类型
@property (nonatomic,strong) NSArray <RDLibraryDetailModel *> *categories;

@end

@interface RDDiscoverItemModel ()
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger size;
@end
NS_ASSUME_NONNULL_END
