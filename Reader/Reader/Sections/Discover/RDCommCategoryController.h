//
//  RDCommCategoryController.h
//  Reader
//
//  Created by yuenov on 2020/3/2.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseViewController.h"


@interface RDCommCategoryController : RDBaseViewController
@property (nonatomic,assign) NSInteger catagoryId;      //分类ID 可能没有
@property (nonatomic,strong) NSString *categoryName;    //分类名称
@property (nonatomic,strong) NSString *type;        //主题的type，用于请求接口
@property (nonatomic,assign) NSInteger bookId;      //全部推荐传入
@property (nonatomic,assign) RDCommPageType pageType;
@end

