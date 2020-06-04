//
//  RDSearchBottomView.m
//  Reader
//
//  Created by yuenov on 2020/4/1.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchBottomView.h"

@interface RDSearchBottomView ()
@property (nonatomic,strong) UIView *separate;

@end
@implementation RDSearchBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexValue:0xfbfbfb alpha:0.8];
        [self addSubview:self.separate];
        [self addSubview:self.feedback];
    
    }
    return self;
}

-(UIView *)separate
{
    if (!_separate) {
        _separate = [[UIView alloc] init];
        _separate.backgroundColor = RDLightSeparatorColor;
    }
    return _separate;
}

-(UIButton *)feedback
{
    if (!_feedback) {
        _feedback = [[UIButton alloc] init];
        [_feedback setTitle:@"没搜到？点击反馈" forState:UIControlStateNormal];
        [_feedback setTitleColor:RDGreenColor forState:UIControlStateNormal];
        _feedback.titleLabel.font = RDFont14;
    }
    return _feedback;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.separate.frame = CGRectMake(0, 0, self.width, MinPixel);
    self.feedback.frame = CGRectMake(0, 0, 140, self.height-[UIView safeBottomBar]);
    self.feedback.centerX = self.width/2;
}

@end
