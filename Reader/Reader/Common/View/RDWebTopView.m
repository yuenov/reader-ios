//
//  RDWebTopView.m
//  Reader
//
//  Created by yuenov on 2020/3/23.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDWebTopView.h"

@implementation RDWebTopView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self commInit];
        [self addSubview:self.backBtn];
        [self addSubview:self.titleLabel];
        [self addSubview:self.reloadBtn];
    }

    return self;
}

- (void)commInit {
    self.frame = CGRectMake(0, 0, ScreenWidth, [UIView statusBar] + [UIView navigationBar]);
    [self addSubview:self.titleLabel];
    self.backgroundColor = [UIColor whiteColor];
}




- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_closeBtn.superview) {
        self.titleLabel.width = self.bounds.size.width - 60 * 2;
        self.titleLabel.left = 60;
    } else {
        self.titleLabel.left = self.closeBtn.right + 5;
        self.titleLabel.width = self.width - (self.closeBtn.right + 5) * 2;
    }
}

- (RDLayoutButton *)backBtn {
    if (!_backBtn) {
        RDLayoutButton *button = [[RDLayoutButton alloc] initWithFrame:CGRectMake(0, [UIView statusBar], kBackBtnWidth - 20, [UIView navigationBar])];
        button.adjustsImageWhenDisabled = NO;
        button.imageSize = CGSizeMake(11, 19);
         [button setImage:[UIImage imageNamed:@"button_back"] forState:UIControlStateNormal];
        _backBtn = button;
    }

    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
       UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kBackBtnWidth, [UIView statusBar], self.bounds.size.width - kBackBtnWidth * 2, [UIView navigationBar])];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = RDBoldFont17;
        label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _titleLabel = label;
    }

    return _titleLabel;
}

- (RDLayoutButton *)closeBtn {
    if (!_closeBtn) {
        RDLayoutButton *button = [[RDLayoutButton alloc] initWithFrame:CGRectMake(self.backBtn.right + 15, [UIView statusBar], 17,  [UIView navigationBar])];
        button.imageSize = CGSizeMake(17, 17);
        button.extendInsets = UIEdgeInsetsMake( [UIView statusBar], 5, 10, 15);
        [button setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];

        _closeBtn = button;
    }

    return _closeBtn;
}

- (RDLayoutButton *)reloadBtn {
    if (!_reloadBtn) {
        RDLayoutButton *button = [[RDLayoutButton alloc] init];
        button.frame = CGRectMake(0, [UIView statusBar], 17, [UIView navigationBar]);
        button.right = self.width - 10;
        button.imageSize = CGSizeMake(20, 20);
        [button setImage:[UIImage imageNamed:@"button_reload"] forState:UIControlStateNormal];

        _reloadBtn = button;
    }

    return _reloadBtn;
}

- (void)closeBtnSizeToFit {
    [self setNeedsLayout];
}

@end
