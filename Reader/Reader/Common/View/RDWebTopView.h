//
//  RDWebTopView.h
//  Reader
//
//  Created by yuenov on 2020/3/23.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDLayoutButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface RDWebTopView : UIView
@property(nonatomic, strong) RDLayoutButton *backBtn;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) RDLayoutButton *closeBtn;
@property(nonatomic, strong) RDLayoutButton *reloadBtn;

- (void)closeBtnSizeToFit;
@end

NS_ASSUME_NONNULL_END
