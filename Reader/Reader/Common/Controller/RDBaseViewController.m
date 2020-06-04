//
//  RDBaseViewController.m
//  Reader
//
//  Created by yuenov on 2019/10/23.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBaseViewController.h"

#import "RDLayoutButton.h"
#import "RDLoadIngView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "RDNetErrorView.h"

@interface RDBaseViewController () <MBProgressHUDDelegate>
@property (nonatomic,strong) RDLoadIngView *loadingView;
@property(nonatomic, copy) CancelRequest cancelRequest;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) RDNetErrorView *errorView;
@property (nonatomic,copy) void(^dismiss)(void);
@property (nonatomic,copy) void(^cancel)(void);
@end

@implementation RDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = RDBackgroudColor;
    self.fd_prefersNavigationBarHidden = YES;
    [self.view setTintColor:RDGreenColor];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}
- (void)viewDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (_loadingView && _cancelRequest) {
        _cancelRequest();
        _cancelRequest = nil;
    }
    if (self.cancel) {
        self.cancel();
        self.cancel = nil;
    }
}

- (RDTopView *)topView {
    if (!_topView) {
        _topView = [[RDTopView alloc] initWithBackStyle];
        [_topView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }

    return _topView;
}

-(RDLoadIngView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[RDLoadIngView alloc] init];
        _loadingView.backgroundColor = RDBackgroudColor;
    }
    return _loadingView;
}

-(MBProgressHUD *)hud
{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.delegate = self;
        [self.view addSubview:_hud];
    }
    return _hud;
}

-(RDNetErrorView *)errorView
{
    if (!_errorView) {
        _errorView = [[RDNetErrorView alloc] init];
        [_errorView.reloadBtn addTarget:self action:@selector(reloadFetch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _errorView;
}



- (void)showText:(NSString *)text
{
    [self showText:text dismiss:nil];
}

-(void)showText:(NSString *)text dismiss:(void(^)(void))dismiss
{
    self.dismiss = dismiss;
    [self.hud showAnimated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = text;
    self.hud.label.numberOfLines = 0;
    [self.hud hideAnimated:NO afterDelay:kAnimateDelay];
}

- (void)showLoading:(NSString *)text cancel:(void(^)(void))cancel
{
    self.cancel = cancel;
    [self.hud showAnimated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.label.text = text;
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (hud.mode == MBProgressHUDModeText) {
        if (self.dismiss) {
            self.dismiss();
        }
        self.dismiss = nil;
    }
    else if (hud.mode == MBProgressHUDModeIndeterminate)
    {
        self.cancel = nil;
    }
}

- (void)hideLoading
{
    [self.hud hideAnimated:NO];
}

- (void)pushToController:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)showLoadingGifWithCancel:(CancelRequest)canel {
    _cancelRequest = canel;
    if (_topView) {
        self.loadingView.frame = CGRectMake(0, _topView.bottom, self.view.width, self.view.height - _topView.bottom);
    } else {
        self.loadingView.frame = self.view.bounds;
    }
    [self.loadingView begin];
    [self.view addSubview:self.loadingView];
}
- (void)hideLoadingGif {
    [self.loadingView end];
    [self.loadingView removeFromSuperview];
    _loadingView = nil;
    _cancelRequest = nil;
}

-(void)showErrorWithString:(NSString *)string
{
    [self showErrorWithString:string inView:self.view];
}

-(void)showErrorWithString:(NSString *)string inView:(UIView *)view
{
    if (self.topView.superview && self.topView.hidden == NO)
    {
        [self showErrorWithString:string inView:view frame:CGRectMake(0, self.topView.bottom, view.width, view.height-self.topView.height)];
    }
    else{
        [self showErrorWithString:string inView:view frame:CGRectMake(0, 0, view.width, view.height)];
    }
}

-(void)showErrorWithString:(NSString *)string inView:(UIView *)view frame:(CGRect)frame
{
    self.errorView.errorString = string;
    self.errorView.frame = frame;
    [view addSubview:self.errorView];
}
-(void)hiddenError
{
    if (_errorView.superview) {
        [self.errorView removeFromSuperview];
    }
    
}

/// 点击重试，子类实现
-(void)reloadFetch
{
    
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (_loadingView.superview) {
        if (_topView) {
            self.loadingView.frame = CGRectMake(0, _topView.bottom, self.view.width, self.view.height - _topView.bottom);
        } else {
            self.loadingView.frame = self.view.bounds;
        }
    }
}

@end
