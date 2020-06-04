//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@class UIFont;

@interface NSAttributedString (rd_wid)

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth;
- (CGSize)sizeWithMaxSize:(CGSize)maxSize;

@end

@interface NSMutableAttributedString (Wid)

+ (instancetype)strWithFont:(UIFont *)font
                  lineSpace:(CGFloat)lineSpace
                     string:(NSString *)string;

+ (instancetype)strWithFont:(UIFont *)font
                  lineSpace:(CGFloat)lineSpace
                     string:(NSString *)string
                   maxWidth:(CGFloat)maxWidth;

+ (instancetype)strWithFont:(UIFont *)font
                  lineSpace:(CGFloat)lineSpace
                     string:(NSString *)string
                    maxSize:(CGSize)maxSize;

// 根据情况设置行间距属性及字体属性，并计算最终大小
- (CGSize)sizewithFont:(UIFont *)font
             lineSpace:(CGFloat)lineSpace
              maxWidth:(CGFloat)maxWidth;

// 根据情况设置行间距属性及字体属性，并计算最终大小
- (CGSize)sizewithFont:(UIFont *)font
             lineSpace:(CGFloat)lineSpace
               maxSize:(CGSize)maxSize;

// 根据情况设置行间距属性及字体属性，并计算最终大小
// 若原来已设置了不同的font，则useFont= NO，maxFont只用于计算，不会覆盖设置
- (CGSize)sizeWithSpace:(CGFloat)lineSpace
                maxFont:(UIFont *)maxFont
                useFont:(BOOL)useFont
                maxSize:(CGSize)maxSize;

@end
