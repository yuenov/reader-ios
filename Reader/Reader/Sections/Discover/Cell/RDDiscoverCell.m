//
//  RDDiscoverCell.m
//  Reader
//
//  Created by yuenov on 2019/10/28.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDDiscoverCell.h"
@interface RDDiscoverCell ()
@property (nonatomic,strong) UIImageView *coverView;
@property(nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *authorLabel;

@end
@implementation RDDiscoverCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.coverView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.authorLabel];
        
    }
    return self;
}

-(void)setModel:(RDLibraryDetailModel *)model
{
    _model = model;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:[RDUtilities buildPicUrlWithPath:model.coverImg]] placeholderImage:[UIImage imageNamed:@"app_placeholder"]];
    self.nameLabel.text = model.title;
    self.authorLabel.text = model.author;
    
}
-(UIImageView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
        _coverView.contentMode = UIViewContentModeScaleToFill;
        _coverView.clipsToBounds = YES;
        _coverView.layer.cornerRadius = 3;
        
    }
    return _coverView;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = RDBoldFont13;
        _nameLabel.textColor = RDBlackColor;
    }
    return _nameLabel;
}
-(UILabel *)authorLabel{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = RDFont12;
        _authorLabel.textColor = RDLightGrayColor;
    }
    return _authorLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.coverView.frame = CGRectMake(0, 0, self.width, self.width*1.3);
    self.nameLabel.frame = CGRectMake(0, self.coverView.bottom+10, self.width, RDBoldFont13.lineHeight);
    self.authorLabel.frame = CGRectMake(0, self.nameLabel.bottom+6, self.width, RDFont12.lineHeight);
    
}
@end
