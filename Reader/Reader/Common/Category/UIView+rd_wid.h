//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (rd_wid)
/**
* Shortcut for frame.origin.x.
*
* Sets frame.origin.x = left
*/
@property (nonatomic) CGFloat left;

/**
* Shortcut for frame.origin.y
*
* Sets frame.origin.y = top
*/
@property (nonatomic) CGFloat top;

/**
* Shortcut for frame.origin.x + frame.size.width
*
* Sets frame.origin.x = right - frame.size.width
*/
@property (nonatomic) CGFloat right;

/**
* Shortcut for frame.origin.y + frame.size.height
*
* Sets frame.origin.y = bottom - frame.size.height
*/
@property (nonatomic) CGFloat bottom;

/**
* Shortcut for frame.size.width
*
* Sets frame.size.width = width
*/
@property (nonatomic) CGFloat width;

/**
* Shortcut for frame.size.height
*
* Sets frame.size.height = height
*/
@property (nonatomic) CGFloat height;

/**
* Shortcut for center.x
*
* Sets center.x = centerX
*/
@property (nonatomic) CGFloat centerX;

/**
* Shortcut for center.y
*
* Sets center.y = centerY
*/
@property (nonatomic) CGFloat centerY;

/**
* Shortcut for frame.origin
*/
@property (nonatomic) CGPoint origin;

/**
* Shortcut for frame.size
*/
@property (nonatomic) CGSize size;

/**
* Return the x coordinate on the screen.
*/
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
* Return the y coordinate on the screen.
*/
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
* Return the x coordinate on the screen, taking into account scroll views.
*/
@property (nonatomic, readonly) CGFloat screenViewX;

/**
* Return the y coordinate on the screen, taking into account scroll views.
*/
@property (nonatomic, readonly) CGFloat screenViewY;

/**
* Return the view frame on the screen, taking into account scroll views.
*/
@property (nonatomic, readonly) CGRect screenFrame;

/**
* Return the width in portrait or the height in landscape.
*/
//@property (nonatomic, readonly) CGFloat orientationWidth;

/**
* Return the height in portrait or the width in landscape.
*/
//@property (nonatomic, readonly) CGFloat orientationHeight;

/**
* Finds the first descendant view (including this view) that is a member of a particular class.
*/
- (UIView *)descendantOrSelfWithClass:(Class)cls;

/**
* Finds the first ancestor view (including this view) that is a member of a particular class.
*/
- (UIView *)ancestorOrSelfWithClass:(Class)cls;

/**
* Removes all subviews.
*/
- (void)removeAllSubviews;

/**
* Calculates the offset of this view from another view in screen coordinates.
*
* otherView should be a parent view of this view.
*/
- (CGPoint)offsetFromView:(UIView *)otherView;
@end

@interface CALayer (KafkaLayout)

@property (nonatomic) CGFloat kr_left;
@property (nonatomic) CGFloat kr_top;
@property (nonatomic) CGFloat kr_right;
@property (nonatomic) CGFloat kr_bottom;
@property (nonatomic) CGFloat kr_width;
@property (nonatomic) CGFloat kr_height;
@property (nonatomic) CGPoint kr_origin;
@property (nonatomic) CGSize  kr_size;
@property (nonatomic) CGFloat kr_positionX;
@property (nonatomic) CGFloat kr_positionY;

@end
