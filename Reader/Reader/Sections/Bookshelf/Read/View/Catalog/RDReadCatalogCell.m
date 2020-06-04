//
//  RDReadCatalogCell.m
//  Reader
//
//  Created by yuenov on 2019/11/20.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDReadCatalogCell.h"
#import "RDCharpterDataManager.h"
@interface RDReadCatalogCell ()
@property (nonatomic,strong) UILabel *chapterLabel;
@property (nonatomic,strong) UIView *separate;
@end

@implementation RDReadCatalogCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.chapterLabel];
        [self.contentView addSubview:self.separate];
        [self.contentView setBackgroundColor:[UIColor colorWithHexValue:0xe2e2e2]];
        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    }
    return self;
}

-(void)setModel:(RDCharpterModel *)model
{
    _model = model;
    self.chapterLabel.text = model.name;
    RDCharpterModel *charpterModel = [RDCharpterDataManager getCharpterWithBookId:model.bookId charpterId:model.charpterId];
    (charpterModel.content.length == 0) ? (_chapterLabel.textColor = RDLightGrayColor) : (_chapterLabel.textColor = RDBlackColor);
    
}

-(UILabel *)chapterLabel
{
    if (!_chapterLabel) {
        _chapterLabel = [[UILabel alloc] init];
        _chapterLabel.font = RDFont15;
        _chapterLabel.textColor = RDLightGrayColor;
    }
    return _chapterLabel;
}

-(UIView *)separate
{
    if (!_separate) {
        _separate = [[UIView alloc] init];
        _separate.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2];
    }
    return _separate;
}

-(void)tap
{
    if ([self.delegate respondsToSelector:@selector(didSelectCharpter:)]) {
        [self.delegate didSelectCharpter:self.model];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.chapterLabel.frame = CGRectMake(20, 0, self.width-40, RDFont15.lineHeight);
    self.chapterLabel.centerY = self.height/2;
    self.separate.frame = CGRectMake(20, 0, self.width-40, MinPixel);
    self.separate.bottom = self.height;
}

@end
