//
//  RDReadToolPageView.h
//  Reader
//
//  Created by yuenov on 2019/11/19.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RDReadToolPageView : UIView
@property (nonatomic,assign) RDPageType defaultType;
@property (nonatomic,copy) void(^pageType)(RDPageType type);
@end

NS_ASSUME_NONNULL_END
