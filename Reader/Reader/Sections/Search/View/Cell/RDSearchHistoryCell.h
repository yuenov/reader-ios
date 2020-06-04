//
//  RDSearchHotCell.h
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDSearchHistoryCell : RDSearchBaseCell
@property (nonatomic,strong) NSArray <NSString *>* words;
@property (nonatomic,copy) void (^didWord) (NSString *);
+(CGFloat)cellHeight:(NSArray <NSString *>*)words;
@end

NS_ASSUME_NONNULL_END
