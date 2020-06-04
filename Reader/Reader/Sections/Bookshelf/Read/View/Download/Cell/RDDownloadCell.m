//
//  RDDownloadCell.m
//  Reader
//
//  Created by yuenov on 2020/2/10.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDDownloadCell.h"

@interface RDDownloadCell ()
@property (nonatomic,strong) UILabel *charptersLabel;
@property (nonatomic,strong) UIView *separate;
@end

@implementation RDDownloadCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.charptersLabel];
        [self.contentView addSubview:self.separate];
    }
    return self;
}

-(void)setIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            self.charptersLabel.text = @"后50章";
            break;
        case 1:
            self.charptersLabel.text = @"后100章";
            break;
        case 2:
            self.charptersLabel.text = @"后200章";
            break;
        case 3:
            self.charptersLabel.text = @"下载全部章节";
            break;
        default:
            break;
    }
}

-(UILabel *)charptersLabel
{
    if (!_charptersLabel) {
        _charptersLabel = [[UILabel alloc] init];
        _charptersLabel.textColor = RDBlackColor;
        _charptersLabel.font = RDFont14;
    }
    return _charptersLabel;
}

-(UIView *)separate
{
    if (!_separate) {
        _separate = [[UIView alloc] init];
        _separate.backgroundColor = [UIColor colorWithHexValue:0xf0f0f2];
    }
    return _separate;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.charptersLabel.frame = CGRectMake(15, 0, self.width-30, self.height);
    self.separate.frame = CGRectMake(15, self.height-MinPixel, self.width-15, MinPixel);
}
@end
