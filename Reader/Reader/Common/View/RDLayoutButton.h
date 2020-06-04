//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDButton.h"

typedef NS_ENUM (NSUInteger, WidButtonLayoutType)
{
    WidButtonLayoutHorizon,          // 水平布局，左边image，右边text
    WidButtonLayoutVertical,         // 垂直布局，上边image，下边text
    WidButtonLayoutReverseHorizon,   // 水平布局，左边text，右边image
    WidButtonLayoutReverseVertical,  // 垂直布局，上边text，下边image
};

@interface RDLayoutButton : RDButton
@property (nonatomic, assign) WidButtonLayoutType layoutType;
@property (nonatomic, assign) CGFloat imageAndTitleInset;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGSize titleSize;
@end
