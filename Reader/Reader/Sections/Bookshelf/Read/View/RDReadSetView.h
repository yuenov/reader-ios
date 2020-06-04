//
//  RDReadSetView.h
//  Reader
//
//  Created by yuenov on 2019/11/14.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RDReadSetViewDelegate <NSObject>
-(void)didChangePageType;
@end
@interface RDReadSetView : UIView
@property (nonatomic,weak) id<RDReadSetViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
