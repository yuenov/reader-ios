//
//  RDDiscoverFooter.m
//  Reader
//
//  Created by yuenov on 2019/10/29.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDDiscoverFooter.h"
#import "RDUpdateControl.h"
#import "RDLibraryDetailModel.h"
#import "RDCategoryApi.h"
#import "RDDiscoverItemModel.h"
#import "RDCommCategoryController.h"
#import "RDDiscoverAllApi.h"
@interface RDDiscoverFooter ()
@property (nonatomic,strong) UIButton *all;
@property (nonatomic,strong) UIView *seprate;
@property (nonatomic,strong) RDUpdateControl *updateButton;
@property (nonatomic,strong) UIView *bottomSeparate;
@end
@implementation RDDiscoverFooter
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.all];
        [self addSubview:self.updateButton];
        [self addSubview:self.seprate];
        [self addSubview:self.bottomSeparate];
    }
    return self;
}
-(void)setModel:(RDDiscoverItemModel *)model
{
    _model = model;
    [self.updateButton endAnimation];
}
-(UIButton *)all{
    if (!_all) {
        _all = [[UIButton alloc] init];
        [_all setTitle:@"查看全部" forState:UIControlStateNormal];
        [_all setTitleColor:RDGreenColor forState:UIControlStateNormal];
        _all.titleLabel.font = RDFont15;
        [_all addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _all;
}


-(RDUpdateControl *)updateButton
{
    if (!_updateButton) {
        _updateButton = [[RDUpdateControl alloc] init];
        _updateButton.label.text = @"换一批";
        _updateButton.label.textColor = RDGreenColor;
        _updateButton.label.font = RDFont15;
        _updateButton.spacing = 5;
        _updateButton.imageSize = CGSizeMake(15, 15);
        [_updateButton addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _updateButton;
}

-(UIView *)seprate{
    if (!_seprate) {
        _seprate = [[UIView alloc] init];
        _seprate.backgroundColor = RDSeparatorColor;
    }
    return _seprate;
}
-(UIView *)bottomSeparate
{
    if (!_bottomSeparate) {
        _bottomSeparate = [[UIView alloc] init];
        _bottomSeparate.backgroundColor = [UIColor colorWithHexValue:0xfafafa];
    }
    return _bottomSeparate;
}
-(void)click:(UIButton *)sender
{
    if (sender == self.all) {
        RDCommCategoryController *controller = [[RDCommCategoryController alloc] init];
        controller.catagoryId = [self.model.categoryId integerValue];
        controller.categoryName = self.model.title;
        controller.type = self.model.type;
        controller.pageType = self.pageType;
        [[RDUtilities getCurrentVC].navigationController pushViewController:controller animated:YES];
    }
}
-(void)update:(RDUpdateControl *)sender
{
    [sender beginAnimation];
    RDDiscoverItemModel *model = self.model;
    model.page++;
    if (self.pageType == RDPageDiscoverType) {
        RDDiscoverAllApi *api = [[RDDiscoverAllApi alloc] init];
        api.page = model.page;
        api.size = model.size;
        api.type = model.type;
        api.categoryId = [model.categoryId integerValue];
        [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
            [sender endAnimation];
            if (!error) {
                NSArray *list = api.list;
                if (list.count<model.size) {
                    model.page = 0;
                }
                if (list.count>0) {
                    model.categories = list;
                    if (self.needReload) {
                        self.needReload(model);
                    }
                }
            }
        }];
    }
    else if (self.pageType == RDPageEndType){
        RDCategoryApi *api = [[RDCategoryApi alloc] init];
        api.page = model.page;
        api.size = model.size;
        api.type = [model.categoryId integerValue];
        api.filter = RDCategoryEndFilter;
        [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
            [sender endAnimation];
            if (!error) {
                NSArray *list = api.categories;
                if (list.count<model.size) {
                    model.page = 0;
                }
                if (list.count>0) {
                    model.categories = list;
                    if (self.needReload) {
                        self.needReload(model);
                    }
                }
            }
        }];

        
    }
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.all.frame = CGRectMake(0, 0, self.width/2-MinPixel, self.height-7);
    self.seprate.frame = CGRectMake(self.all.right, 0, MinPixel, 15);
    self.seprate.centerY = self.height/2;
    self.updateButton.frame = CGRectMake(self.seprate.right, 0, self.width/2, self.height-7);
    self.bottomSeparate.frame = CGRectMake(0, 0, self.width, 5);
    self.bottomSeparate.bottom = self.height;
    
}
@end
