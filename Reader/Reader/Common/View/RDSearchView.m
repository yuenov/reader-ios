//
//  RDSearchView.m
//  Reader
//
//  Created by yuenov on 2019/10/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDSearchView.h"
@interface RDSearchView ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *placeholderLabel;
@end
@implementation RDSearchView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.placeholderLabel];
        self.backgroundColor = [UIColor colorWithHexValue:0xf1f2f5];
        [self addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
            tap;
        })];
    }
    return self;
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"icon_reading_search"];
    }
    return _imageView;
}

-(UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = RDFont15;
        _placeholderLabel.textColor = RDLightGrayColor;
        _placeholderLabel.text = @"搜索";
    }
    return _placeholderLabel;
}


#pragma mark - action

-(void)click{
    if ([self.delegate respondsToSelector:@selector(searchViewDidSelect)]) {
        [self.delegate searchViewDidSelect];
    }
}

-(void)layoutSubviews
{
    self.layer.cornerRadius = self.height/2;
    self.imageView.frame = CGRectMake(12, 0, 15, 15);
    self.imageView.centerY = self.height/2;
    self.placeholderLabel.frame = CGRectMake(self.imageView.right+10, 0, self.width-12-15-10-20, self.height);
}
@end
