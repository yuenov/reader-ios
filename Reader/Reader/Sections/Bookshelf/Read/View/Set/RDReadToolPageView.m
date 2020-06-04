//
//  RDReadToolPageView.m
//  Reader
//
//  Created by yuenov on 2019/11/19.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDReadToolPageView.h"

@interface RDReadToolPageView ()
@property (nonatomic,strong) UIButton *realBtn;
@property (nonatomic,strong) UIButton *sliderBtn;
@property (nonatomic,strong) UIButton *noneBtn;
@property (nonatomic,strong) UIButton *selectBtn;
@end

@implementation RDReadToolPageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.realBtn];
        [self addSubview:self.sliderBtn];
        [self addSubview:self.noneBtn];
    }
    return self;
}

-(UIButton *)realBtn
{
    if (!_realBtn) {
        _realBtn = [[UIButton alloc] init];
        [_realBtn setTitle:@"仿真翻页" forState:UIControlStateNormal];
        [_realBtn setTitleColor:RDBlackColor forState:UIControlStateNormal];
        [_realBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_realBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _realBtn.titleLabel.font = RDFont14;
        
        [_realBtn setBackgroundImage:[UIImage stretchableImageNamed:@"balck_border_btn"] forState:UIControlStateNormal];
        [_realBtn setBackgroundImage:[UIImage stretchableImageNamed:@"green_btn_1"] forState:UIControlStateSelected];
    }
    return _realBtn;
}

-(UIButton *)sliderBtn
{
    if (!_sliderBtn) {
        _sliderBtn = [[UIButton alloc] init];
        [_sliderBtn setTitle:@"左右滑动" forState:UIControlStateNormal];
        [_sliderBtn setTitleColor:RDBlackColor forState:UIControlStateNormal];
        [_sliderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_sliderBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _sliderBtn.titleLabel.font = RDFont14;
        
        [_sliderBtn setBackgroundImage:[UIImage stretchableImageNamed:@"balck_border_btn"] forState:UIControlStateNormal];
        [_sliderBtn setBackgroundImage:[UIImage stretchableImageNamed:@"green_btn_1"] forState:UIControlStateSelected];
    }
    return _sliderBtn;
}

-(UIButton *)noneBtn
{
    if (!_noneBtn) {
        _noneBtn = [[UIButton alloc] init];
        [_noneBtn setTitle:@"无" forState:UIControlStateNormal];
        [_noneBtn setTitleColor:RDBlackColor forState:UIControlStateNormal];
        [_noneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_noneBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _noneBtn.titleLabel.font = RDFont14;
        
        [_noneBtn setBackgroundImage:[UIImage stretchableImageNamed:@"balck_border_btn"] forState:UIControlStateNormal];
        [_noneBtn setBackgroundImage:[UIImage stretchableImageNamed:@"green_btn_1"] forState:UIControlStateSelected];
    }
    return _noneBtn;
}


-(void)setDefaultType:(RDPageType)defaultType
{
    switch (defaultType) {
        case RDNoneTypePage:
            _noneBtn.selected = YES;
            self.selectBtn = self.noneBtn;
            break;
            
        case RDRealTypePage:
            _realBtn.selected = YES;
            self.selectBtn = self.realBtn;
            break;
        case RDSliderPage:
            _sliderBtn.selected = YES;
            self.selectBtn = self.sliderBtn;
            break;
    }
}

-(void)click:(UIButton *)sender
{
    self.selectBtn.selected = NO;
    sender.selected = YES;
    self.selectBtn = sender;
    RDPageType type = RDNoneTypePage;
    if (sender == self.noneBtn) {
        type = RDNoneTypePage;
    }
    else if (sender == self.realBtn){
        type = RDRealTypePage;
    }
    else if (sender == self.sliderBtn){
        type = RDSliderPage;
    }
    [RDReadConfigManager sharedInstance].pageType = type;
    [[RDReadConfigManager sharedInstance] archive];
    if (self.pageType) {
        self.pageType(type);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = 80;
    CGFloat spacing = (self.width-40-80*3)/2;
    self.realBtn.frame = CGRectMake(20, 0, width, self.height);
    self.sliderBtn.frame = CGRectMake(self.realBtn.right+spacing, 0, width, self.height);
    self.noneBtn.frame = CGRectMake(self.sliderBtn.right+spacing, 0, width, self.height);
}

@end
