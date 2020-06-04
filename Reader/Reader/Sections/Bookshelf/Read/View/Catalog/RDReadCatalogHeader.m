//
//  RDReadCatalogHeader.m
//  Reader
//
//  Created by yuenov on 2019/11/20.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDReadCatalogHeader.h"
#import "RDLayoutButton.h"

@interface RDReadCatalogHeader ()

@property (nonatomic,strong) RDLayoutButton *button;
@end

@implementation RDReadCatalogHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.nameLabel];
        [self addSubview:self.button];
    }
    return self;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = RDFont17;
        _nameLabel.textColor = RDBlackColor;
    }
    return _nameLabel;
}

-(RDLayoutButton *)button
{
    if (!_button) {
        _button = [[RDLayoutButton alloc] init];
        [_button setImage:[UIImage imageNamed:@"book_down"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"book_up"] forState:UIControlStateSelected];
        _button.imageSize = CGSizeMake(20, 20);
        [_button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

-(void)click:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        if ([self.delegate respondsToSelector:@selector(descending)]) {
            [self.delegate descending];
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(aesedecing)]) {
            [self.delegate aesedecing];
        }
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.nameLabel.frame = CGRectMake(20, 0, self.width-65, RDFont17.lineHeight);
    self.nameLabel.centerY = self.height/2;
    self.button.frame = CGRectMake(0, 0, 30, 30);
    self.button.right = self.width-20;
    self.button.centerY = self.height/2;
}

@end
