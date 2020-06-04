//
//  UIImage+rd_wid.h
//  Reader
//
//  Created by yuenov on 2019/10/24.
//  Copyright © 2019 yuenov. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (rd_wid)
#pragma mark - stretchableImage

- (UIImage *)stretchableImage;

+ (UIImage *)stretchableImageNamed:(NSString *)name;

#pragma mark - captureView

// 把当前view保存成照片
+ (UIImage *)captureView:(UIView *)theView;

#pragma mark - fixOrientation

// 修正图片旋转方向，兼容非ios系统，避免上传的本地图片在服务端或其他客户端旋转方向错误
// ios照片，即使倒着拍照，显示的时候也是正的，但上传服务器后显示的是倒立的
- (UIImage *)fixOrientation;

#pragma mark - 翻转

// 垂直翻转
- (UIImage *)flipVertical;

// 水平翻转
- (UIImage *)flipHorizontal;

#pragma mark - 图片剪裁

// 截取部分图像
- (UIImage *)getCroppedImage:(CGRect)rect;

// 截取圆形图片
- (UIImage *)getCircleImage;

#pragma mark - 图片缩放 及 压缩大小

// 等比例缩放
- (UIImage *)scaleWithRate:(CGFloat)rate;

// 把整张图缩放到reSize大小，不一定等比例会变形
- (UIImage *)scaleToSize:(CGSize)reSize;

// 等比例缩小, 最大边长为limt
- (UIImage *)scaleWithMaxLen:(CGFloat)limit;

#pragma mark - 图片压缩大小

- (NSData *)compressImageDataWithMaxBytes:(NSUInteger)bytes;

#pragma mark - 根据颜色、文字等生成image

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)imageSize;

+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color;

+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color size:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)alignment;

#pragma mark - 在一个image上画上另一个image

- (UIImage *)drawImage:(UIImage *)image
               atPoint:(CGPoint)point
             onBgImage:(UIImage *)bgImage
                bgSize:(CGSize)bgSize;
@end

NS_ASSUME_NONNULL_END
