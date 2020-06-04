//
//  RDSearchResultCell.h
//  Reader
//
//  Created by yuenov on 2020/2/20.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchResultBaseCell.h"
#import "RDBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RDSearchResultCell : RDSearchResultBaseCell
@property (nonatomic,strong) RDBookDetailModel *book;
@property (nonatomic,strong) NSString *word;    //搜索关键字
/****************************/
@property (nonatomic,strong) UIImageView *coverImg;
@property (nonatomic,strong) UILabel *bookName;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) UILabel *authorLabel;
/****************************/
@end

NS_ASSUME_NONNULL_END
