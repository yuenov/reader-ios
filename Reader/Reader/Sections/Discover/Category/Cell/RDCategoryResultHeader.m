//
//  RDCategoryResultHeader.m
//  Reader
//
//  Created by yuenov on 2020/2/28.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDCategoryResultHeader.h"
@interface RDCategoryResultHeader ()
@property (nonatomic,strong) UIButton *recent;
@property (nonatomic,strong) UIButton *hot;
@property (nonatomic,strong) UIButton *end;
@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) UIView *bottomSeparate;
@end
@implementation RDCategoryResultHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bottomSeparate];
        [self.contentView addSubview:self.recent];
        [self.contentView addSubview:self.hot];
        [self.contentView addSubview:self.end];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(UIButton *)recent
{
    if (!_recent) {
        _recent = [[UIButton alloc] init];
        [_recent setTitle:@"最新" forState:UIControlStateNormal];
        [_recent setTitleColor:RDLightGrayColor forState:UIControlStateNormal];
        [_recent setTitleColor:RDGreenColor forState:UIControlStateSelected];
        _recent.titleLabel.font = RDBoldFont14;
        [_recent addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recent;
}

-(UIButton *)hot
{
    if (!_hot) {
        _hot = [[UIButton alloc] init];
        [_hot setTitle:@"最热" forState:UIControlStateNormal];
        [_hot setTitleColor:RDLightGrayColor forState:UIControlStateNormal];
        [_hot setTitleColor:RDGreenColor forState:UIControlStateSelected];
        _hot.titleLabel.font = RDBoldFont14;
        [_hot addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hot;
}

-(UIButton *)end
{
    if (!_end) {
        _end = [[UIButton alloc] init];
        [_end setTitle:@"完结" forState:UIControlStateNormal];
        [_end setTitleColor:RDLightGrayColor forState:UIControlStateNormal];
        [_end setTitleColor:RDGreenColor forState:UIControlStateSelected];
        _end.titleLabel.font = RDBoldFont14;
        [_end addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _end;
}
-(UIView *)bottomSeparate
{
    if (!_bottomSeparate) {
        _bottomSeparate = [[UIView alloc] init];
        _bottomSeparate.backgroundColor = RDLightSeparatorColor;
    }
    return _bottomSeparate;
}
-(void)setCategoryFilter:(RDCategoryFilter)categoryFilter
{
    _categoryFilter = categoryFilter;
    UIButton *sender;
    switch (categoryFilter) {
        case RDCategoryEndFilter:
            sender = self.end;
            break;
        case RDCategoryHotFilter:
            sender = self.hot;
            break;
        case RDCategoryNewFilter:
            sender = self.recent;
            break;
    }
    self.selectButton = sender;
    self.selectButton.selected = YES;
    [sender sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)click:(UIButton *)click
{
    if (self.selectButton == click) {
        return;
    }
    self.selectButton.selected = NO;
    self.selectButton = click;
    self.selectButton.selected = YES;
    
    RDCategoryFilter filter;
    if (click == self.recent) {
        filter = RDCategoryNewFilter;
    }
    else if (click == self.hot){
        filter = RDCategoryHotFilter;
    }
    else{
        filter = RDCategoryEndFilter;
    }
    if (self.filter) {
        self.filter(filter);
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.recent.frame = CGRectMake(15, 0, 50, self.height);
    self.hot.frame = CGRectMake(self.recent.right+10, 0, 50, self.height);
    self.end.frame = CGRectMake(self.hot.right+10, 0, 50, self.height);
    self.bottomSeparate.frame = CGRectMake(0, 0, self.width, MinPixel);
    self.bottomSeparate.bottom = self.height;
}
@end
