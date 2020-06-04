//
// Created by yuenov on 2019/10/25.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import "RDLibraryCategoryCell.h"
#import "RDLayoutButton.h"

@interface RDLibraryCategoryCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) RDLayoutButton *detailButton;

@end
@implementation RDLibraryCategoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.authorLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.detailButton];
        
        
    }
    return self;
}

-(void)setModel:(RDLibraryDetailModel *)model
{
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[RDUtilities buildPicUrlWithPath:model.coverImg]] placeholderImage:[UIImage imageNamed:@"app_placeholder"]];
    [self.nameLabel setText:model.title];
    [self.authorLabel setText:model.author];
    self.descLabel.attributedText = [NSMutableAttributedString strWithFont:RDFont13 lineSpace:6 string:model.desc];

}

- (UIImageView *)headImageView {
    if (!_headImageView){
        _headImageView = [[UIImageView alloc] init];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = RDBoldFont17;
        _nameLabel.textColor = RDBlackColor;
    }
    return _nameLabel;
}

- (UILabel *)authorLabel {
    if (!_authorLabel){
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = RDFont13;
        _authorLabel.textColor = RDGrayColor;
    }
    return _authorLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel){
        _descLabel = [[UILabel alloc] init];
        _descLabel.numberOfLines = 0;
        _descLabel.textColor = RDBlackColor;
        _descLabel.font = RDFont13;
    }
    return _descLabel;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView){
        _bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"libraby_jianbian"]];
    }
    return _bottomImageView;
}

- (RDLayoutButton *)detailButton {
    if (!_detailButton){
        _detailButton = [[RDLayoutButton alloc] init];
        [_detailButton setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [_detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [_detailButton setTitleColor:RDGreenColor forState:UIControlStateNormal];
        _detailButton.layoutType = WidButtonLayoutReverseHorizon;
        _detailButton.imageAndTitleInset = 9;
        _detailButton.imageSize = CGSizeMake(5, 10);
        _detailButton.titleLabel.font = RDFont15;
        _detailButton.userInteractionEnabled = NO;
    }
    return _detailButton;
}
+(CGFloat)categoryCellHeigh:(RDLibraryDetailModel *)model
{
    
    CGFloat height = [[NSMutableAttributedString strWithFont:RDFont13 lineSpace:6 string:model.desc] sizewithFont:RDFont13 lineSpace:6 maxWidth:ScreenWidth-60].height;
    CGFloat descHeight = height>160?160:height;
    
    return 15+45+20+descHeight+20+10+10;
}
-(void)layoutSubviews {
    [super layoutSubviews];

    self.contentView.frame = CGRectMake(15, 5, self.width-30, self.height-10);
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.shadowColor = RDLightGrayColor.CGColor;
    self.contentView.layer.shadowOpacity = 0.1;
    self.contentView.layer.shadowOffset = CGSizeMake(0,0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-3, -3, self.contentView.width + 6, self.contentView.height + 6)];
    self.contentView.layer.shadowPath = path.CGPath;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.headImageView.frame = CGRectMake(15, 15, 45, 55);
    self.nameLabel.frame = CGRectMake(self.headImageView.right+10, 27, self.contentView.width-15-45-10-15, RDBoldFont17.lineHeight);
    self.authorLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom+8, self.nameLabel.width, RDFont13.lineHeight);
    self.descLabel.frame = CGRectMake(15, self.headImageView.bottom+20, self.contentView.width-30, self.contentView.height-15-45-20-20);
    self.bottomImageView.frame = CGRectMake(0, 0, self.contentView.width-20, 60);
    self.bottomImageView.centerX = self.contentView.width/2;
    self.bottomImageView.bottom = self.contentView.height;
    self.detailButton.frame = CGRectMake(0, 30, 90, 20);
    self.detailButton.centerX = self.contentView.width/2;
    
}

@end
