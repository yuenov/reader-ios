//
// Created by yuenov on 2019/10/25.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDLibraryDetailModel.h"
@interface RDLibraryCategoryCell : UITableViewCell
@property (nonatomic,strong) RDLibraryDetailModel *model;

+(CGFloat)categoryCellHeigh:(RDLibraryDetailModel *)model;
@end
