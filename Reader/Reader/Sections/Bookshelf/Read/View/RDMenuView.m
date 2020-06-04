//
//  RDMenuView.m
//  Reader
//
//  Created by yuenov on 2019/11/13.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDMenuView.h"
#import "RDReadSetView.h"
#import "RDReadLightView.h"
#import "RDReadProgressView.h"
#import "RDReadCatalogView.h"
#import "RDReadCatalogCell.h"

#define kToolBarHeight (50+[UIView safeBottomBar])

@interface RDMenuView () <RDReadToolBarDelegate,RDReadCatalogViewDelegate,RDReadProgressViewDelegate,RDReadTopBarDelegate,RDReadSetViewDelegate>
@property (nonatomic,strong) RDReadSetView *setView;
@property (nonatomic,strong) RDReadLightView *lightView;
@property (nonatomic,strong) RDReadProgressView *progressView;
@property (nonatomic,strong) RDReadCatalogView *catalogView;
@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong) UIView *gesView;
@end
@implementation RDMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.gesView];
        [self addSubview:self.setView];
        [self addSubview:self.lightView];
        [self addSubview:self.progressView];
        [self addSubview:self.topBar];
        [self addSubview:self.catalogView];
        [self addSubview:self.toolBar];
        
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)setCharpters:(NSArray<RDCharpterModel *> *)charpters
{
    _charpters = charpters;
    self.catalogView.charpters = charpters;
    self.progressView.charpters = charpters;
}
-(void)setBook:(RDBookDetailModel *)book
{
    _book = book;
    self.catalogView.book = book;
    self.progressView.book = book;
    self.topBar.record = book;
    
}
-(RDReadToolBar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[RDReadToolBar alloc] initWithFrame:CGRectMake(0, ScreenSize.height, ScreenSize.width, kToolBarHeight)];
        _toolBar.delegate = self;
    }
    return _toolBar;
}
-(RDReadTopBar *)topBar
{
    if (!_topBar) {
        CGFloat height = [UIView navigationBar]+[UIView statusBar];
        _topBar = [[RDReadTopBar alloc] initWithFrame:CGRectMake(0, -height, ScreenSize.width, height)];
        _topBar.delegate = self;
        
    }
    return _topBar;
}

-(RDReadCatalogView *)catalogView
{
    if (!_catalogView) {
        _catalogView = [[RDReadCatalogView alloc] init];
        __weak typeof(self) weakSelf = self;
        _catalogView.clickBg = ^{
            [weakSelf.toolBar.menu sendActionsForControlEvents:UIControlEventTouchUpInside];
        };
        _catalogView.delegate = self;
        
    }
    return _catalogView;
}

-(RDReadSetView *)setView
{
    if (!_setView) {
        _setView = [[RDReadSetView alloc] initWithFrame:CGRectMake(0, ScreenSize.height, ScreenSize.width, 120)];
        _setView.backgroundColor = RDReadBg;
        _setView.delegate = self;
    }
    return _setView;
}
-(RDReadLightView *)lightView
{
    if (!_lightView) {
        _lightView = [[RDReadLightView alloc] initWithFrame:CGRectMake(0, ScreenSize.height, ScreenSize.width, 120)];
        _lightView.backgroundColor = RDReadBg;
    }
    return _lightView;
}

-(RDReadProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[RDReadProgressView alloc] initWithFrame:CGRectMake(0, ScreenSize.height, ScreenSize.width, 120)];
        _progressView.backgroundColor = RDReadBg;
        _progressView.delegate = self;
    }
    return _progressView;
}

-(UIView *)gesView
{
    if (!_gesView) {
        _gesView = [[UIView alloc] init];
        _gesView.backgroundColor = [UIColor clearColor];
        [_gesView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ges:)]];
    }
    return _gesView;
}

-(void)ges:(UITapGestureRecognizer *)ges
{
    if ([self.delegate respondsToSelector:@selector(cancelShowMenu:)]) {
        [self.delegate cancelShowMenu:self];
    }
}

-(void)showInView:(UIView *)view
{
    self.frame = view.bounds;
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.toolBar.frame = CGRectMake(0, self.height-kToolBarHeight, self.width, kToolBarHeight);
        self.topBar.frame = CGRectMake(0, 0, self.width, [UIView navigationBar]+[UIView statusBar]);
    }];
}
-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.toolBar.frame = CGRectMake(0, ScreenHeight, ScreenWidth, kToolBarHeight);
         CGFloat height = [UIView navigationBar]+[UIView statusBar];
        self.topBar.frame = CGRectMake(0, -height, ScreenSize.width, height);
        if (self.showView) {
            self.showView.frame = CGRectMake(0, ScreenHeight, self.showView.width, self.showView.height);
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)showInView:(UIView *)view complete:(void(^)(void))complete
{
    self.frame = view.bounds;
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.toolBar.frame = CGRectMake(0, self.height-kToolBarHeight, self.width, kToolBarHeight);
        self.topBar.frame = CGRectMake(0, 0, self.width, [UIView navigationBar]+[UIView statusBar]);
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}
-(void)dismissComplete:(void(^)(void))complete
{
    [UIView animateWithDuration:0.3 animations:^{
        self.toolBar.frame = CGRectMake(0, ScreenHeight, ScreenWidth, kToolBarHeight);
         CGFloat height = [UIView navigationBar]+[UIView statusBar];
        self.topBar.frame = CGRectMake(0, -height, ScreenSize.width, height);
        if (self.showView) {
            self.showView.frame = CGRectMake(0, ScreenHeight, self.showView.width, self.showView.height);
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (complete) {
            complete();
        }
    }];
}
#pragma mark - Action
-(void)didMenu
{
    if (self.showView && self.showView!=self.catalogView) {
        [self.catalogView show];
        self.showView.frame = CGRectMake(0, ScreenHeight, self.showView.width, self.showView.height);
        self.showView = self.catalogView;
    }
    else{
        if (self.showView == self.catalogView) {
            [self.catalogView dismiss];
            self.showView = nil;
        }else{
            [self.catalogView show];
            self.showView = self.catalogView;
        }
    }
}
-(void)didSlider
{
    if (self.showView && self.showView!=self.progressView) {
        self.progressView.frame = CGRectMake(0, self.height-kToolBarHeight-120, ScreenWidth, 120);
        if (self.showView == self.catalogView) {
            [self.catalogView dismiss];
        }
        else{
            self.showView.frame = CGRectMake(0, ScreenHeight, self.showView.width, self.showView.height);
        }
        self.showView = self.progressView;
    }
    else{
        if (self.showView == self.progressView) {
            [UIView animateWithDuration:0.3 animations:^{
                self.progressView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 120);
            }];
            self.showView = nil;
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.progressView.frame = CGRectMake(0, self.height-kToolBarHeight-120, ScreenWidth, 120);
            }];
            self.showView = self.progressView;
        }
    }
}
-(void)didLight
{
    if (self.showView && self.showView!=self.lightView) {
        self.lightView.frame = CGRectMake(0, self.height-kToolBarHeight-120, ScreenWidth, 120);
        if (self.showView == self.catalogView) {
            [self.catalogView dismiss];
        }
        else{
            self.showView.frame = CGRectMake(0, ScreenHeight, self.showView.width, self.showView.height);
        }
        
        self.showView = self.lightView;
    }
    else{
        if (self.showView == self.lightView) {
            [UIView animateWithDuration:0.3 animations:^{
                self.lightView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 120);
            }];
            self.showView = nil;
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.lightView.frame = CGRectMake(0, self.height-kToolBarHeight-120, ScreenWidth, 120);
            }];
            self.showView = self.lightView;
        }
    }
    
}
-(void)didSetting
{
    if (self.showView && self.showView!=self.setView) {
        self.setView.frame = CGRectMake(0, self.height-kToolBarHeight-120, ScreenWidth, 120);
        if (self.showView == self.catalogView) {
            [self.catalogView dismiss];
        }
        else{
            self.showView.frame = CGRectMake(0, ScreenHeight, self.showView.width, self.showView.height);
        }
        self.showView = self.setView;
    }
    else{
        if (self.showView == self.setView) {
           [UIView animateWithDuration:0.3 animations:^{
               self.setView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 120);
           }];
           self.showView = nil;
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                           self.setView.frame = CGRectMake(0, self.height-kToolBarHeight-120, ScreenWidth, 120);
                       }];
                       self.showView = self.setView;
        }
    }
    
}

#pragma mark -Delegate

-(void)didSelectCharpter:(RDCharpterModel *)charpter
{
    if ([self.delegate respondsToSelector:@selector(didSelectCharpter:)]) {
        [self.delegate didSelectCharpter:charpter];
    }
}

-(void)sliderToCharpter:(RDCharpterModel *)charpter
{
    if ([self.delegate respondsToSelector:@selector(sliderToCharpter:)]) {
        [self.delegate sliderToCharpter:charpter];
    }
}

-(void)backAction
{
    if ([self.delegate respondsToSelector:@selector(backAction)]) {
        [self.delegate backAction];
    }
}

-(void)qusetionAction
{
    if ([self.delegate respondsToSelector:@selector(qusetionAction)]) {
        [self.delegate qusetionAction];
    }
}

-(void)downloadAction
{
    if ([self.delegate respondsToSelector:@selector(downloadAction)]) {
        [self.delegate downloadAction];
    }
}

-(void)reloadAction{
    if ([self.delegate respondsToSelector:@selector(reloadAction)]) {
        [self.delegate reloadAction];
    }
}

-(void)didChangePageType
{
    if ([self.delegate respondsToSelector:@selector(didChangePageType)]) {
        [self.delegate didChangePageType];
    }
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    self.gesView.frame = self.bounds;
}
@end
