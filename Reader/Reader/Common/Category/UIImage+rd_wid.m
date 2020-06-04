//
//  UIImage+rd_wid.m
//  Reader
//
//  Created by yuenov on 2019/10/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "UIImage+rd_wid.h"


@implementation UIImage (rd_wid)
#pragma mark - stretchableImage

- (UIImage *)stretchableImage
{
    CGFloat left = floorf((self.size.width + 1) / 2) - 1;
    CGFloat top = floorf((self.size.height + 1) / 2) - 1;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, top, left)];
}

+ (UIImage *)stretchableImageNamed:(NSString *)name
{
    return [[UIImage imageNamed:name] stretchableImage];
}

#pragma mark - captureView

+ (UIImage *)captureView:(UIView *)theView
{
    CGRect rect = theView.frame;

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [theView.layer renderInContext:context];

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}

//+ (UIImage *)captureScreen
//{
//    CGImageRef screen = CGGetScreenImage();
//    UIImage* image = [UIImage imageWithCGImage:screen];
//    CGImageRelease(screen);
//
//    return image;
//}

#pragma mark - fixOrientation

- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }

    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
            CGImageGetBitsPerComponent(self.CGImage), 0,
            CGImageGetColorSpace(self.CGImage),
            CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)normalizedImage
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

#pragma mark - flip

- (UIImage *)flip:(BOOL)isHorizontal
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToRect(ctx, rect);
    if (isHorizontal) {
        CGContextRotateCTM(ctx, M_PI);
        CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height);
    }
    CGContextDrawImage(ctx, rect, self.CGImage);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 垂直翻转
- (UIImage *)flipVertical
{
    return [self flip:NO];
}

// 水平翻转
- (UIImage *)flipHorizontal
{
    return [self flip:YES];
}

- (UIImage *)transformWidth:(CGFloat)width height:(CGFloat)height rotate:(BOOL)rotate
{
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
    if (rotate) {
        if (self.imageOrientation == UIImageOrientationRight
                || self.imageOrientation == UIImageOrientationLeft) {
            sourceW = height;
            sourceH = width;
        }
    }

    CGImageRef imageRef = self.CGImage;
    int bytesPerRow = destW * (CGImageGetBitsPerPixel(imageRef) >> 3);
    CGContextRef bitmap = CGBitmapContextCreate(NULL, destW, destH,
            CGImageGetBitsPerComponent(imageRef), bytesPerRow, CGImageGetColorSpace(imageRef),
            CGImageGetBitmapInfo(imageRef));

    if (rotate) {
        if (self.imageOrientation == UIImageOrientationDown) {
            CGContextTranslateCTM(bitmap, sourceW, sourceH);
            CGContextRotateCTM(bitmap, 180 * (M_PI / 180));

        } else if (self.imageOrientation == UIImageOrientationLeft) {
            CGContextTranslateCTM(bitmap, sourceH, 0);
            CGContextRotateCTM(bitmap, 90 * (M_PI / 180));

        } else if (self.imageOrientation == UIImageOrientationRight) {
            CGContextTranslateCTM(bitmap, 0, sourceW);
            CGContextRotateCTM(bitmap, -90 * (M_PI / 180));
        }
    }

    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);

    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);

    return result;
}

#pragma mark - 图片剪裁

- (UIImage *)getCroppedImage:(CGRect)rect
{
    CGRect imageRect = CGRectMake(rect.origin.x * self.scale,
            rect.origin.y * self.scale,
            rect.size.width * self.scale,
            rect.size.height * self.scale);

    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, imageRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);

    return result;
}

void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;

    CGContextMoveToPoint(context, fw, fh / 2);
    CGContextAddArcToPoint(context, fw, fh, fw / 2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh / 2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw / 2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh / 2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *)getCircleImage
{
    CGFloat length = MIN(self.size.width, self.size.height);
    CGRect rect = CGRectMake((self.size.width - length) / 2, (self.size.height - length) / 2, length, length);

    UIImage *tmpImage = self;
    if (self.size.width != self.size.height) {
        tmpImage = [self getCroppedImage:rect];
    }

    return [tmpImage getCircleImageInRect:CGRectMake(0, 0, length, length)];
}

- (UIImage *)getCircleImageInRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);

    [self drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);

    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newimg;
}

#pragma mark - 图片缩放

- (UIImage *)scaleToSize:(CGSize)reSize
{
    UIGraphicsBeginImageContextWithOptions(reSize, NO, 0);

    [self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];

    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return reSizeImage;
}

- (UIImage *)scaleWithRate:(CGFloat)rate
{
    CGSize reSize = CGSizeMake(self.size.width * rate, self.size.height * rate);
    return [self scaleToSize:reSize];
}

- (UIImage *)scaleWithMaxLen:(CGFloat)limit
{
    CGFloat maxLen = MAX(self.size.width, self.size.height);
    if (maxLen <= limit) {
        return self;
    }

    CGSize size;
    if (self.size.width > self.size.height) {
        size = CGSizeMake(ceilf(limit), ceilf(limit * self.size.height / self.size.width));
    }
    else {
        size = CGSizeMake(ceilf(limit * self.size.width / self.size.height), limit);
    }

    return [self scaleToSize:size];
}

#pragma mark - 图片压缩大小

- (NSData *)compressImageDataWithMaxBytes:(NSUInteger)bytes
{
    CGFloat curRatio = 1.0;
    NSData *compressImageData = UIImageJPEGRepresentation(self, curRatio);
    NSUInteger curBytes = [compressImageData length];

    curRatio = (CGFloat) bytes / curBytes;

    while (true) {
        if (curBytes <= bytes) {
            return compressImageData;
        }
        if (curRatio <= 0) {
            compressImageData = UIImageJPEGRepresentation(self, 0.0);
            curBytes = [compressImageData length];
            if (curBytes <= bytes) {
                return compressImageData;
            }
            else {
                return nil;
            }
        }
        else {
            compressImageData = UIImageJPEGRepresentation(self, curRatio);
            curBytes = [compressImageData length];

            curRatio -= 0.05;
        }
    }

    return nil;
}

#pragma mark - 根据颜色、文字等生成image

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)imageSize
{
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect rect = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color
{
    return [self imageWithText:text font:font textColor:color size:[UIImage sizeWithText:text Font:font size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)]];
}

+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color size:(CGSize)size
{
    return [UIImage imageWithText:text font:font textColor:color size:size lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter];
}

+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)alignment
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(ctx, color.CGColor);
    NSDictionary *attributes = @{NSFontAttributeName : font};
    [text drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - 在一个image上画上另一个image

- (UIImage *)drawImage:(UIImage *)image
               atPoint:(CGPoint)point
             onBgImage:(UIImage *)bgImage
                bgSize:(CGSize)bgSize
{
    if (!image || !bgImage) {
        return nil;
    }

    UIGraphicsBeginImageContextWithOptions(bgSize, NO, 0);

    [bgImage drawAtPoint:CGPointMake((bgSize.width - bgImage.size.width) / 2,
            (bgSize.height - bgImage.size.height) / 2)];
    [image drawAtPoint:point];

    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resultImage;
}

#pragma mark - GaussianBlur

- (UIImage *)imageWith3x3GaussianBlur
{
    const CGFloat filter[3][3] = {
            {1.0f / 16.0f, 2.0f / 16.0f, 1.0f / 16.0f},
            {2.0f / 16.0f, 4.0f / 16.0f, 2.0f / 16.0f},
            {1.0f / 16.0f, 2.0f / 16.0f, 1.0f / 16.0f}
    };

    CGImageRef imgRef = [self CGImage];

    size_t width = CGImageGetWidth(imgRef);
    size_t height = CGImageGetHeight(imgRef);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = bytesPerPixel * width;
    size_t totalBytes = bytesPerRow * height;

    //Allocate Image space
    uint8_t *rawData = malloc(totalBytes);

    //Create Bitmap of same size
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    //Draw our image to the context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);

    for (int y = 0; y < height; y++) {

        for (int x = 0; x < width; x++) {

            uint8_t *pixel = rawData + (bytesPerRow * y) + (x * bytesPerPixel);

            CGFloat sumRed = 0;
            CGFloat sumGreen = 0;
            CGFloat sumBlue = 0;

            for (int j = 0; j < 3; j++) {

                for (int i = 0; i < 3; i++) {

                    if ((y + j - 1) >= height || (y + j - 1) < 0) {
                        //Use zero values at edge of image
                        continue;
                    }

                    if ((x + i - 1) >= width || (x + i - 1) < 0) {
                        //Use Zero values at edge of image
                        continue;
                    }

                    uint8_t *kernelPixel = rawData + (bytesPerRow * (y + j - 1)) + ((x + i - 1) * bytesPerPixel);

                    sumRed += kernelPixel[0] * filter[j][i];
                    sumGreen += kernelPixel[1] * filter[j][i];
                    sumBlue += kernelPixel[2] * filter[j][i];

                }

            }

            pixel[0] = roundf(sumRed);
            pixel[1] = roundf(sumGreen);
            pixel[2] = roundf(sumBlue);

        }

    }


    //Create Image
    CGImageRef newImg = CGBitmapContextCreateImage(context);

    //Release Created Data Structs
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(rawData);

    //Create UIImage struct around image
    UIImage *image = [UIImage imageWithCGImage:newImg];

    //Release our hold on the image
    CGImageRelease(newImg);

    //return new image!
    return image;

}

- (UIImage *)imageWith5x5GaussianBlur
{
    const CGFloat filter[5][5] = {
            {1.0f / 256.0f, 4.0f / 256.0f, 6.0f / 256.0f, 4.0f / 256.0f, 1.0f / 256.f},
            {4.0f / 256.0f, 16.0f / 256.0f, 24.0f / 256.0f, 16.0f / 256.0f, 4.0f / 256.f},
            {6.0f / 256.0f, 24.0f / 256.0f, 36.0f / 256.0f, 24.0f / 256.0f, 6.0f / 256.f},
            {4.0f / 256.0f, 16.0f / 256.0f, 24.0f / 256.0f, 16.0f / 256.0f, 4.0f / 256.f},
            {1.0f / 256.0f, 4.0f / 256.0f, 6.0f / 256.0f, 4.0f / 256.0f, 1.0f / 256.f}
    };

    CGImageRef imgRef = [self CGImage];

    size_t width = CGImageGetWidth(imgRef);
    size_t height = CGImageGetHeight(imgRef);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = bytesPerPixel * width;
    size_t totalBytes = bytesPerRow * height;

    //Allocate Image space
    uint8_t *rawData = malloc(totalBytes);

    //Create Bitmap of same size
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    //Draw our image to the context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);

    for (int y = 0; y < height; y++) {

        for (int x = 0; x < width; x++) {

            uint8_t *pixel = rawData + (bytesPerRow * y) + (x * bytesPerPixel);

            CGFloat sumRed = 0;
            CGFloat sumGreen = 0;
            CGFloat sumBlue = 0;

            for (int j = 0; j < 5; j++) {

                for (int i = 0; i < 5; i++) {

                    if ((y + j - 2) >= height || (y + j - 2) < 0) {
                        //Use zero values at edge of image
                        continue;
                    }

                    if ((x + i - 2) >= width || (x + i - 2) < 0) {
                        //Use Zero values at edge of image
                        continue;
                    }

                    uint8_t *kernelPixel = rawData + (bytesPerRow * (y + j - 2)) + ((x + i - 2) * bytesPerPixel);

                    sumRed += kernelPixel[0] * filter[j][i];
                    sumGreen += kernelPixel[1] * filter[j][i];
                    sumBlue += kernelPixel[2] * filter[j][i];

                }

            }

            pixel[0] = roundf(sumRed);
            pixel[1] = roundf(sumGreen);
            pixel[2] = roundf(sumBlue);

        }

    }


    //Create Image
    CGImageRef newImg = CGBitmapContextCreateImage(context);

    //Release Created Data Structs
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(rawData);

    //Create UIImage struct around image
    UIImage *image = [UIImage imageWithCGImage:newImg];

    //Release our hold on the image
    CGImageRelease(newImg);

    //return new image!
    return image;
}

#pragma mark - helper

+ (CGSize)sizeWithText:(NSString *)text Font:(UIFont *)font size:(CGSize)size
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
