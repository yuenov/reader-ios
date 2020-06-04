//
//  RDPageController.h
//  Reader
//
//  Created by yuenov on 2020/2/25.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDPageController : WMPageController

- (void)showLoadingGifWithCancel:(void(^)(void))cancel;


- (void)hideLoadingGif;

-(void)showErrorWithString:(NSString *)string;

-(void)showErrorWithString:(NSString *)string inView:(UIView *)view;

/// 显示加载错误页面
/// @param view 在哪个视图上展示
/// @param frame 错误视图的尺寸
-(void)showErrorWithString:(NSString *)string inView:(UIView *)view frame:(CGRect)frame;
//隐藏错误页面
-(void)hiddenError;

/// 点击重试，子类实现
-(void)reloadFetch;
@end

NS_ASSUME_NONNULL_END
