//
//  RDSearchHeaderFooterView.h
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RDSearchHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic,strong) NSString *title;
-(void)addButton:(UIButton *)button;
@end

NS_ASSUME_NONNULL_END
