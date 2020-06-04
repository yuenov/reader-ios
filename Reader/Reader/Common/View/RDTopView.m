//
//  RDTopView.m
//  Reader
//
//  Created by yuenov on 2019/10/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDTopView.h"
#import "RDLayoutButton.h"
#import "RDMarcos.h"
#import "UIView+rd_dispalyInfo.h"
#import "NSArray+rd_wid.h"
#import "Reader.pch"

@interface RDTopView ()
@property(nonatomic, strong) NSMutableArray *rights;
@end

@implementation RDTopView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self commInit];
    }

    return self;
}
- (void)commInit {
    self.frame = CGRectMake(0, 0, ScreenWidth, [UIView statusBar] + [UIView navigationBar]);
    [self addSubview:self.titleLabel];
    self.backgroundColor = [UIColor whiteColor];
}
- (instancetype)initWithBackStyle {
    self = [super init];
    if (self) {
        [self commInit];
        [self addSubview:self.backBtn];
        [self addSubview:self.titleLabel];
//        [self addSubview:self.separate];
    }

    return self;
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

- (RDLayoutButton *)backBtn {
    if (!_backBtn) {
        RDLayoutButton *button = [[RDLayoutButton alloc] initWithFrame:CGRectMake(0, [UIView statusBar], kBackBtnWidth - 20, [UIView navigationBar])];
        button.adjustsImageWhenDisabled = NO;
        [button setImage:[UIImage imageNamed:@"button_back"] forState:UIControlStateNormal];
        button.imageSize = CGSizeMake(11, 19);
        
        _backBtn = button;
        
    }

    return _backBtn;
}

- (NSMutableArray *)rights {
    if (!_rights) {
        _rights = [NSMutableArray array];
    }
    return _rights;
}

- (UIView *)separate {
    if (!_separate) {
        _separate = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - MinPixel, self.width, MinPixel)];
        _separate.backgroundColor = RDSeparatorColor;
    }
    return _separate;
}

- (void)addRightBtn:(UIButton *)button {
    [self.rights addObjectSafely:button];
    [self addSubview:button];
    __block UIButton *temp;
    [self.rights enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        obj.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        obj.height = [UIView navigationBar];
        obj.width = kBackBtnWidth;
        if (obj.titleLabel.text.length != 0) {
            CGFloat width = [obj.titleLabel.text sizeWithFont:obj.titleLabel.font maxWidth:CGFLOAT_MAX].width;
            obj.width = width < kBackBtnWidth ? kBackBtnWidth : width;
        }
        obj.top = [UIView statusBar];
        if (temp) {
            obj.right = temp.left;
        } else {
            obj.right = ScreenWidth - [UIView margins];
        }
        temp = obj;
    }];
    self.titleLabel.frame = CGRectMake(kBackBtnWidth, [UIView statusBar], temp.left - kBackBtnWidth, [UIView navigationBar]);
}

- (void)refresh {
    NSArray *rights = self.rights.copy;
    [rights enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if (!obj.superview) {
            [self.rights removeObject:obj];
        }
    }];

    if (self.rights.count > 0) {
        __block UIButton *temp;
        [self.rights enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
            obj.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            obj.height = [UIView navigationBar];
            obj.width = kBackBtnWidth;
            if (obj.titleLabel.text.length != 0) {
                CGFloat width = [obj.titleLabel.text sizeWithFont:obj.titleLabel.font maxWidth:CGFLOAT_MAX].width;
                obj.width = width < kBackBtnWidth ? kBackBtnWidth : width;
            }
            obj.top = [UIView statusBar];
            if (temp) {
                obj.right = temp.left;
            } else {
                obj.right = ScreenWidth - [UIView margins];
            }
            temp = obj;
        }];
        self.titleLabel.frame = CGRectMake(kBackBtnWidth, [UIView statusBar], temp.left - kBackBtnWidth, [UIView navigationBar]);
    } else {
        self.titleLabel.frame = CGRectMake(kBackBtnWidth, [UIView statusBar], self.bounds.size.width - kBackBtnWidth * 2, [UIView navigationBar]);
    }
}

- (void)removeSeparate {
    [self.separate removeFromSuperview];

}
@end
