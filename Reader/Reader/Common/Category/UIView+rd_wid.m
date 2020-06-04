//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import "UIView+rd_wid.h"


@implementation UIView (rd_wid)
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left
{
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top
{
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX
{
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY
{
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width
{
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height
{
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX
{
    CGFloat x = 0.0f;
    for (UIView *view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY
{
    CGFloat y = 0.0f;
    for (UIView *view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX
{
    CGFloat x = 0.0f;
    for (UIView *view = self; view; view = view.superview) {
        x += view.left;

        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *) view;
            x -= scrollView.contentOffset.x;
        }
    }

    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY
{
    CGFloat y = 0;
    for (UIView *view = self; view; view = view.superview) {
        y += view.top;

        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *) view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame
{
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin
{
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size
{
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (CGFloat)orientationWidth {
//  return UIInterfaceOrientationIsLandscape(TTInterfaceOrientation())
//    ? self.height : self.width;
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (CGFloat)orientationHeight {
//  return UIInterfaceOrientationIsLandscape(TTInterfaceOrientation())
//    ? self.width : self.height;
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)descendantOrSelfWithClass:(Class)cls
{
    if ([self isKindOfClass:cls])
        return self;

    for (UIView *child in self.subviews) {
        UIView *it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }

    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)ancestorOrSelfWithClass:(Class)cls
{
    if ([self isKindOfClass:cls]) {
        return self;

    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];

    } else {
        return nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews
{
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView *)otherView
{
    CGFloat x = 0.0f, y = 0.0f;
    for (UIView *view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}

@end

@implementation CALayer (KafkaLayout)

- (CGFloat)kr_left{
    return self.frame.origin.x;
}

- (void)setKr_left:(CGFloat)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)kr_top {
    return self.frame.origin.y;
}

- (void)setKr_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)kr_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setKr_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)kr_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setKr_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)kr_width {
    return self.frame.size.width;
}

- (void)setKr_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)kr_height {
    return self.frame.size.height;
}

- (void)setKr_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)kr_positionX {
    return self.position.x;
}

- (void)setKr_positionX:(CGFloat)positionX {
    self.position = CGPointMake(positionX, self.position.y);
}

- (CGFloat)kr_positionY {
    return self.position.y;
}

- (void)setKr_positionY:(CGFloat)positionY {
    self.position = CGPointMake(self.position.x, positionY);
}

- (CGPoint)kr_origin {
    return self.frame.origin;
}

- (void)setKr_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)kr_size {
    return self.frame.size;
}

- (void)setKr_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
