//
//  RDTopView.h
//  Reader
//
//  Created by yuenov on 2019/10/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RDLayoutButton.h"

#define kBackBtnWidth 60.0f

@interface RDTopView : UIView

@property(nonatomic, strong) RDLayoutButton *backBtn;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *separate;

- (void)commInit;

- (instancetype)initWithBackStyle;

- (void)addRightBtn:(UIButton *)button;    //可多次调用

- (void)removeSeparate;

- (void)refresh;         //刷新布局\

@end

