//
//  RDBookDetailRecomCell.m
//  Reader
//
//  Created by yuenov on 2019/10/31.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBookDetailRecomCell.h"
#import "RDLayoutButton.h"
#import "RDDiscoverCell.h"
#import "RDUpdateControl.h"
#import "RDBookRecommendApi.h"
#import "RDCommCategoryController.h"
#import "RDBookDetailController.h"
@interface RDBookDetailRecomCell ()
@property (nonatomic, strong) UILabel *recomLabel;
@property (nonatomic, strong) RDLayoutButton *layoutButton;
@property (nonatomic, strong) UIView *recomContent;
@property (nonatomic, strong) RDUpdateControl *updateButton;
@property (nonatomic, strong) UIView *seprate1;
@property (nonatomic, strong) UIView *seprate2;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic,strong) UIView *bottomSeparate;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger size;
@end

#define kItemCount ([RDUtilities iPad] ? 6 : 3)

@implementation RDBookDetailRecomCell
@synthesize model = _model;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self.contentView addSubview:self.recomLabel];
        [self.contentView addSubview:self.layoutButton];
        [self.contentView addSubview:self.recomContent];
        [self.contentView addSubview:self.updateButton];
        [self.contentView addSubview:self.seprate1];
        [self.contentView addSubview:self.seprate2];
        [self.contentView addSubview:self.bottomSeparate];
        self.page = 2;
        self.size = 6;
    }
    return self;
}

-(void)updateConstraints {

    [self.recomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
    }];
    [self.layoutButton mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.right.mas_equalTo(-15);
       make.width.mas_equalTo(75);
       make.height.mas_equalTo(RDFont14.lineHeight);
       make.centerY.equalTo(self.recomLabel);
    }];
    [self.seprate1 mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.recomLabel.mas_bottom).offset(15);
       make.left.right.equalTo(self.contentView);
       make.height.mas_equalTo(MinPixel);
    }];
    [self.recomContent mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.seprate1.mas_bottom).offset(15);
       make.left.right.equalTo(self.contentView);
    }];
    [self.seprate2 mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.recomContent.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(MinPixel);
    }];
    [self.updateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.seprate2.mas_bottom);
       make.height.mas_equalTo(45);
       make.left.right.equalTo(self.contentView);
        make.bottom.mas_equalTo(-15);
    }];
    [self.bottomSeparate mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.updateButton.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(15);
    }];
    CGFloat width = (ScreenWidth-(kItemCount+1)*15)/kItemCount;
    CGFloat height = width*1.3+55;
    NSInteger row = 0;
    NSInteger line = 0;
    for (int i = 0; i <self.items.count ; ++i) {
        row = i%kItemCount;
        line = i/kItemCount;
        RDDiscoverCell *item = self.items[i];
        [item mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(15+row*(15+width));
           make.top.mas_equalTo(line*(15+height));
           make.width.mas_equalTo(width);
           make.height.mas_equalTo(height);
            if (i == self.items.count-1) {
                make.bottom.equalTo(self.recomContent);
            }
        }];
        
        
    }

    [super updateConstraints];
}

-(void)setModel:(RDBookDetailModel *)model
{
    _model = model;
    if ([model.recommend isEqualToArray:self.dataSource]){
        return;
    }
    self.dataSource = model.recommend;
    [self.recomContent removeAllSubviews];
    [self.items removeAllObjects];
    for (int i=0 ;i<self.dataSource.count;i++){
        RDDiscoverCell *view = [[RDDiscoverCell alloc] init];
        view.model = self.dataSource[i];
        [self.recomContent addSubview:view];
        [self.items addObjectSafely:view];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jump:)]];
    }

}


-(void)jump:(UITapGestureRecognizer *)tap{
    RDDiscoverCell *view = (RDDiscoverCell *)tap.view;
    RDLibraryDetailModel *model = view.model;
    RDBookDetailController *controller = [[RDBookDetailController alloc] init];
    controller.bookId = [model.bookId integerValue];
    [[RDUtilities getCurrentVC].navigationController pushViewController:controller animated:YES];
}

-(void)update:(RDUpdateControl *)sender
{
    [sender beginAnimation];

    RDBookRecommendApi *api = [[RDBookRecommendApi alloc] init];
    api.page = self.page;
    api.size = self.size;
    api.bookId = self.model.bookId;
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        [sender endAnimation];
        if (!error) {
            NSArray *list = api.list;
            if (list.count < self.model.recommend.count) {
                self.page = 1;
            }
            else{
                self.page++;
            }
            if (list.count>0) {
                self.model.recommend = list;
                if (self.needReload) {
                    self.needReload(self.model);
                }
            }
        }
    }];
}

-(void)all
{
    RDCommCategoryController *controller = [[RDCommCategoryController alloc] init];
    controller.bookId = self.model.bookId;
    controller.pageType = RDPageRecommendType;
    [[RDUtilities getCurrentVC].navigationController pushViewController:controller animated:YES];
}


- (UILabel *)recomLabel {
    if (!_recomLabel){
        _recomLabel = [[UILabel alloc] init];
        _recomLabel.font = RDBoldFont16;
        _recomLabel.textColor = RDBlackColor;
        _recomLabel.text = @"热门推荐";
    }
    return _recomLabel;
}

- (RDLayoutButton *)layoutButton {
    if (!_layoutButton){
        _layoutButton = [[RDLayoutButton alloc] init];
        [_layoutButton setImage:[UIImage imageNamed:@"me_arrow"] forState:UIControlStateNormal];
        [_layoutButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [_layoutButton setTitleColor:RDGrayColor forState:UIControlStateNormal];
        _layoutButton.layoutType = WidButtonLayoutReverseHorizon;
        _layoutButton.imageAndTitleInset = 5;
        _layoutButton.imageSize = CGSizeMake(10, 12);
        _layoutButton.titleLabel.font = RDFont14;
        [_layoutButton addTarget:self action:@selector(all) forControlEvents:UIControlEventTouchUpInside];
    }
    return _layoutButton;
}

- (UIView *)recomContent {
    if (!_recomContent){
        _recomContent = [[UIView alloc] init];
    }
    return _recomContent;
}

-(RDUpdateControl *)updateButton
{
    if (!_updateButton) {
        _updateButton = [[RDUpdateControl alloc] init];
        _updateButton.label.text = @"换一换";
        _updateButton.label.textColor = RDGreenColor;
        _updateButton.label.font = RDFont14;
        _updateButton.spacing = 5;
        _updateButton.imageSize = CGSizeMake(15, 15);
        [_updateButton addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _updateButton;
}

- (UIView *)seprate1 {
    if (!_seprate1){
        _seprate1 = [[UIView alloc] init];
        _seprate1.backgroundColor = RDLightSeparatorColor;
    }
    return _seprate1;
}

- (UIView *)seprate2 {
    if (!_seprate2){
        _seprate2 = [[UIView alloc] init];
        _seprate2.backgroundColor = RDLightSeparatorColor;
    }
    return _seprate2;
}
-(NSMutableArray *)items {
    if (!_items){
        _items = [NSMutableArray array];
    }
    return _items;
}
-(UIView *)bottomSeparate
{
    if (!_bottomSeparate) {
        _bottomSeparate = [[UIView alloc] init];
        _bottomSeparate.backgroundColor = [UIColor colorWithHexValue:0xf5f7fa];
    }
    return _bottomSeparate;
}

@end
