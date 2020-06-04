//
//  RDReadCatalogCell.h
//  Reader
//
//  Created by yuenov on 2019/11/20.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDCharpterModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol RDReadCatalogCellDelegate <NSObject>
-(void)didSelectCharpter:(RDCharpterModel *)charpter;
@end

@interface RDReadCatalogCell : UITableViewCell
@property (nonatomic,strong) RDCharpterModel *model;
@property (nonatomic,weak) id<RDReadCatalogCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
