//
//  RDLimitInput.h
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kLimitInputKey @"limit"

#define DECLARE_PROPERTY(className) \
@interface className (Limit) @end

DECLARE_PROPERTY(UITextField)
DECLARE_PROPERTY(UITextView)

@interface RDLimitInput : NSObject

@property(nonatomic, assign) BOOL enableLimitCount;

+(RDLimitInput *)sharedInstance;

@end
