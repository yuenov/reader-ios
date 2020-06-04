//
//  RDDiscoverCategoryView.m
//  Reader
//
//  Created by yuenov on 2019/10/28.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDDiscoverCategoryView.h"
#import "RDLayoutButton.h"
#import "RDRefreshHeader.h"
#import "RDCategoryController.h"
#import "RDRankViewController.h"
#import "RDEndController.h"
#import "RDSpecialController.h"

@interface RDDiscoverCategoryView ()
@property (nonatomic,strong) RDLayoutButton *category;
@property (nonatomic,strong) RDLayoutButton *rank;
@property (nonatomic,strong) RDLayoutButton *end;
@property (nonatomic,strong) RDLayoutButton *recommend;
@end

@implementation RDDiscoverCategoryView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.category];
        [self addSubview:self.rank];
        [self addSubview:self.end];
        [self addSubview:self.recommend];
    }
    return self;
}

-(RDLayoutButton *)category
{
    if (!_category) {
        _category = [[RDLayoutButton alloc] init];
        [_category setImageSize:CGSizeMake(35, 35)];
        [_category setLayoutType:WidButtonLayoutVertical];
        [_category setImage:[UIImage imageNamed:@"faxian_fenlei"] forState:UIControlStateNormal];
        [_category setTitle:@"分类" forState:UIControlStateNormal];
        [_category setImageAndTitleInset:10];
        [_category setTitleColor:RDLightGrayColor forState:UIControlStateNormal];
        _category.titleLabel.font = RDFont12;
        [_category addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _category;
}
-(RDLayoutButton *)rank
{
    if (!_rank) {
        _rank = [[RDLayoutButton alloc] init];
        [_rank setImageSize:CGSizeMake(35, 35)];
        [_rank setLayoutType:WidButtonLayoutVertical];
        [_rank setImage:[UIImage imageNamed:@"faxian_bangdan"] forState:UIControlStateNormal];
        [_rank setTitle:@"榜单" forState:UIControlStateNormal];
        [_rank setImageAndTitleInset:10];
        [_rank setTitleColor:RDLightGrayColor forState:UIControlStateNormal];
        _rank.titleLabel.font = RDFont12;
        [_rank addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rank;
}
-(RDLayoutButton *)end
{
    if (!_end) {
        _end = [[RDLayoutButton alloc] init];
        [_end setImageSize:CGSizeMake(35, 35)];
        [_end setLayoutType:WidButtonLayoutVertical];
        [_end setImage:[UIImage imageNamed:@"faxian_wanben"] forState:UIControlStateNormal];
        [_end setTitle:@"完本" forState:UIControlStateNormal];
        [_end setImageAndTitleInset:10];
        [_end setTitleColor:RDLightGrayColor forState:UIControlStateNormal];
        _end.titleLabel.font = RDFont12;
        [_end addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _end;
}
-(RDLayoutButton *)recommend
{
    if (!_recommend) {
        _recommend = [[RDLayoutButton alloc] init];
        [_recommend setImageSize:CGSizeMake(35, 35)];
        [_recommend setLayoutType:WidButtonLayoutVertical];
        [_recommend setImage:[UIImage imageNamed:@"faxian_zhuanti"] forState:UIControlStateNormal];
        [_recommend setTitle:@"专题" forState:UIControlStateNormal];
        [_recommend setImageAndTitleInset:10];
        [_recommend setTitleColor:RDLightGrayColor forState:UIControlStateNormal];
        _recommend.titleLabel.font = RDFont12;
        [_recommend addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recommend;
}

-(void)click:(RDLayoutButton *)sender{
    
    if (sender == self.category) {
        RDCategoryController *controler = [[RDCategoryController alloc] init];
        [[RDUtilities getCurrentVC].navigationController pushViewController:controler animated:YES];
    }
    else if (sender == self.rank){
        RDRankViewController *controler = [[RDRankViewController alloc] init];
        [[RDUtilities getCurrentVC].navigationController pushViewController:controler animated:YES];
    }
    else if (sender == self.end){
        RDEndController *controller = [[RDEndController alloc] init];
        [[RDUtilities getCurrentVC].navigationController pushViewController:controller animated:YES];
    }
    else if (sender == self.recommend){
        RDSpecialController *controller = [[RDSpecialController alloc] init];
        [[RDUtilities getCurrentVC].navigationController pushViewController:controller animated:YES];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.category.frame = CGRectMake(0, 10, self.width/4, 55);
    self.rank.frame = CGRectMake(self.category.right, 10, self.width/4, 55);
    self.end.frame = CGRectMake(self.rank.right, 10, self.width/4, 55);
    self.recommend.frame = CGRectMake(self.end.right, 10, self.width/4, 55);
}
@end
