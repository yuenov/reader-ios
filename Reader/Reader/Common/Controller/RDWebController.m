//
//  RDWebController.m
//  Reader
//
//  Created by yuenov on 2020/3/23.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDWebController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "RDWebView.h"
#import "RDWebTopView.h"
#import "NSObject+FBKVOController.h"
@interface RDWebController () <WKNavigationDelegate>
@property(nonatomic, strong) NJKWebViewProgressView *progressView;
@property(nonatomic, strong) RDWebView *webView;
@property(nonatomic, strong) RDWebTopView *headView;
@property(nonatomic, strong) NSURLRequest *request;
@end

@implementation RDWebController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.view addSubview:self.headView];
    
}

- (RDWebTopView *)headView {
    if (!_headView) {
        _headView = [[RDWebTopView alloc] init];
        [_headView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_headView.reloadBtn addTarget:self action:@selector(onClickReloadBtn) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:self.progressView];
    }

    return _headView;
}

- (void)setRequestStr:(NSString *)requestStr {
    _requestStr = requestStr;
    if (requestStr.length == 0) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:requestStr];
    if (url == nil) {
        requestStr = [requestStr trimmingWhitespace];
        NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *encodeUrl = [requestStr stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
        url = [NSURL URLWithString:encodeUrl];
    }
    

    _request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];

    if (!_webView.superview) {
        [self.view addSubview:self.webView];
    }
    [self.webView loadReq:_request];
}

-(RDWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[RDWebView alloc] initWithFrame:CGRectMake(0, self.headView.bottom, ScreenWidth, ScreenHeight - self.headView.height) configuration:configuration];
        
        _webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.multipleTouchEnabled = NO;
        _webView.autoresizesSubviews = YES;
        _webView.opaque = NO;
        [_webView setNavigationDelegate:self];
        [self.progressView setProgress:0 animated:YES];
        
        [self.KVOController observe:self.webView keyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew block:^(RDWebController *  _Nullable observer, RDWebView*  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
            [observer.progressView setProgress:object.estimatedProgress];
        }];
    }
    return _webView;
}

- (NJKWebViewProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, _headView.height - 2, _headView.width, 2)];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.progressBarView.backgroundColor = RDGreenColor;
    }

    return _progressView;
}

- (void)backAction {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [super backAction];
    }
}
- (void)onClickReloadBtn {
    [self.webView reload];
}

- (void)onClickCloseBtn {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [super backAction];
    }
}



- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigatio
{
    self.headView.titleLabel.text = webView.title;
    if ([self.webView canGoBack]) {
        [self.headView.closeBtn addTarget:self action:@selector(onClickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.headView addSubview:self.headView.closeBtn];
        [self.headView closeBtnSizeToFit];
    }
}


@end
