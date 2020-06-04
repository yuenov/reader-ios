//
//  RDDiscoverHeader.m
//  Reader
//
//  Created by yuenov on 2019/10/29.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDDiscoverHeader.h"
@interface RDDiscoverHeader ()
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *catregoryLabel;
@end
@implementation RDDiscoverHeader

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lineView];
        [self addSubview:self.catregoryLabel];
    }
    return self;
}
-(void)setCategory:(NSString *)category
{
    _category = category;
    self.catregoryLabel.text = category;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RDGreenColor;
        _lineView.layer.cornerRadius = 1.5;
    }
    return _lineView;
}

-(UILabel *)catregoryLabel
{
    if (!_catregoryLabel) {
        _catregoryLabel = [[UILabel alloc]init];
        _catregoryLabel.font = RDBoldFont15;
        _catregoryLabel.textColor = RDBlackColor;
    }
    return _catregoryLabel;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _lineView.frame = CGRectMake(15, 0, 3, 16);
    _lineView.centerY = self.height/2;
    _catregoryLabel.frame = CGRectMake(self.lineView.right+10, 0, [_catregoryLabel.text sizeWithFont:RDBoldFont15 maxWidth:self.width-40].width, RDBoldFont15.lineHeight);
    _catregoryLabel.centerY = self.height/2;
}
@end
