//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import "UIColor+rd_wid.h"


@implementation UIColor (rd_wid)
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha
{
    //去掉前后空格换行符
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    else if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];

    if ([cString length] != 6)
        return nil;

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:alpha];
}

+ (UIColor *)colorWithHexValue:(NSInteger)color alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float) ((color & 0xff0000) >> 16)) / 255.0
                           green:((float) ((color & 0x00ff00) >> 8)) / 255.0
                            blue:((float) (color & 0x0000ff)) / 255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHexValue:(NSInteger)color
{
    return [UIColor colorWithRed:((float) ((color & 0xff0000) >> 16)) / 255.0
                           green:((float) ((color & 0x00ff00) >> 8)) / 255.0
                            blue:((float) (color & 0x0000ff)) / 255.0
                           alpha:1.0];
}

+ (CGFloat)redColorFromHexRGBColor:(NSInteger)color
{
    return (((color & 0xff0000) >> 16) / 255.0);
}

+ (CGFloat)greenColorFromRGBColor:(NSInteger)color
{
    return (((color & 0x00ff00) >> 8) / 255.0);
}

+ (CGFloat)blueColorFromRGBColor:(NSInteger)color
{
    return ((color & 0x0000ff) / 255.0);
}

- (void)getColorComponentsWithRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha
{
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self getRed:red green:green blue:blue alpha:alpha];
    }
    else {
        const CGFloat *components = CGColorGetComponents(self.CGColor);
        *red = components[0];
        *green = components[1];
        *blue = components[2];
        *alpha = components[3];
    }
}

+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height
{
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();

    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();

    return [UIColor colorWithPatternImage:image];
}

@end
