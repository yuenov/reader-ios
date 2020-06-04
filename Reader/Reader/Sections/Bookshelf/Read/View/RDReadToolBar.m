//
//  RDReadToolBar.m
//  Reader
//
//  Created by yuenov on 2019/11/13.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDReadToolBar.h"

@interface RDReadToolBar ()

@property (nonatomic,strong) RDLayoutButton *lastButton;
@end

@implementation RDReadToolBar
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.menu];
        [self addSubview:self.slider];
        [self addSubview:self.light];
        [self addSubview:self.setting];
        [self setBackgroundColor:RDReadBg];
    }
    return self;
}
-(RDLayoutButton *)menu
{
    if (!_menu) {
        _menu = [[RDLayoutButton alloc] init];
        [_menu setImage:[UIImage imageNamed:@"book_menu_unselect"] forState:UIControlStateNormal];
        [_menu setImage:[UIImage imageNamed:@"book_menu_select"] forState:UIControlStateSelected];
        _menu.imageSize = CGSizeMake(25, 25);
        [_menu addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menu;
}

-(RDLayoutButton *)slider
{
    if (!_slider) {
        _slider = [[RDLayoutButton alloc] init];
        [_slider setImage:[UIImage imageNamed:@"book_progress_unselect"] forState:UIControlStateNormal];
        [_slider setImage:[UIImage imageNamed:@"book_progress_select"] forState:UIControlStateSelected];
        _slider.imageSize = CGSizeMake(25, 25);
        [_slider addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider;
}

-(RDLayoutButton *)light
{
    if (!_light) {
        _light = [[RDLayoutButton alloc] init];
        [_light setImage:[UIImage imageNamed:@"book_light_unselect"] forState:UIControlStateNormal];
        [_light setImage:[UIImage imageNamed:@"book_light_select"] forState:UIControlStateSelected];
        _light.imageSize = CGSizeMake(25, 25);
        [_light addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _light;
}

-(RDLayoutButton *)setting
{
    if (!_setting) {
        _setting = [[RDLayoutButton alloc] init];
        [_setting setImage:[UIImage imageNamed:@"book_set_unselect"] forState:UIControlStateNormal];
        [_setting setImage:[UIImage imageNamed:@"book_set_select"] forState:UIControlStateSelected];
        _setting.imageSize = CGSizeMake(25, 25);
        [_setting addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setting;
}


-(void)click:(RDLayoutButton *)sender
{
    if (sender != self.lastButton) {
        self.lastButton.selected = NO;
    }
    sender.selected = !sender.selected;
    self.lastButton = sender;
    if (sender == self.menu) {
        if ([self.delegate respondsToSelector:@selector(didMenu)]) {
            [self.delegate didMenu];
        }
    }
    else if (sender == self.slider){
        if ([self.delegate respondsToSelector:@selector(didSlider)]) {
            [self.delegate didSlider];
        }
    }
    else if (sender == self.light){
        if ([self.delegate respondsToSelector:@selector(didLight)]) {
            [self.delegate didLight];
        }
    }
    else if (sender == self.setting){
        if ([self.delegate respondsToSelector:@selector(didSetting)]) {
            [self.delegate didSetting];
        }
        
        
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.width/4;
    self.menu.frame = CGRectMake(0, 0, width, self.height-[UIView safeBottomBar]);
    self.slider.frame = CGRectMake(width, 0, width, self.height-[UIView safeBottomBar]);
    self.light.frame = CGRectMake(width*2, 0, width, self.height-[UIView safeBottomBar]);
    self.setting.frame = CGRectMake(width*3, 0, width,self.height-[UIView safeBottomBar]);
}

@end
