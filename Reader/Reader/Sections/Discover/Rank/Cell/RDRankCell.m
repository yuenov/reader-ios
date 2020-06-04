//
//  RDRankCell.m
//  Reader
//
//  Created by yuenov on 2020/2/26.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDRankCell.h"
@interface RDRankCell ()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) NSArray <UIImageView *>*images;
@property (nonatomic,strong) UIImageView *arrow;
@property (nonatomic,strong) UIView *separate;
@end

@implementation RDRankCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.arrow];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.separate];
    }
    return self;
}
-(void)setItem:(RDChannelItem *)item
{
    _item = item;
    for (int i = 0; i<self.images.count; i++) {
        
        [self.images[i] sd_setImageWithURL:[NSURL URLWithString:[RDUtilities buildPicUrlWithPath:[item.coverImgs objectAtIndexSafely:i]]] placeholderImage:[UIImage imageNamed:@"app_placeholder"]];
    }
    self.nameLabel.text = item.rank;
}

-(NSArray <UIImageView *>*)images
{
    if (!_images) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<3; i++) {
            UIImageView *imageView = [self createImage];
            [array addObject:imageView];
            [self.contentView insertSubview:imageView atIndex:0];
        }
        _images = array.copy;
    }
    return _images;
}

-(UIImageView *)createImage
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = RDGrayColor;
        _nameLabel.font = RDFont17;
    }
    return _nameLabel;
}
-(UIImageView *)arrow
{
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        _arrow.image = [UIImage imageNamed:@"me_arrow"];
    }
    return _arrow;
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
    self.arrow.frame = CGRectMake(self.width-20-13, 0, 13, 15);
    self.arrow.centerY = self.height/2;
    for (int i=0; i<self.images.count; i++) {
        switch (i) {
            case 0:
                self.images[i].frame = CGRectMake(15, 0, 50, 65);
                self.images[i].centerY = self.height/2;
                break;
            case 1:
                self.images[i].frame = CGRectMake(45, 0, 35, 53);
                self.images[i].centerY = self.height/2+6;
                break;
            case 2:
                self.images[i].frame = CGRectMake(65, 0, 30, 43);
                self.images[i].centerY = self.height/2+11;
                break;
            default:
                break;
        }
    }
    self.nameLabel.frame = CGRectMake(self.images.lastObject.right+16, 0, [self.nameLabel.text sizeWithFont:RDFont17 maxWidth:CGFLOAT_MAX].width, RDFont17.lineHeight);
    self.nameLabel.centerY = self.height/2;
    self.separate.frame = CGRectMake(15, 0, self.width-15, MinPixel);
    self.separate.bottom = self.height;
    
    
}
@end
