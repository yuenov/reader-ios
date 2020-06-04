//
//  RDSearchHeaderFooterView.m
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchHeaderFooterView.h"
@interface RDSearchHeaderFooterView ()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *button;
@end
@implementation RDSearchHeaderFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = RDFont13;
        _nameLabel.textColor = RDLightGrayColor;
    }
    return _nameLabel;
}
-(void)setTitle:(NSString *)title
{
    self.nameLabel.text = title;
}

-(void)addButton:(UIButton *)button
{
    _button = button;
    [self.contentView addSubview:button];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.nameLabel.frame = CGRectMake(15, 0, self.width/2, RDFont13.lineHeight);
    self.nameLabel.bottom = self.height;
    self.button.frame = CGRectMake(0, 0, 55, RDFont13.lineHeight);
    self.button.right = self.width;
    self.button.bottom = self.height;
}
@end
