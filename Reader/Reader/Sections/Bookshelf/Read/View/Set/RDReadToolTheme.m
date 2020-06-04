//
//  RDReadToolTheme.m
//  Reader
//
//  Created by yuenov on 2019/11/19.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDReadToolTheme.h"
#import "RDLayoutButton.h"
@interface RDReadToolTheme ()
@property (nonatomic,strong) RDLayoutButton *white;
@property (nonatomic,strong) RDLayoutButton *yellow;
@property (nonatomic,strong) RDLayoutButton *blue;
@property (nonatomic,strong) RDLayoutButton *green;
@property (nonatomic,strong) RDLayoutButton *black;
@property (nonatomic,strong) RDLayoutButton *selectTheme;

@property (nonatomic,strong) UIImageView *greenIcon;
@property (nonatomic,strong) UIImageView *blackIcon;
@end
@implementation RDReadToolTheme
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.white];
        [self addSubview:self.yellow];
        [self addSubview:self.blue];
        [self addSubview:self.green];
        [self.green addSubview:self.greenIcon];
        [self addSubview:self.black];
        [self.black addSubview:self.blackIcon];
    }
    return self;
}

-(void)setTheme:(RDThemeType)theme
{
    switch (theme) {
        case RDWhiteTheme:
            self.white.selected = YES;
            self.selectTheme = self.white;
            break;
        case RDYellowTheme:
            self.yellow.selected = YES;
            self.selectTheme = self.yellow;
            break;
        case RDBlueTheme:
            self.blue.selected = YES;
            self.selectTheme = self.blue;
            break;
        case RDGreenTheme:
            self.green.selected = YES;
            self.selectTheme = self.green;
            break;
        case RDBlackTheme:
            self.black.selected = YES;
            self.selectTheme = self.black;
            break;
    }
}

-(RDLayoutButton *)white
{
    if (!_white) {
        _white = [[RDLayoutButton alloc] init];
        [_white setImage:[UIImage imageNamed:@"theme1_read_bg"] forState:UIControlStateNormal];
        [_white setImage:[UIImage imageNamed:@"theme1_read_bg"] forState:UIControlStateHighlighted];
        _white.imageView.layer.cornerRadius = 14;
        [_white setImageSize:CGSizeMake(28, 28)];
        [_white setBackgroundImage:nil forState:UIControlStateNormal];
        [_white setBackgroundImage:[UIImage imageNamed:@"theme1_border"] forState:UIControlStateSelected];
        
        [_white addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _white;
}
-(RDLayoutButton *)yellow
{
    if (!_yellow) {
        _yellow = [[RDLayoutButton alloc] init];
        [_yellow setImage:[UIImage imageNamed:@"theme2_read_bg"] forState:UIControlStateNormal];
        [_yellow setImageSize:CGSizeMake(28, 28)];
        [_yellow setBackgroundImage:nil forState:UIControlStateNormal];
        [_yellow setBackgroundImage:[UIImage imageNamed:@"theme2_border"] forState:UIControlStateSelected];
        [_yellow addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_yellow setImage:[UIImage imageNamed:@"theme2_read_bg"] forState:UIControlStateHighlighted];
        _yellow.imageView.layer.cornerRadius = 14;
    }
    return _yellow;
}

-(RDLayoutButton *)blue
{
    if (!_blue) {
        _blue = [[RDLayoutButton alloc] init];
        [_blue setImage:[UIImage imageNamed:@"theme3_read_bg"] forState:UIControlStateNormal];
        [_blue setImageSize:CGSizeMake(28, 28)];
        [_blue setBackgroundImage:nil forState:UIControlStateNormal];
        [_blue setBackgroundImage:[UIImage imageNamed:@"theme3_border"] forState:UIControlStateSelected];
        [_blue addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_blue setImage:[UIImage imageNamed:@"theme3_read_bg"] forState:UIControlStateHighlighted];
        _blue.imageView.layer.cornerRadius = 14;
    }
    return _blue;
}

-(RDLayoutButton *)green
{
    if (!_green) {
        _green = [[RDLayoutButton alloc] init];
        [_green setImage:[UIImage imageNamed:@"theme4_read_bg"] forState:UIControlStateNormal];
        [_green setImageSize:CGSizeMake(28, 28)];
        [_green setBackgroundImage:nil forState:UIControlStateNormal];
        [_green setBackgroundImage:[UIImage imageNamed:@"theme4_border"] forState:UIControlStateSelected];
        [_green addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_green setImage:[UIImage imageNamed:@"theme4_read_bg"] forState:UIControlStateHighlighted];
        _green.imageView.layer.cornerRadius = 14;
    }
    return _green;
}

-(RDLayoutButton *)black
{
    if (!_black) {
        _black = [[RDLayoutButton alloc] init];
        [_black setImage:[UIImage imageNamed:@"theme5_read_bg"] forState:UIControlStateNormal];
        [_black setImageSize:CGSizeMake(28, 28)];
        [_black setBackgroundImage:nil forState:UIControlStateNormal];
        [_black setBackgroundImage:[UIImage imageNamed:@"theme5_border"] forState:UIControlStateSelected];
        [_black addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_black setImage:[UIImage imageNamed:@"theme5_read_bg"] forState:UIControlStateHighlighted];
        _black.imageView.layer.cornerRadius = 14;
    }
    return _black;
}

-(UIImageView *)greenIcon
{
    if (!_greenIcon) {
        _greenIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_eye"]];
    }
    return _greenIcon;
}

-(UIImageView *)blackIcon
{
    if (!_blackIcon) {
        _blackIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_moon"]];
    }
    return _blackIcon;
}

-(void)click:(RDLayoutButton *)sender
{
    self.selectTheme.selected = NO;
    sender.selected = YES;
    self.selectTheme = sender;
    RDThemeType type = RDWhiteTheme;
    if (sender == self.white) {
        type = RDWhiteTheme;
    }
    else if (sender == self.yellow){
        type = RDYellowTheme;
    }
    else if (sender == self.blue){
        type = RDBlueTheme;
    }
    else if (sender == self.green){
        type = RDGreenTheme;
    }
    else if (sender == self.black){
        type = RDBlackTheme;
    }
    [RDReadConfigManager sharedInstance].theme = type;
    [[RDReadConfigManager sharedInstance] archive];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = 35;
    CGFloat spacing = (self.width-40-35*5)/4;
    self.white.frame = CGRectMake(20, 0, width, self.height);
    self.yellow.frame = CGRectMake(self.white.right+spacing,0, width, self.height);
    self.blue.frame = CGRectMake(self.yellow.right+spacing, 0, width, self.height);
    self.green.frame = CGRectMake(self.blue.right+spacing, 0, width, self.height);
    self.black.frame = CGRectMake(self.green.right+spacing, 0, width, self.height);
    self.greenIcon.frame = CGRectMake(0, 0, 20, 20);
    self.greenIcon.center = CGPointMake(self.green.width/2, self.green.height/2);
    self.blackIcon.frame = CGRectMake(0, 0, 20, 20);
    self.blackIcon.center = CGPointMake(self.black.width/2, self.black.height/2);
}

@end
