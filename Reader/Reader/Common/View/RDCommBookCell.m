//
//  RDCommBookCell.m
//  Reader
//
//  Created by yuenov on 2020/2/26.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDCommBookCell.h"
#import "UIImageView+WebCache.h"
#import "RDBookDetailModel.h"
@interface RDCommBookCell ()
@property (nonatomic,strong) UILabel *bookName;
@property (nonatomic,strong) UILabel *desLabel;
@property (nonatomic,strong) UILabel *authorLabel;
@property (nonatomic,strong) NSArray <UILabel *> *labels;
@property (nonatomic,strong) UIView *separate;
@end
@implementation RDCommBookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.coverImg];
        [self.contentView addSubview:self.bookName];
        [self.contentView addSubview:self.desLabel];
        [self.contentView addSubview:self.authorLabel];
        [self.contentView addSubview:self.separate];
        UILabel *label0 = [self createLabel];
        UILabel *label1 = [self createLabel];
        self.labels = @[label0,label1];
        [self.contentView addSubview:label0];
        [self.contentView addSubview:label1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(UILabel *)createLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RDLightGrayColor;
    label.font = RDFont10;
    label.layer.cornerRadius = 2;
    label.layer.borderColor = RDLightGrayColor.CGColor;
    label.layer.borderWidth = MinPixel;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(void)setModel:(id)model
{
    _model = model;
    if ([model isKindOfClass:RDLibraryDetailModel.class]) {
        RDLibraryDetailModel *content = model;
        [self setCoverImg:content.coverImg title:content.title author:content.author desc:content.desc end:content.end category:content.category];
    }
    else if ([model isKindOfClass:RDBookDetailModel.class]){
        RDBookDetailModel *content = model;
        [self setCoverImg:content.coverImg title:content.title author:content.author desc:content.desc end:content.end category:content.category];
    }
    
}

-(void)setCoverImg:(NSString *)coverImg title:(NSString *)title author:(NSString *)author desc:(NSString *)desc end:(BOOL)end category:(NSString *)category
{
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:[RDUtilities buildPicUrlWithPath:coverImg]] placeholderImage:[UIImage imageNamed:@"app_placeholder"]];
    self.bookName.text = title;
    self.authorLabel.text = author;

    if (desc.length>0) {

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:desc attributes:@{
                NSFontAttributeName: RDFont12,
                NSParagraphStyleAttributeName: paragraphStyle,
        }];
        self.desLabel.attributedText = attributedString;
    }
    else{
        self.desLabel.attributedText = nil;
    }
    if (end) {
        self.labels[0].text = @"完结";
        self.labels[0].textColor = RDGreenColor;
        self.labels[0].layer.borderColor = RDGreenColor.CGColor;
    }
    else{
        self.labels[0].text = @"连载";
        self.labels[0].textColor = [UIColor colorWithHexValue:0x76aae4];
        self.labels[0].layer.borderColor = [UIColor colorWithHexValue:0x76aae4].CGColor;
    }
    self.labels[1].hidden = !(category.length>0);
    self.labels[1].text = category;
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
        _bookName.font = RDFont16;
        _bookName.textColor = RDBlackColor;
    }
    return _bookName;
}

-(UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = RDFont12;
        _desLabel.textColor = RDLightGrayColor;
        _desLabel.numberOfLines = 2;
    }
    return _desLabel;
}
- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = RDFont12;
        _authorLabel.textColor = RDLightGrayColor;
    }
    return _authorLabel;
}
-(UIView *)separate
{
    if (!_separate) {
        _separate = [[UIView alloc] init];
        _separate.backgroundColor = RDLightSeparatorColor;
    }
    return _separate;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.coverImg.frame = CGRectMake(15, 20, 60, 80);
    
    self.bookName.frame = CGRectMake(self.coverImg.right+15, self.coverImg.top, self.width-30-self.coverImg.right, RDFont16.lineHeight);
    
    self.desLabel.frame = CGRectMake(self.bookName.left, self.bookName.bottom+7, self.bookName.width,RDFont12.lineHeight*2+4);
    
    self.authorLabel.frame = CGRectMake(self.bookName.left, 0, self.bookName.width, RDFont16.lineHeight);
    self.authorLabel.bottom = self.coverImg.bottom;
    self.labels[1].frame = CGRectMake(0, 0, [self.labels[1].text sizeWithFont:RDFont10 maxWidth:CGFLOAT_MAX].width+8, RDFont10.lineHeight+4);
    self.labels[1].right = self.width-15;
    self.labels[1].centerY = self.authorLabel.centerY;
    self.labels[0].frame = CGRectMake(0, self.labels[1].top, [self.labels[0].text sizeWithFont:RDFont10 maxWidth:CGFLOAT_MAX].width+8, RDFont10.lineHeight+4);
    self.labels[0].right = self.labels[1].left-3;
    _separate.frame = CGRectMake(15, 0, self.width-15, MinPixel);
    _separate.bottom = self.height;
}
@end
