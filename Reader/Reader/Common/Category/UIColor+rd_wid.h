//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (rd_wid)
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexValue:(NSInteger)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexValue:(NSInteger)color;

+ (CGFloat)redColorFromHexRGBColor:(NSInteger)hex;

+ (CGFloat)greenColorFromRGBColor:(NSInteger)hex;

+ (CGFloat)blueColorFromRGBColor:(NSInteger)hex;

- (void)getColorComponentsWithRed:(CGFloat *)red
                            green:(CGFloat *)green
                             blue:(CGFloat *)blue
                            alpha:(CGFloat *)alpha;

+ (UIColor*)gradientFromColor:(UIColor*)c1
                      toColor:(UIColor*)c2
                   withHeight:(int)height;


#define RDBackgroudColor    [UIColor colorWithHexValue:0xffffff]
#define RDSeparatorColor    [UIColor colorWithHexValue:0xc6cacc]
#define RDLightSeparatorColor [UIColor colorWithHexValue:0xebebeb]
#define RDGreenColor        [UIColor colorWithHexValue:0x23b383]
#define RDBlackColor        [UIColor colorWithHexValue:0x333333]
#define RDGrayColor         [UIColor colorWithHexValue:0x666666]
#define RDLightGrayColor    [UIColor colorWithHexValue:0x999999]
#define RDPlaceholderColor  [UIColor colorWithHexValue:0xc5c5c7]
#define RDReadBg       [UIColor colorWithHexValue:0xf0f0f0]

@end
