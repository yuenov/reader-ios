//
//  RDCategoryResultController.h
//  Reader
//
//  Created by yuenov on 2020/2/28.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDCategoryResultController : RDBaseViewController
@property (nonatomic,strong) NSString *category;    //分类名称
@property (nonatomic,assign) NSInteger channelId;   //频道id
@property (nonatomic,assign) NSInteger catagoryId;  //分类id
@end

NS_ASSUME_NONNULL_END
