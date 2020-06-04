//
//  RDSearchResultBaseCell.m
//  Reader
//
//  Created by yuenov on 2020/2/20.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchResultBaseCell.h"

@interface RDSearchResultBaseCell ()
@property (nonatomic,strong) UIView *separate;

@end

@implementation RDSearchResultBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.separate];
    }
    return self;
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
    _separate.frame = CGRectMake(15, self.height-MinPixel, self.width-15, MinPixel);
}

@end
