//
//  RDSearchView.h
//  Reader
//
//  Created by yuenov on 2019/10/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RDSearchViewDelegate <NSObject>

-(void)searchViewDidSelect;

@end

@interface RDSearchView : UIView
@property (nonatomic,weak) id<RDSearchViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
