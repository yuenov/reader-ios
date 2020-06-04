//
//  RDSearchResultCell.m
//  Reader
//
//  Created by yuenov on 2020/2/20.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchResultCell.h"
#import "UIImageView+WebCache.h"
#import "NSAttributedString+rd_wid.h"

@interface RDSearchResultCell ()
@property (nonatomic,strong) NSMutableArray <UIButton *>*buttons;
@end

@implementation RDSearchResultCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.authorLabel];
        [self.contentView addSubview:self.coverImg];
        [self.contentView addSubview:self.bookName];
        [self.contentView addSubview:self.desLabel];
        for (int i = 0; i<3; i++) {
            UIButton *button = [self createButton];
            [self.buttons addObject:button];
            [self.contentView addSubview:button];
        }
    }
    return self;
}

-(NSMutableArray <UIButton *>*)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(UIButton *)createButton
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage stretchableImageNamed:@"lightblack_border_btn"] forState:UIControlStateNormal];
    [button setTitleColor:RDLightGrayColor forState:UIControlStateNormal];
    button.titleLabel.font = RDFont10;
    button.enabled = NO;
    return button;
}

-(void)setBook:(RDBookDetailModel *)book
{
    _book = book;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:[RDUtilities buildPicUrlWithPath:book.coverImg]] placeholderImage:[UIImage imageNamed:@"app_placeholder"]];
    
    if (book.title.length>0) {
        self.bookName.attributedText = [[NSAttributedString alloc] initWithString:book.title attributes:@{NSFontAttributeName:RDBoldFont16,NSForegroundColorAttributeName:RDBlackColor}];
    }
    else{
        self.bookName.attributedText = nil;
    }
    
    self.authorLabel.text = book.author;
    if (book.desc.length>0) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.book.desc attributes:@{
                NSFontAttributeName: RDFont12,
                NSParagraphStyleAttributeName: paragraphStyle,
        }];
        self.desLabel.attributedText = attributedString;
    }
    else{
        self.desLabel.attributedText = nil;
    }
    
    [self.buttons[0] setTitle:self.book.end?@"完结":@"连载" forState:UIControlStateNormal];
    [self.buttons[1] setTitle:self.book.word forState:UIControlStateNormal];
    [self.buttons[2] setTitle:self.book.category forState:UIControlStateNormal];
    self.buttons[1].hidden = self.book.word.length==0;
    self.buttons[2].hidden = self.book.category.length == 0;
    

}

-(void)setWord:(NSString *)word
{
    _word = word;
    if (word.length!=0 && self.book.title.length!=0) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.bookName.attributedText];
        NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:[NSString stringWithFormat:@"[%@]",word] options:NSRegularExpressionCaseInsensitive error:nil];
        [regex enumerateMatchesInString:self.book.title options:NSMatchingReportProgress range:NSMakeRange(0, [self.book.title length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            [attributedString addAttribute:(NSString*)NSForegroundColorAttributeName
                                      value:(id)[UIColor colorWithHexValue:0xf4855f]
                                      range:result.range];
        } ];
        self.bookName.attributedText = attributedString;
    }
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
        _authorLabel.font = RDBoldFont12;
        _authorLabel.textColor = RDLightGrayColor;
    }
    return _authorLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.coverImg.frame = CGRectMake(15, 15, 80, 110);
    
    self.bookName.frame = CGRectMake(self.coverImg.right+15, self.coverImg.top+3, self.width-30-self.coverImg.right, RDBoldFont16.lineHeight);
    
    self.authorLabel.frame = CGRectMake(self.bookName.left, self.bookName.bottom+7, self.bookName.width, RDBoldFont12.lineHeight);
    
    self.desLabel.frame = CGRectMake(self.bookName.left, self.authorLabel.bottom+8, self.bookName.width,RDFont12.lineHeight*2+5);
    
    self.buttons[0].frame = CGRectMake(self.bookName.left, 0, [self.book.end?@"完结":@"连载" sizeWithFont:RDFont10 maxWidth:CGFLOAT_MAX].width+10, RDFont10.lineHeight+8);
    self.buttons[0].bottom = self.coverImg.bottom;
    
    if (self.book.word.length>0) {
        self.buttons[1].frame = CGRectMake(self.buttons[0].right+4, self.buttons[0].top, [self.book.word sizeWithFont:RDFont10 maxWidth:CGFLOAT_MAX].width+10, RDFont10.lineHeight+8);
        self.buttons[2].frame = CGRectMake(self.buttons[1].right+4, self.buttons[0].top, [self.book.category sizeWithFont:RDFont10 maxWidth:CGFLOAT_MAX].width+10, RDFont10.lineHeight+8);
    }
    else{
        self.buttons[2].frame = CGRectMake(self.buttons[0].right+4, self.buttons[0].top, [self.book.category sizeWithFont:RDFont10 maxWidth:CGFLOAT_MAX].width+10, RDFont10.lineHeight+8);
    }
    
}
@end
