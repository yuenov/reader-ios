//
//  RDButton.m
//  Reader
//
//  Created by yuenov on 2020/3/23.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDButton.h"

@implementation RDButton

- (id)init
{
    self = [super init];
    if (self) {
        self.exclusiveTouch = YES;
    }

    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    bounds.origin.x -= _extendInsets.left;
    bounds.origin.y -= _extendInsets.top;
    bounds.size.width += _extendInsets.left + _extendInsets.right;
    bounds.size.height += _extendInsets.top + _extendInsets.bottom;

    return CGRectContainsPoint(bounds, point);
}

@end
