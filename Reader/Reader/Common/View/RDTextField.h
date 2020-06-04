//
//  RDTextField.h
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RDTextField : UITextField
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) CGRect leftViewFrame;
@property (nonatomic, assign) UIEdgeInsets rightViewInsets;
@end

NS_ASSUME_NONNULL_END
