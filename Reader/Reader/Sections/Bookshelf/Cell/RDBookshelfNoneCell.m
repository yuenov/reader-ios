//
//  RDBookshelfNoneCell.m
//  Reader
//
//  Created by yuenov on 2019/10/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBookshelfNoneCell.h"
#import "RDMainController.h"
#import "AppDelegate.h"
#import "RDMainController.h"
@interface RDBookshelfNoneCell ()
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIButton *button;
@end
@implementation RDBookshelfNoneCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        [self.contentView addSubview:self.tipLabel];
        [self.contentView addSubview:self.button];
    }
    return self;
}
-(UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.numberOfLines = 0;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSString *str = @"一日无书\n百事荒芜";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:RDBoldFont16,NSForegroundColorAttributeName:RDBlackColor} range:NSMakeRange(0, str.length)];
        _tipLabel.attributedText = attributedString;
    }
    return _tipLabel;
}

-(UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button setTitle:@"去找书" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage stretchableImageNamed:@"green_btn"] forState:UIControlStateNormal];
        _button.titleLabel.font = RDBoldFont16;
        [_button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

-(void)click{
    [RDAppDelegate.mainController setSelectedIndex:RDMainLibrary];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.button.frame = CGRectMake(0, 0, 240, 44);
    self.button.top = self.height/2;
    self.button.centerX = self.width/2;
    self.tipLabel.frame = CGRectMake(0, 0, self.width,[[self.tipLabel.attributedText mutableCopy] sizewithFont:RDBoldFont16 lineSpace:10 maxWidth:self.width].height);
    self.tipLabel.bottom = self.button.top-40;
}
@end
