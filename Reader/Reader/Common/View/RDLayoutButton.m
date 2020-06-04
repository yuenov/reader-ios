//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import "RDLayoutButton.h"


@implementation RDLayoutButton
- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize btnSize = self.bounds.size;
    CGSize imageViewSize = self.imageSize.width > 0 && self.imageSize.height > 0 ? self.imageSize : self.imageView.image.size;
    CGSize titleLabelSize = self.titleSize.width > 0 && self.titleSize.height > 0 ? self.titleSize : [self sizeWithText:self.titleLabel.text Font:self.titleLabel.font size:btnSize];

    if (_layoutType == WidButtonLayoutHorizon) {
        CGFloat totalWidth = imageViewSize.width + titleLabelSize.width + self.imageAndTitleInset;

        self.imageView.frame = CGRectMake((btnSize.width - totalWidth) / 2, (btnSize.height - imageViewSize.height) / 2, imageViewSize.width, imageViewSize.height);
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + self.imageAndTitleInset, (btnSize.height - titleLabelSize.height) / 2, titleLabelSize.width, titleLabelSize.height);
    }
    else if (_layoutType == WidButtonLayoutVertical) {
        CGFloat totalHeight = imageViewSize.height + titleLabelSize.height + self.imageAndTitleInset;

        self.imageView.frame = CGRectMake((btnSize.width - imageViewSize.width) / 2, (btnSize.height - totalHeight) / 2, imageViewSize.width, imageViewSize.height);
        self.titleLabel.frame = CGRectMake((btnSize.width - titleLabelSize.width) / 2, CGRectGetMaxY(self.imageView.frame) + self.imageAndTitleInset, titleLabelSize.width, titleLabelSize.height);
    }
    else if (_layoutType == WidButtonLayoutReverseHorizon) {
        CGFloat totalWidth = imageViewSize.width + titleLabelSize.width + self.imageAndTitleInset;

        self.titleLabel.frame = CGRectMake((btnSize.width - totalWidth) / 2, (btnSize.height - titleLabelSize.height) / 2, titleLabelSize.width, titleLabelSize.height);
        self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + self.imageAndTitleInset, (btnSize.height - imageViewSize.height) / 2, imageViewSize.width, imageViewSize.height);
    }
    else {
        CGFloat totalHeight = imageViewSize.height + titleLabelSize.height + self.imageAndTitleInset;

        self.titleLabel.frame = CGRectMake((btnSize.width - titleLabelSize.width) / 2, (btnSize.height - totalHeight) / 2, titleLabelSize.width, titleLabelSize.height);
        self.imageView.frame = CGRectMake((btnSize.width - imageViewSize.width) / 2, CGRectGetMaxY(self.titleLabel.frame) + self.imageAndTitleInset, imageViewSize.width, imageViewSize.height);
    }
}

#pragma mark - helper

- (CGSize)sizeWithText:(NSString *)text Font:(UIFont *)font size:(CGSize)size
{
    if (text.length == 0 || !font) {
        return CGSizeZero;
    }

    NSDictionary *attributes = @{NSFontAttributeName : font};
    CGSize boundingBox = [text boundingRectWithSize:size
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes context:nil].size;
    return CGSizeMake(ceilf(boundingBox.width), ceilf(boundingBox.height));
}

@end
