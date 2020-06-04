//
//  RDReadSetView.m
//  Reader
//
//  Created by yuenov on 2019/11/14.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDReadSetView.h"
#import "StepSlider.h"
#import "RDReadToolPageView.h"
#import "RDReadConfigManager.h"
@interface RDReadSetView ()
@property (nonatomic,strong) UIImageView *bigWord;
@property (nonatomic,strong) UIImageView *smallWord;
@property (nonatomic,strong) StepSlider *stepSlider;
@property (nonatomic,strong) RDReadToolPageView *pageView;
@end

@implementation RDReadSetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bigWord];
        [self addSubview:self.smallWord];
        [self addSubview:self.stepSlider];
        [self addSubview:self.pageView];
    }
    return self;
}
-(UIImageView *)bigWord
{
    if (!_bigWord) {
        _bigWord = [[UIImageView alloc] init];
        _bigWord.image = [UIImage imageNamed:@"book_set_unselect"];
    }
    return _bigWord;
}

-(UIImageView *)smallWord
{
    if (!_smallWord) {
        _smallWord = [[UIImageView alloc] init];
        _smallWord.image = [UIImage imageNamed:@"book_set_unselect"];
    }
    return _smallWord;
}

-(StepSlider *)stepSlider
{
    if (!_stepSlider) {
        _stepSlider = [[StepSlider alloc] init];
        _stepSlider.maxCount = (kConfigMaxFontSize-kConfigMinFontSize)/2;
        _stepSlider.index = ([RDReadConfigManager sharedInstance].fontSize-kConfigMinFontSize)/2;
        _stepSlider.trackHeight = 1;
        _stepSlider.trackColor = [UIColor colorWithHexValue:0xd4d6d8];
        [_stepSlider setTintColor:[UIColor colorWithHexValue:0xd4d6d8]];
        _stepSlider.sliderCircleRadius = 10;
        _stepSlider.sliderCircleColor = [UIColor whiteColor];
        _stepSlider.dotsInteractionEnabled = NO;
        [_stepSlider setTrackCircleImage:[UIImage imageNamed:@"step"] forState:UIControlStateNormal];
        [_stepSlider addTarget:self action:@selector(sliderFontSize:) forControlEvents:UIControlEventTouchUpInside];
        [_stepSlider addTarget:self action:@selector(sliderFontSize:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _stepSlider;
}

-(RDReadToolPageView *)pageView
{
    if (!_pageView) {
        _pageView = [[RDReadToolPageView alloc] init];
        _pageView.defaultType = [RDReadConfigManager sharedInstance].pageType;
        __weak typeof(self) ws = self;
        [_pageView setPageType:^(RDPageType type) {
            if ([ws.delegate respondsToSelector:@selector(didChangePageType)]) {
                [ws.delegate didChangePageType];
            }
        }];
    }
    return _pageView;
}

-(void)sliderFontSize:(StepSlider *)sender
{
    CGFloat fonSize = sender.index*2+kConfigMinFontSize;
    [RDReadConfigManager sharedInstance].lineSpace = fonSize-8;
//    [RDReadConfigManager sharedInstance].firstLineHeadIndent = fonSize * 2;
    [RDReadConfigManager sharedInstance].fontSize = fonSize;
    [[RDReadConfigManager sharedInstance] archive];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.smallWord.frame = CGRectMake(25, 25, 18, 18);
    self.bigWord.frame = CGRectMake(0, 0, 25, 25);
    self.bigWord.right = self.width-25;
    self.bigWord.centerY = self.smallWord.centerY;
    CGFloat sHeight = 44.f;
    self.stepSlider.frame = CGRectMake(self.smallWord.right+25, 0, self.width-self.smallWord.right-50-18-25, sHeight);
    self.stepSlider.centerY = self.smallWord.centerY+11;
    
    self.pageView.frame = CGRectMake(0, self.stepSlider.bottom+10, self.width, 25);
    
}
@end
