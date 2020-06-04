//
//  RDReadLightView.m
//  Reader
//
//  Created by yuenov on 2019/11/14.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDReadLightView.h"

#import "RDReadToolTheme.h"

#import "RDReadConfigManager.h"

@interface RDToolSlider : UISlider

@end

@implementation RDToolSlider


@end



@interface RDReadLightView ()
@property (nonatomic,strong) UIImageView *bigLight;
@property (nonatomic,strong) UIImageView *smallLight;
@property (nonatomic,strong) RDToolSlider *slider;
@property (nonatomic,strong) RDReadToolTheme *theme;
@end

@implementation RDReadLightView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bigLight];
        [self addSubview:self.smallLight];
        [self addSubview:self.slider];
        [self addSubview:self.theme];
    }
    return self;
}

-(UIImageView *)bigLight
{
    if (!_bigLight) {
        _bigLight = [[UIImageView alloc] init];
        _bigLight.image = [UIImage imageNamed:@"book_light_unselect"];
    }
    return _bigLight;
}

-(UIImageView *)smallLight
{
    if (!_smallLight) {
        _smallLight = [[UIImageView alloc] init];
        _smallLight.image = [UIImage imageNamed:@"book_light_small"];
    }
    return _smallLight;
}

-(RDToolSlider *)slider
{
    if (!_slider) {
        _slider = [[RDToolSlider alloc] init];
        _slider.minimumTrackTintColor = [UIColor colorWithHexValue:0x5D646E];
        _slider.maximumTrackTintColor = [UIColor colorWithHexValue:0xdfdfdf];
        _slider.minimumValue = 0;
        _slider.maximumValue = kConfigMaxBrightnessValue;
        _slider.value = [RDReadConfigManager sharedInstance].brightness;
        [_slider setThumbImage:[UIImage imageNamed:@"white_slider"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderBrightness:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}
-(RDReadToolTheme *)theme
{
    if (!_theme) {
        _theme = [[RDReadToolTheme alloc] init];
        _theme.theme = [RDReadConfigManager sharedInstance].theme;
    }
    return _theme;
}

-(void)sliderBrightness:(RDToolSlider *)sender
{
    [RDReadConfigManager sharedInstance].brightness = sender.value;
    [[RDReadConfigManager sharedInstance] archive];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.smallLight.frame = CGRectMake(20, 20, 18, 18);
    self.bigLight.frame = CGRectMake(0, 0, 23, 23);
    self.slider.frame = CGRectMake(self.smallLight.right+17, 0, self.width-40-17*2-23-15, 25);
    self.slider.centerY = self.smallLight.centerY;
    self.bigLight.right = self.width-20;
    self.bigLight.centerY = self.smallLight.centerY;
    self.theme.frame = CGRectMake(0, self.slider.bottom+20,self.width , 35);
    
}
@end
