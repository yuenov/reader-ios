//
//  RDPageController.m
//  Reader
//
//  Created by yuenov on 2020/2/25.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDPageController.h"
#import "RDLoadIngView.h"
#import "RDNetErrorView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface RDPageController ()
@property (nonatomic,strong) RDLoadIngView *loadingView;
@property (nonatomic,strong) RDNetErrorView *errorView;
@property(nonatomic, copy) void(^cancelRequest)(void) ;
@end

@implementation RDPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setTintColor:RDGreenColor];
    self.fd_prefersNavigationBarHidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (_loadingView && _cancelRequest) {
        _cancelRequest();
    }

}
-(RDLoadIngView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[RDLoadIngView alloc] init];
        _loadingView.backgroundColor = RDBackgroudColor;
    }
    return _loadingView;
}
-(RDNetErrorView *)errorView
{
    if (!_errorView) {
        _errorView = [[RDNetErrorView alloc] init];
        [_errorView.reloadBtn addTarget:self action:@selector(reloadFetch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _errorView;
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (void)showLoadingGifWithCancel:(void(^)(void))cancel {
    _cancelRequest = cancel;
    self.loadingView.frame = self.view.bounds;
    [self.loadingView begin];
    [self.view addSubview:self.loadingView];
}
- (void)hideLoadingGif {
    [self.loadingView end];
    [self.loadingView removeFromSuperview];
    _loadingView = nil;
    _cancelRequest = nil;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (_loadingView.superview) {
        self.loadingView.frame = self.view.bounds;
    }
}

-(void)showErrorWithString:(NSString *)string
{
    [self showErrorWithString:string inView:self.view];
}

-(void)showErrorWithString:(NSString *)string inView:(UIView *)view
{
     [self showErrorWithString:string inView:view frame:CGRectMake(0, 0, view.width, view.height)];
}

-(void)showErrorWithString:(NSString *)string inView:(UIView *)view frame:(CGRect)frame
{
    self.errorView.errorString = string;
    self.errorView.frame = frame;
    [view addSubview:self.errorView];
}
-(void)hiddenError
{
    [self.errorView removeFromSuperview];
}

/// 点击重试，子类实现
-(void)reloadFetch
{
    
}
@end
