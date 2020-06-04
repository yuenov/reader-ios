//
//  RDSearchHistoryCell.m
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchHotCell.h"
#import "RDBookDetailModel.h"
#import "UIImageView+WebCache.h"
#import "RDBookDetailController.h"
@interface RDSearchHotCell ()
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) UIImageView *coverImg;
@property (nonatomic,strong) UILabel *bookName;
@property (nonatomic,strong) UILabel *desLabel;
@end

@implementation RDSearchHotCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.numLabel];
        [self.contentView addSubview:self.coverImg];
        [self.contentView addSubview:self.bookName];
        [self.contentView addSubview:self.desLabel];
    }
    return self;
}

-(void)setBookDetail:(RDBookDetailModel *)bookDetail
{
    _bookDetail = bookDetail;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:[RDUtilities buildPicUrlWithPath:bookDetail.coverImg]] placeholderImage:[UIImage imageNamed:@"app_placeholder"]];
    [self.bookName setText:bookDetail.title];
    [self.desLabel setText:bookDetail.desc];
}

-(void)setIndex:(NSUInteger)index
{
    _index = index;
    self.numLabel.text = @(index).stringValue;
    if (index < 4) {
        self.numLabel.textColor = [UIColor colorWithHexValue:0xff533a];
    }
    else{
        self.numLabel.textColor = RDLightGrayColor;
    }
}

-(UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
//        _numLabel.font = [UIFont italicSystemFontOfSize:15];
        _numLabel.font = RDBoldFont16;
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

-(UIImageView *)coverImg
{
    if (!_coverImg) {
        _coverImg = [[UIImageView alloc] init];
        _coverImg.contentMode = UIViewContentModeScaleToFill;
        _coverImg.layer.cornerRadius = 3;
        _coverImg.clipsToBounds = YES;
    }
    return _coverImg;
}

-(UILabel *)bookName
{
    if (!_bookName) {
        _bookName = [[UILabel alloc] init];
        _bookName.font = RDBoldFont16;
        _bookName.textColor = RDBlackColor;
    }
    return _bookName;
}

-(UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = RDBoldFont12;
        _desLabel.textColor = RDLightGrayColor;
    }
    return _desLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.numLabel.frame = CGRectMake(0, 0, 45, self.height);
    self.coverImg.frame = CGRectMake(self.numLabel.right, 10, 45, self.height-20);
    self.bookName.frame = CGRectMake(self.coverImg.right+15, self.coverImg.top+12, self.width-self.coverImg.right-30, RDBoldFont16.lineHeight);
    self.desLabel.frame = CGRectMake(self.bookName.left, self.bookName.bottom+8, self.bookName.width, RDBoldFont12.lineHeight);
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (!selected) {
        return;
    }
    RDBookDetailController *controller = [[RDBookDetailController alloc] init];
    controller.bookId = self.bookDetail.bookId;
    [[RDUtilities getCurrentVC].navigationController pushViewController:controller animated:YES];
}

@end
