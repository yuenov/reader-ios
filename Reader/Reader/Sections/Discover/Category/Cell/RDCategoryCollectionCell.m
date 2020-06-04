//
//  RDCategoryCollectionCell.m
//  Reader
//
//  Created by yuenov on 2020/2/26.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDCategoryCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface RDCategoryCollectionCell ()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) NSArray <UIImageView *>*images;
@end

@implementation RDCategoryCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setItem:(RDChannelItem *)item
{
    _item = item;
    for (int i = 0; i<self.images.count; i++) {
        
        [self.images[i] sd_setImageWithURL:[NSURL URLWithString:[RDUtilities buildPicUrlWithPath:[item.coverImgs objectAtIndexSafely:i]]] placeholderImage:[UIImage imageNamed:@"app_placeholder"]];
    }
    self.nameLabel.text = item.category;
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

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(3, 3, self.width-6, self.height-6);
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.shadowColor = RDLightGrayColor.CGColor;
    self.contentView.layer.shadowOpacity = 0.1;
    self.contentView.layer.shadowOffset = CGSizeMake(0,0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(-3, -3, self.contentView.width + 6, self.contentView.height + 6)];
    self.contentView.layer.shadowPath = path.CGPath;
    self.nameLabel.frame = CGRectMake(15, 0, [self.nameLabel.text sizeWithFont:RDFont17 maxWidth:CGFLOAT_MAX].width ,RDFont18.lineHeight);
    self.nameLabel.centerY = self.height/2;
    for (int i=0; i<self.images.count; i++) {
        UIImageView *imageView = self.images[i];
        switch (i) {
            case 0:
            {
                imageView.frame = CGRectMake(self.width-60, 0, 30, 41);
                if ([RDUtilities iPad]) {
                    imageView.frame = CGRectMake(self.width-120, 0, 60, 82);
                }
                imageView.centerY = self.height/2;
            }
                break;
            case 1:
            {
                imageView.frame = CGRectMake(self.width-60-15, 0, 30, 33);
                
                imageView.centerY = self.height/2+4;
                
                if ([RDUtilities iPad]) {
                    imageView.frame = CGRectMake(self.width-120-60, 0, 60, 66);
                    imageView.centerY = self.height/2+8;
                }
            }
                break;
            case 2:
            {
                imageView.frame = CGRectMake(self.width-30-15, 0, 30, 33);
                
                imageView.centerY = self.height/2+4;
                if ([RDUtilities iPad]) {
                    imageView.frame = CGRectMake(self.width-60-30, 0, 60, 66);
                    imageView.centerY = self.height/2+8;
                }
            }
                break;
            default:
                break;
        }
    }
}

@end
