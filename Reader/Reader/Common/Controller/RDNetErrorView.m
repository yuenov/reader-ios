//
//  RDNetErrorView.m
//  Reader
//
//  Created by yuenov on 2020/4/14.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDNetErrorView.h"

@interface RDNetErrorView ()
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *label;

@end

@implementation RDNetErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.icon];
        [self addSubview:self.label];
        [self addSubview:self.reloadBtn];
        [self makConstraints];
    }
    return self;
}
-(void)setErrorString:(NSString *)errorString
{
    _errorString = errorString;
    self.label.text = errorString;
}
-(void)makConstraints{
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self.mas_centerY);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.bottom.equalTo(self.label.mas_top).offset(-30);
        make.centerX.equalTo(self);
    }];
    
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(235);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.label.mas_bottom).offset(20);
        make.centerX.equalTo(self);
    }];
}

-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"ic_neterror"];
    }
    return _icon;
}
-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = RDGrayColor;
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

-(UIButton *)reloadBtn
{
    if (!_reloadBtn) {
        _reloadBtn = [[UIButton alloc] init];
        [_reloadBtn setTitle:@"点击重试" forState:UIControlStateNormal];
        [_reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reloadBtn setBackgroundImage:[UIImage stretchableImageNamed:@"green_btn"] forState:UIControlStateNormal];
        _reloadBtn.titleLabel.font = RDBoldFont17;
    }
    return _reloadBtn;
}

@end
