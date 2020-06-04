//
//  RDReadProgressView.m
//  Reader
//
//  Created by yuenov on 2019/11/19.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDReadProgressView.h"
#import "RDBookDetailModel.h"
#import "RDCharpterModel.h"
@interface RDReadProgressView  ()
@property (nonatomic,strong) UIImageView *left;
@property (nonatomic,strong) UIImageView *right;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UILabel *chapterLabel;
@end
@implementation RDReadProgressView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.chapterLabel];
        [self addSubview:self.slider];
        [self addSubview:self.left];
        [self addSubview:self.right];
    }
    return self;
}

-(void)setCharpters:(NSArray<RDCharpterModel *> *)charpters
{
    _charpters = charpters;
}


-(void)setBook:(RDBookDetailModel *)book
{
    _book = book;
    self.chapterLabel.text = book.charpterModel.name;
    NSInteger index = [self.charpters indexOfObject:book.charpterModel];
    if (index != NSNotFound) {
        self.slider.value = index/(CGFloat)self.charpters.count;
    }
}

-(UILabel *)chapterLabel
{
    if (!_chapterLabel) {
        _chapterLabel = [[UILabel alloc] init];
        _chapterLabel.textColor = RDGrayColor;
        _chapterLabel.font = RDFont14;
        _chapterLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _chapterLabel;
}

-(UIImageView *)left
{
    if (!_left) {
        _left = [[UIImageView alloc] init];
        _left.image = [UIImage imageNamed:@"read_progress_left"];
    }
    return _left;
}

-(UIImageView *)right
{
    if (!_right) {
        _right = [[UIImageView alloc] init];
        _right.image = [UIImage imageNamed:@"read_progress_right"];
    }
    return _right;
}

-(UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumTrackTintColor = [UIColor colorWithHexValue:0x5D646E];
        _slider.maximumTrackTintColor = [UIColor colorWithHexValue:0xdfdfdf];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        [_slider addTarget:self action:@selector(jump:) forControlEvents:UIControlEventValueChanged];
        [_slider setThumbImage:[UIImage imageNamed:@"white_slider"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _slider;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.chapterLabel.frame = CGRectMake(20, 20, self.width-40, RDFont14.lineHeight);
    self.left.frame = CGRectMake(20, self.chapterLabel.bottom+15, 18, 18);
    self.slider.frame = CGRectMake(self.left.right+15, 0, self.width-40-30-36, 20);
    self.slider.centerY = self.left.centerY;
    self.right.frame = CGRectMake(self.slider.right+15, 0, 18, 18);
    self.right.centerY = self.left.centerY;
    
}

-(void)jump:(UISlider *)sender
{
    NSInteger index = sender.value * (self.charpters.count-1);
    if (index<self.charpters.count) {
        RDCharpterModel *charpter = self.charpters[index];
        self.chapterLabel.text = charpter.name;
    }
}
-(void)cancel:(UISlider *)sender
{
    if ([self.delegate respondsToSelector:@selector(sliderToCharpter:)]) {
        NSInteger index = sender.value * (self.charpters.count-1);
        if (index<self.charpters.count) {
            RDCharpterModel *charpter = self.charpters[index];
            [self.delegate sliderToCharpter:charpter];
        }
    }
}
@end
