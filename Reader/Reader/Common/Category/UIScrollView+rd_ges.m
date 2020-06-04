//
//  UIScrollView+rd_ges.m
//  Reader
//
//  Created by yuenov on 2020/4/7.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "UIScrollView+rd_ges.h"
#import <objc/runtime.h>



@implementation UIScrollView (rd_ges)


#pragma mark - 解决全屏滑动
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    if (self.contentSize.width>ScreenWidth) {
        if ([self panBack:gestureRecognizer]) {
            return NO;
        }
    }
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.contentSize.width>ScreenWidth) {
        if (self.contentOffset.x <= 0) {
            if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        CGPoint point = [self.panGestureRecognizer translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        NSLog(@"----%@",NSStringFromCGPoint(point));
        // 设置手势滑动的位置距屏幕左边的区域
        CGFloat locationDistance = [UIScreen mainScreen].bounds.size.width;
        
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStatePossible) {
            CGPoint location = [gestureRecognizer locationInView:self];
            if (point.x > 0 && location.x < locationDistance && self.contentOffset.x <= 0) {
                return YES;
            }
        }
    }
    return NO;
}
@end
