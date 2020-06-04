//
// Created by yuenov on 2019/10/23.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MinPixel    1/[UIScreen mainScreen].scale

@interface UIView (rd_dispalyInfo)

///判断是否为X,指带刘海屏的设备
+ (BOOL)isIphoneX;

+ (CGFloat)statusBar;

+ (CGFloat)navigationBar;

+ (CGFloat)tarBar;

+ (CGFloat)safeBottomBar;    //安全底部高度，针对iPhone X

+ (CGFloat)safeTopBar;  //安全顶部高度，针对iPhone X

+ (CGFloat)margins;  //边距

+ (CGFloat)mainMargins;  //首页边距，主页面的边距与其他页面不一样

+ (CGFloat)getAdMargin; //开屏广告距离底部的距离
@end
