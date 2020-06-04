//
//  RDBookDetailCoverCell.m
//  Reader
//
//  Created by yuenov on 2019/10/31.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBookDetailCoverCell.h"
#import "RDDateUtil.h"
#import "RDCatalogController.h"
#import "RDCharpterDataManager.h"
#import "RDReadPageViewController.h"
@interface RDBookDetailCoverCellItem : UIView
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) UIImageView *arrow;
@property (nonatomic,strong) UILabel *alertLabel;
@property (nonatomic,strong) UIView *separate;
-(void)setIcon:(UIImage *)icon title:(NSString *)title desc:(NSString *)desc alert:(NSString *)alert;

@end


@interface RDBookDetailCoverCell ()
@property (nonatomic,strong) UIImageView *backgroundImage;
@property(nonatomic,strong) UIImageView *coverImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *authorLabel;
@property (nonatomic,strong) UILabel *categoryLabel;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) UIVisualEffectView *toolbar;
@property (nonatomic,strong) UIView *separate;
@property (nonatomic,strong) UIImageView *toobarImageView;

@property (nonatomic,strong) RDBookDetailCoverCellItem *updateView;
@property (nonatomic,strong) RDBookDetailCoverCellItem *menuView;
@end

@implementation RDBookDetailCoverCell
@synthesize model = _model;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.backgroundImage];
        [self.backgroundImage addSubview:self.toolbar];
        [self.toolbar.contentView addSubview:self.toobarImageView];
        [self.toolbar.contentView addSubview:self.coverImageView];
        [self.toolbar.contentView addSubview:self.nameLabel];
        [self.toolbar.contentView addSubview:self.authorLabel];
        [self.toolbar.contentView addSubview:self.categoryLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.updateView];
        [self.contentView addSubview:self.menuView];
        [self.contentView addSubview:self.separate];
        [self.menuView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenu)]];
        [self.updateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEnd)]];
        [self makeConstraint];
    }
    return self;
}

-(void)setModel:(RDBookDetailModel *)model
{
    _model = model;
    [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:[RDUtilities buildPicUrlWithPath:model.coverImg]] placeholderImage:nil];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[RDUtilities buildPicUrlWithPath:model.coverImg]] placeholderImage:[UIImage imageNamed:@"app_placeholder"]];
    self.nameLabel.text = model.title;
    self.authorLabel.text = model.author;
    self.categoryLabel.text = [NSString stringWithFormat:@"%@ %@",model.category,model.word];
    self.descLabel.attributedText = [NSMutableAttributedString strWithFont:RDFont14 lineSpace:RDlineSpace string:model.desc];
    NSString *date = model.time==0?nil:[RDDateUtil lastUpdateTimeWith:model.time];
    NSString *alert = model.updateEnd?@"已完结":date?:@"";
    [self.updateView setIcon:[UIImage imageNamed:@"book_detail_update"] title:@"最新" desc:model.charpter alert:alert];
    [self.menuView setIcon:[UIImage imageNamed:@"book_detail_menu"] title:@"目录" desc:[NSString stringWithFormat:@"共%ld章",(long)model.total] alert:nil];
    
}

-(void)clickMenu
{
    RDCatalogController *category = [[RDCatalogController alloc] init];
    category.model = self.model;
    [[RDUtilities getCurrentVC].navigationController pushViewController:category animated:YES];
}

-(void)clickEnd
{
    [RDReadHelper beginReadWithBookDetail:self.model charpterId:self.model.updateCharpterId];
}

-(void)makeConstraint{
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
    }];
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.backgroundImage);
    }];
    [self.toobarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.toolbar);
    }];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIView navigationBar]+[UIView statusBar]);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(130);
        make.bottom.equalTo(self.toolbar);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView);
        make.left.equalTo(self.coverImageView.mas_right).offset(12);
        make.right.equalTo(self.toolbar.mas_right).offset(-15);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.nameLabel);
    }];
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.authorLabel);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImage.mas_bottom).offset(25);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];

    [self.updateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(45);
    }];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.updateView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(45);
    }];
    [self.separate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(7);
        make.bottom.equalTo(self.contentView);
    }];
}

-(UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.clipsToBounds = YES;
        _coverImageView.layer.cornerRadius = 3;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

-(UIImageView *)backgroundImage
{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc] init];
        _backgroundImage.clipsToBounds = YES;
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImage;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = RDBoldFont19;
        _nameLabel.textColor = RDBlackColor;
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

-(UILabel *)authorLabel{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = RDFont12;
        _authorLabel.textColor = RDGrayColor;
    }
    return _authorLabel;
}

-(UILabel *)categoryLabel{
    if (!_categoryLabel) {
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.font = RDFont12;
        _categoryLabel.textColor = RDGrayColor;
    }
    return _categoryLabel;
}

-(UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = RDFont14;
        _descLabel.textColor = RDBlackColor;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}


-(UIVisualEffectView *)toolbar
{
    if (!_toolbar) {
        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _toolbar = [[UIVisualEffectView alloc]initWithEffect:beffect];
    }
    return _toolbar;
}

-(UIView *)separate
{
    if (!_separate) {
        _separate = [[UIView alloc] init];
        _separate.backgroundColor = [UIColor colorWithHexValue:0xf5f7fa];
    }
    return _separate;
}

-(UIImageView *)toobarImageView
{
    if (!_toobarImageView) {
        _toobarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"libraby_jianbian"]];
    }
    return _toobarImageView;
}

-(RDBookDetailCoverCellItem *)updateView
{
    if (!_updateView) {
        _updateView = [[RDBookDetailCoverCellItem alloc] init];
    }
    return _updateView;
}

-(RDBookDetailCoverCellItem *)menuView
{
    if (!_menuView) {
        _menuView = [[RDBookDetailCoverCellItem alloc] init];
    }
    return _menuView;
}

@end

@implementation RDBookDetailCoverCellItem

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.descLabel];
        [self addSubview:self.alertLabel];
        [self addSubview:self.arrow];
        [self addSubview:self.separate];
        [self makeConstraint];
        
    }
    return self;
}
-(void)setIcon:(UIImage *)icon title:(NSString *)title desc:(NSString *)desc alert:(NSString *)alert
{
    self.imageView.image = icon;
    self.titleLabel.text = title;
    self.descLabel.text = desc;
    self.alertLabel.text = alert;
}
-(void)makeConstraint
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(15);
        make.centerY.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(15);
        make.centerY.equalTo(self);
        make.right.equalTo(self.alertLabel.mas_left);
    }];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(15);
        make.centerY.equalTo(self);
    }];
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrow.mas_left).offset(-7);
        make.centerY.equalTo(self);
    }];
    [self.alertLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.separate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.mas_equalTo(15);
        make.right.equalTo(self);
        make.height.mas_equalTo(MinPixel);
    }];
}
-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        
    }
    return _imageView;
}
-(UIImageView *)arrow
{
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        _arrow.image = [UIImage imageNamed:@"left_arrow"];
        
    }
    return _arrow;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = RDFont15;
        _titleLabel.textColor = RDBlackColor;
    }
    return _titleLabel;
}
-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = RDFont12;
        _descLabel.textColor = RDLightGrayColor;
    }
    return _descLabel;
}
-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.font = RDFont12;
        _alertLabel.textColor = RDGreenColor;
        _alertLabel.textAlignment = NSTextAlignmentRight;
    }
    return _alertLabel;
}
-(UIView *)separate
{
    if (!_separate) {
        _separate = [[UIView alloc] init];
        _separate.backgroundColor = [UIColor colorWithHexValue:0xebebeb];
    }
    return _separate;
}
@end
