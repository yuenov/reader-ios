//
//  RDBaseViewController.h
//  Reader
//
//  Created by yuenov on 2019/10/23.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RDTopView.h"

typedef void (^CancelRequest)(void);

@interface RDBaseViewController : UIViewController
{
    RDTopView *_topView;
}
@property(nonatomic, strong) RDTopView *topView;


#pragma mark - action

- (void)showText:(NSString *)text;

-(void)showText:(NSString *)text dismiss:(void(^)(void))dismiss;

- (void)showLoading:(NSString *)text cancel:(void(^)(void))cancel;

- (void)hideLoading;

- (void)showLoadingGifWithCancel:(CancelRequest)canel;

- (void)hideLoadingGif;

- (void)pushToController:(UIViewController *)controller;

- (void)backAction;

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
