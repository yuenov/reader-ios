//
//  RDTextField.m
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDTextField.h"

@implementation RDTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.textAlignment = NSTextAlignmentLeft;
        self.textColor = [UIColor colorWithWhite:31.0 / 255.0 alpha:1.0];
        self.font = [UIFont systemFontOfSize:15.0];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }

    return self;
}

#pragma mark - UITextField overrides method

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [self textContentRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self textContentRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textContentRectForBounds:bounds];
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, self.rightViewInsets);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return self.leftViewFrame;
}

- (CGRect)textContentRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, self.contentInsets);
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
