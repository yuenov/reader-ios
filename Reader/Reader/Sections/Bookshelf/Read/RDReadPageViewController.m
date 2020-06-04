//
//  RDReadPageViewController.m
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDReadPageViewController.h"
#import "RDReadParser.h"
#import "RDReadController.h"
#import "RDCharpterDataManager.h"
#import "RDReadRecordManager.h"
#import "RDCharpterManager.h"
#import "RDMenuView.h"
#import "RDReadCatalogCell.h"
#import "RDReadCatalogView.h"
#import "RDReadProgressView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "RDReadConfigManager.h"
#import "RDReadSetView.h"
#import "RDDownloadController.h"
#import "RDHistoryRecordManager.h"
#import "RDCacheModel.h"
#import "RDForceUpdateApi.h"
#import "RDCheckApi.h"
#import "RDCharpterApi.h"

@implementation UIPageViewController (EnlargeTapRegion)
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}
 
@end


@interface RDReadPageView : UIView
@property (nonatomic,strong) UIView *brightnessView;
@end

@implementation RDReadPageView
-(void)addSubview:(UIView *)view
{
    if (view != self.brightnessView && self.brightnessView) {
        NSInteger index = [self.subviews indexOfObject:self.brightnessView];
        if (index != NSNotFound) {
            [self insertSubview:view atIndex:index];
        }
        else{
            [super addSubview:view];
        }
    }
    else{
        [super addSubview:view];
    }
}
@end

#define kAdPages 10

@interface RDReadPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,RDMenuViewDelegate,RDReadControllerDelegate>
@property (nonatomic,strong) UIPageViewController *pageViewController;

@property (nonatomic,strong) NSArray <RDCharpterModel *>*charpters;    //简短的章节信息，不包含内容
@property (nonatomic,strong) UIView *brightnessView;

@property (nonatomic,assign) BOOL isShowStatusBar;
@property (nonatomic,strong) RDMenuView *menuView;


@property (nonatomic,assign) NSInteger userPages;   //用户翻到第几页，用来记录展示广告的页数
@end

@implementation RDReadPageViewController

-(void)loadView
{
    UIView *view = [[RDReadPageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userPages = 0;
    [RDCacheModel sharedInstance].book = self.bookDetail;
    [[RDCacheModel sharedInstance] archive];
    self.fd_interactivePopDisabled = YES;
    [self addChildViewController:self.pageViewController];
    self.charpters = [RDCharpterDataManager getBriefCharptersWithBookId:self.bookDetail.bookId];
    [self initSteup];
    
    

        
    RDReadPageView *view = (RDReadPageView *)self.view;
    view.brightnessView = self.brightnessView;
    
    [self.view addSubview:self.brightnessView];
    
    
    //亮度
    [self.KVOController observe:[RDReadConfigManager sharedInstance] keyPath:@"brightness" options:NSKeyValueObservingOptionNew block:^(RDReadPageViewController*  observer, RDReadConfigManager  * object, NSDictionary<NSString *,id> * _Nonnull change) {
        observer.brightnessView.alpha = kConfigMaxBrightnessValue - object.brightness;
    }];
    //字体
    [self.KVOController observe:[RDReadConfigManager sharedInstance] keyPath:@"fontSize" options:NSKeyValueObservingOptionNew block:^(RDReadPageViewController*  observer, RDReadConfigManager  * object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        [RDReadParser paginateWithContent:observer.bookDetail.charpterModel.content charpter:observer.bookDetail.charpterModel.name bounds:CGRectMake(0, 0, ScreenWidth-kLeftMargin-kRightMargin, ScreenHeight-kTopMargin-kBottomMargin) complete:^(NSAttributedString * _Nonnull content, NSArray * _Nonnull pages) {
            [observer.pageViewController setViewControllers:@[[observer p_creatReadController:observer.bookDetail.charpterModel.name content:[observer p_getCurPageContentWithContent:content page:[observer p_safePage:observer.bookDetail.page totalPages:pages.count] pages:pages] page:[observer p_safePage:observer.bookDetail.page totalPages:pages.count] totalPage:pages.count charpterIndex:[observer p_getCurCharpter] totalCharpter:observer.charpters.count charpterModel:observer.bookDetail.charpterModel charpterContent:content pages:pages]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }];
    }];
    
    [self p_updateChapter];
}

-(void)p_updateChapter
{
    if (!self.bookDetail.onBookshelf) {
        //不在书架上的书籍检查更新章节信息
        RDCharpterModel *chapter = [RDCharpterDataManager getLastChapterWithBookId:self.bookDetail.bookId];
        RDCheckApi *api = [[RDCheckApi alloc] init];
        api.books = @[chapter];
        [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
            if (!error) {
                for (NSDictionary *dic in [api updateBooks]) {
                    RDCharpterApi *api = [[RDCharpterApi alloc] init];
                    api.bookId = [dic[@"bookId"] integerValue];
                    api.chapterId = [dic[@"chapterId"] integerValue];
                    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
                        if (!error) {
                            NSArray *charpters = [api charpters];
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                [RDCharpterDataManager insertObjectsWithCharpters:charpters];
                            });
                        }
                    }];
                }
            }
        }];
    }
}

-(UIView *)brightnessView
{
    if (!_brightnessView) {
        _brightnessView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _brightnessView.backgroundColor = [UIColor blackColor];
        _brightnessView.alpha = kConfigMaxBrightnessValue - [RDReadConfigManager sharedInstance].brightness;
        _brightnessView.userInteractionEnabled = NO;
    }
    return _brightnessView;
}
-(BOOL)prefersStatusBarHidden
{
    return !_isShowStatusBar;
}



-(void)nextPage:(RDReadController *)controller
{
    if (self.pageViewController.transitionStyle == UIPageViewControllerTransitionStylePageCurl) {
        [self p_setAfterOrBeforeViewControllerWithBefore:NO mirror:YES];
    }
    else{
        [self p_setAfterOrBeforeViewControllerWithBefore:NO];
    }
    
    [self p_saveRecord];
}
-(void)lastPage:(RDReadController *)controller
{
    if (self.pageViewController.transitionStyle == UIPageViewControllerTransitionStylePageCurl){
        [self p_setAfterOrBeforeViewControllerWithBefore:YES mirror:YES];
    }
    else{
        [self p_setAfterOrBeforeViewControllerWithBefore:YES];
    }
    [self p_saveRecord];
}
-(void)invokeMenu:(RDReadController *)controller
{
    if (self.menuView.superview) {
        _isShowStatusBar = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        [self.menuView dismiss];
    }
    else{
        _isShowStatusBar = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        self.menuView = [[RDMenuView alloc] init];
        self.menuView.delegate = self;
        self.menuView.charpters = self.charpters;
        self.menuView.book = self.bookDetail;
        [self.menuView showInView:self.view];
    }
}

-(void)initSteup{
    [RDReadParser paginateWithContent:self.bookDetail.charpterModel.content charpter:self.bookDetail.charpterModel.name bounds:CGRectMake(0, 0, ScreenWidth-kLeftMargin-kRightMargin, ScreenHeight-kTopMargin-kBottomMargin) complete:^(NSAttributedString * _Nonnull content, NSArray * _Nonnull pages) {
        [self.pageViewController setViewControllers:@[[self p_creatReadController:self.bookDetail.charpterModel.name content:[self p_getCurPageContentWithContent:content page:[self p_safePage:self.bookDetail.page totalPages:pages.count] pages:pages] page:[self p_safePage:self.bookDetail.page totalPages:pages.count] totalPage:pages.count charpterIndex:[self p_getCurCharpter] totalCharpter:self.charpters.count charpterModel:self.bookDetail.charpterModel charpterContent:content pages:pages]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }];
    //默认加载上一章或下一章的数据
    [self p_downloads];
}

-(void)p_downloads{
    NSInteger index = [self.charpters indexOfObject:self.bookDetail.charpterModel];
    NSMutableArray *charpters = [NSMutableArray array];
    if (index == 0) {
        //第一页
        if (self.charpters.count>2) {
            RDCharpterModel *model1 = self.charpters[1];
            RDCharpterModel *model2 = self.charpters[2];
            [charpters addObjectsFromArray:@[@(model1.charpterId),@(model2.charpterId)]];
        }
    }
    else if (index == self.charpters.count-1){
        //最后一页
        if (self.charpters.count>2) {
            RDCharpterModel *model1 = self.charpters[index-2];
            RDCharpterModel *model2 = self.charpters[index-1];
            [charpters addObjectsFromArray:@[@(model1.charpterId),@(model2.charpterId)]];
        }
    }
    else{
        //中间页
        RDCharpterModel *model1 = self.charpters[index-1];
        RDCharpterModel *model2 = self.charpters[index+1];
        [charpters addObjectsFromArray:@[@(model1.charpterId),@(model2.charpterId)]];
    }
    [RDCharpterManager slientDownWithBookId:self.bookDetail.bookId charpterIds:charpters.copy];
}

-(void)p_saveRecord
{
    NSInteger charpterId = self.bookDetail.charpterModel.charpterId;
    
    RDReadController *readController = self.pageViewController.viewControllers.firstObject;
    self.bookDetail.charpterModel = readController.charpterModel;
    self.bookDetail.page = readController.page;
    [RDReadRecordManager insertOrReplaceModel:self.bookDetail];
    
    if (charpterId != self.bookDetail.charpterModel.charpterId && self.bookDetail.page == 0) {
        //新的一章
        [self p_downloads];
    }
    
}

-(RDReadController *)p_creatReadController:(NSString *)charpter content:(NSAttributedString *)content page:(NSInteger)page totalPage:(NSInteger)totalPage charpterIndex:(NSInteger)index totalCharpter:(NSInteger)total charpterModel:(RDCharpterModel *)charpterModel charpterContent:(NSAttributedString *)charpterContent pages:(NSArray *)pages;
{
    return [self p_creatReadController:charpter content:content page:page totalPage:totalPage charpterIndex:index totalCharpter:total charpterModel:charpterModel charpterContent:charpterContent pages:pages mirror:NO];
}

-(RDReadController *)p_creatReadController:(NSString *)charpter content:(NSAttributedString *)content page:(NSInteger)page totalPage:(NSInteger)totalPage charpterIndex:(NSInteger)index totalCharpter:(NSInteger)total charpterModel:(RDCharpterModel *)charpterModel charpterContent:(NSAttributedString *)charpterContent pages:(NSArray *)pages mirror:(BOOL)mirror
{
    RDReadController *readController = [[RDReadController alloc] init];
    readController.mirror = mirror;
    [readController setCharpter:charpter content:content page:page totalPage:totalPage charpterIndex:index totalCharpter:total];
    readController.charpterContent = charpterContent;
    readController.charpterModel = charpterModel;
    readController.pages = pages;
    readController.delegate = self;
    return readController;
}


-(NSInteger)p_safePage:(NSInteger)page totalPages:(NSInteger)pages
{
    if (page<0) {
        page = 0;
    }
    if (page>= pages) {
        page = pages-1;
    }
    return page;
}

-(NSAttributedString *)p_getCurPageContentWithContent:(NSAttributedString *)conetnt page:(NSInteger)page pages:(NSArray *)pages
{
//    if (page>0) {
//        NSAttributedString *last = [self p_subGetCurPageContentWithContent:conetnt page:page-1 pages:pages];
//
//        NSAttributedString *current = [self p_subGetCurPageContentWithContent:conetnt page:page pages:pages];
//
//        if (![[last.string substringFromIndex:last.string.length-1] isEqualToString:@"\n"]) {
//            //最后一个字符不是换行，下一页首行不缩进
//            NSMutableAttributedString *muCurrent = [[NSMutableAttributedString alloc] initWithAttributedString:current];
//            NSDictionary *attr = [RDReadParser paraserFontArrribute:[RDReadConfigManager sharedInstance]];
//            NSMutableDictionary *muAttr = attr.mutableCopy;
//            NSMutableParagraphStyle *para = muAttr[NSParagraphStyleAttributeName];
//            para.firstLineHeadIndent = 0;
//            [muCurrent setAttributes:muAttr range:NSMakeRange(0, 1)];
//            return muCurrent.copy;
//        }
//        return current;
//
//    }
//    else{
//        return [self p_subGetCurPageContentWithContent:conetnt page:page pages:pages];
//    }
    return [self p_subGetCurPageContentWithContent:conetnt page:page pages:pages];
}

-(NSAttributedString *)p_subGetCurPageContentWithContent:(NSAttributedString *)conetnt page:(NSInteger)page pages:(NSArray *)pages
{
    NSInteger index = page;
    NSInteger loc = [pages[index] integerValue];
    NSInteger len = 0;
    if (index<pages.count-1) {
        len = [pages[index+1] integerValue] - loc;
    }
    else{
        len = conetnt.length - loc;
    }
    return [conetnt attributedSubstringFromRange:NSMakeRange(loc, len)];

}



//当前章节索引
-(NSInteger)p_getCurCharpter
{
    return [self.charpters indexOfObject:self.bookDetail.charpterModel];
}

-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        RDPageType pageType = [RDReadConfigManager sharedInstance].pageType;
        UIPageViewControllerTransitionStyle style;
        switch (pageType) {
            case RDRealTypePage:
                style = UIPageViewControllerTransitionStylePageCurl;
                break;
            default:
                style = UIPageViewControllerTransitionStyleScroll;
                break;
        }
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:style navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        if (pageType != RDNoneTypePage) {
            _pageViewController.dataSource = self;
            _pageViewController.doubleSided = (style == UIPageViewControllerTransitionStylePageCurl);
        }
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}

#pragma mark - UIPageViewContrillerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        [self p_saveRecord];
    }
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.pageViewController.transitionStyle == UIPageViewControllerTransitionStylePageCurl) {
        RDReadController *currentController = (RDReadController *)viewController;
        if (!currentController.mirror) {
            RDReadController *mirrorController = (RDReadController *)[self p_afterOrBeforeWithViewController:viewController before:YES mirror:YES];
            return mirrorController;
        }
        return [self p_creatReadController:currentController.charpter content:currentController.content page:currentController.page totalPage:currentController.totalPage charpterIndex:currentController.charpterIndex totalCharpter:currentController.totalCharpter charpterModel:currentController.charpterModel charpterContent:currentController.charpterContent pages:currentController.pages mirror:NO];
    }
    return [self p_afterOrBeforeWithViewController:viewController before:YES];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.pageViewController.transitionStyle == UIPageViewControllerTransitionStylePageCurl) {
        RDReadController *currentController = (RDReadController *)viewController;
        if (!currentController.mirror) {
            return [self p_creatReadController:currentController.charpter content:currentController.content page:currentController.page totalPage:currentController.totalPage charpterIndex:currentController.charpterIndex totalCharpter:currentController.totalCharpter charpterModel:currentController.charpterModel charpterContent:currentController.charpterContent pages:currentController.pages mirror:YES];
        }
    }
   return [self p_afterOrBeforeWithViewController:viewController before:NO];
    
}

/// 返回前一个或者后一个控制器
/// @param controller 当前控制区内
/// @param before 是否是前一个控制器
-(UIViewController *)p_afterOrBeforeWithViewController:(UIViewController *)controller before:(BOOL)before
{
    return [self p_afterOrBeforeWithViewController:controller before:before mirror:NO];

}
-(UIViewController *)p_afterOrBeforeWithViewController:(UIViewController *)controller before:(BOOL)before mirror:(BOOL)mirror
{
    RDReadController *currentController = (RDReadController *)controller;
    NSInteger page = currentController.page;   //当前页数
    NSInteger charpter = currentController.charpterIndex; //当前章节
    RDCharpterModel *charpterModel = currentController.charpterModel;   //当前章节信息
    NSAttributedString *charpterContent = currentController.charpterContent;    //当前章节内容
    NSArray *pages = currentController.pages;       //分页信息数组
    
    
    UIPageViewControllerNavigationDirection direction;
    if (before) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    else{
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    
    BOOL animate;
    if ([RDReadConfigManager sharedInstance].pageType == RDNoneTypePage) {
        animate = NO;
    }
    else{
        animate = YES;
    }
    
    if (before) {
        if (page == 0 && charpter == 0) {
           //第一章，第一页，不用做任何处理
            return nil;
        }
    }
    else{
        if (page == pages.count-1 && charpter == self.charpters.count-1) {
            //最后一张最后一页，不用做任何处理
            return nil;
        }
    }
    if ((before && (page == 0)) || (!before && (page == pages.count-1) )) {
        //上一章的数据 或者下一章的数据
        NSInteger charpterId;
        if (before) {
            charpterId = self.charpters[charpter-1].charpterId;
        }
        else{
            charpterId = self.charpters[charpter+1].charpterId;
        }
        
        RDCharpterModel *otherCharpterModel = [RDCharpterDataManager getCharpterWithBookId:self.bookDetail.bookId charpterId:charpterId];
        if (otherCharpterModel.content.length == 0) {
            //内容不存在
            __block RDReadController * readController;
            [RDCharpterManager getCharpterWithBookId:self.bookDetail.bookId charpterId:charpterId complete:^(BOOL success,RDCharpterModel * _Nonnull model) {
                if (success) {
                    [RDReadParser paginateWithContent:model.content charpter:model.name bounds:CGRectMake(0, 0, ScreenWidth-kLeftMargin-kRightMargin, ScreenHeight-kTopMargin-kBottomMargin) complete:^(NSAttributedString * _Nonnull content, NSArray * _Nonnull pages) {
                        
                        if ([RDReadConfigManager sharedInstance].pageType == RDRealTypePage) {
                            if (before) {
                                //上一章
                                
                                RDReadController * readController = [self p_creatReadController:model.name content:[self p_getCurPageContentWithContent:content page:pages.count-1 pages:pages] page:pages.count-1 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:model] totalCharpter:self.charpters.count charpterModel:model charpterContent:content pages:pages];
                                RDReadController * mirror_readController = [self p_creatReadController:model.name content:[self p_getCurPageContentWithContent:content page:pages.count-1 pages:pages] page:pages.count-1 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:model] totalCharpter:self.charpters.count charpterModel:model charpterContent:content pages:pages mirror:YES];
                                [self.pageViewController setViewControllers:@[readController,mirror_readController] direction:direction animated:animate completion:nil];
                            }
                            else{
                                //下一章
                                RDReadController * mirror_readController = [self p_creatReadController:currentController.charpter content:currentController.content page:currentController.page totalPage:currentController.totalPage charpterIndex:currentController.charpterIndex totalCharpter:currentController.totalCharpter charpterModel:currentController.charpterModel charpterContent:currentController.charpterContent pages:currentController.pages mirror:YES];
                                //后一页
                                RDReadController * readController = [self p_creatReadController:model.name content:[self p_getCurPageContentWithContent:content page:0 pages:pages] page:0 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:model] totalCharpter:self.charpters.count charpterModel:model charpterContent:content pages:pages];
                                [self.pageViewController setViewControllers:@[readController,mirror_readController] direction:direction animated:animate completion:nil];
                                
                            }
                            
                        }
                        else{
                            RDReadController * readController = [self p_creatReadController:model.name content:[self p_getCurPageContentWithContent:content page:before?pages.count-1:0 pages:pages] page:before?pages.count-1:0 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:model] totalCharpter:self.charpters.count charpterModel:model charpterContent:content pages:pages];
                            [self.pageViewController setViewControllers:@[readController] direction:direction animated:animate completion:nil];
                        }
                        [self p_saveRecord];

                    }];
                }
            }];
            return readController;
        }
        else{
            //需要重新分页
            __block RDReadController *readController = nil;
            [RDReadParser paginateWithContent:otherCharpterModel.content charpter:otherCharpterModel.name bounds:CGRectMake(0, 0, ScreenWidth-kLeftMargin-kRightMargin, ScreenHeight-kTopMargin-kBottomMargin) complete:^(NSAttributedString * _Nonnull content, NSArray * _Nonnull pages) {
                
                readController = [self p_creatReadController:otherCharpterModel.name content:[self p_getCurPageContentWithContent:content page:before?pages.count-1:0 pages:pages] page:before?pages.count-1:0 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:otherCharpterModel] totalCharpter:self.charpters.count charpterModel:otherCharpterModel charpterContent:content pages:pages mirror:mirror];
        
                
            }];
            return readController;
        }
        

    }
    else{
        RDReadController *readController = [self p_creatReadController:charpterModel.name content:[self p_getCurPageContentWithContent:charpterContent page:before?page-1:page+1 pages:pages] page:before?page-1:page+1 totalPage:pages.count charpterIndex:charpter totalCharpter:self.charpters.count charpterModel:charpterModel charpterContent:charpterContent pages:pages mirror:mirror];
        return readController;
        
    }
}

-(void)p_setAfterOrBeforeViewControllerWithBefore:(BOOL)before
{
    
    [self p_setAfterOrBeforeViewControllerWithBefore:before mirror:NO];
}

-(void)p_setAfterOrBeforeViewControllerWithBefore:(BOOL)before mirror:(BOOL)mirror
{
    RDReadController *currentController = (RDReadController *)_pageViewController.viewControllers.firstObject;
    NSInteger page = currentController.page;   //当前页数
    NSInteger charpter = currentController.charpterIndex; //当前章节
    RDCharpterModel *charpterModel = currentController.charpterModel;   //当前章节信息
    NSAttributedString *charpterContent = currentController.charpterContent;    //当前章节内容
    NSArray *pages = currentController.pages;       //分页信息数组
    
    UIPageViewControllerNavigationDirection direction;
    if (before) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    else{
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    
    BOOL animate;
    if ([RDReadConfigManager sharedInstance].pageType == RDNoneTypePage) {
        animate = NO;
    }
    else{
        animate = YES;
    }
    
    if (before) {
        if (page == 0 && charpter == 0) {
           //第一章，第一页，不用做任何处理
            return;
        }
    }
    else{
        if (page == pages.count-1 && charpter == self.charpters.count-1) {
            //最后一张最后一页，不用做任何处理
            return;
        }
    }
    if ((before && (page == 0)) || (!before && (page == pages.count-1) )) {
        //上一章的数据 或者下一章的数据
        NSInteger charpterId;
        if (before) {
            charpterId = self.charpters[charpter-1].charpterId;
        }
        else{
            charpterId = self.charpters[charpter+1].charpterId;
        }
        
        RDCharpterModel *otherCharpterModel = [RDCharpterDataManager getCharpterWithBookId:self.bookDetail.bookId charpterId:charpterId];
        if (otherCharpterModel.content.length == 0) {
            //内容不存在
            [RDCharpterManager getCharpterWithBookId:self.bookDetail.bookId charpterId:charpterId complete:^(BOOL success,RDCharpterModel * _Nonnull model) {
                if (success) {
                    
                    [RDReadParser paginateWithContent:model.content charpter:model.name bounds:CGRectMake(0, 0, ScreenWidth-kLeftMargin-kRightMargin, ScreenHeight-kTopMargin-kBottomMargin) complete:^(NSAttributedString * _Nonnull content, NSArray * _Nonnull pages) {
                        
                        if (mirror) {
                            if (before) {
                                //上一章
                                
                                RDReadController * readController = [self p_creatReadController:model.name content:[self p_getCurPageContentWithContent:content page:pages.count-1 pages:pages] page:pages.count-1 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:model] totalCharpter:self.charpters.count charpterModel:model charpterContent:content pages:pages];
                                RDReadController * mirror_readController = [self p_creatReadController:model.name content:[self p_getCurPageContentWithContent:content page:pages.count-1 pages:pages] page:pages.count-1 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:model] totalCharpter:self.charpters.count charpterModel:model charpterContent:content pages:pages mirror:YES];
                                [self.pageViewController setViewControllers:@[readController,mirror_readController] direction:direction animated:animate completion:nil];
                            }
                            else{
                                //下一章
                               RDReadController * mirror_readController = [self p_creatReadController:currentController.charpter content:currentController.content page:currentController.page totalPage:currentController.totalPage charpterIndex:currentController.charpterIndex totalCharpter:currentController.totalCharpter charpterModel:currentController.charpterModel charpterContent:currentController.charpterContent pages:currentController.pages mirror:YES];
                                //后一页
                                RDReadController * readController = [self p_creatReadController:model.name content:[self p_getCurPageContentWithContent:content page:0 pages:pages] page:0 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:model] totalCharpter:self.charpters.count charpterModel:model charpterContent:content pages:pages];
                                [self.pageViewController setViewControllers:@[readController,mirror_readController] direction:direction animated:animate completion:nil];
                                
                            }
                            
                        }
                        else{
                            RDReadController * readController = [self p_creatReadController:model.name content:[self p_getCurPageContentWithContent:content page:before?pages.count-1:0 pages:pages] page:before?pages.count-1:0 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:model] totalCharpter:self.charpters.count charpterModel:model charpterContent:content pages:pages];
                            [self.pageViewController setViewControllers:@[readController] direction:direction animated:animate completion:nil];
                        }
                        
                         [self p_saveRecord];
                        
                    }];
                }
            }];
        }
        else{
            //需要重新分页
            __block RDReadController *readController = nil;
            [RDReadParser paginateWithContent:otherCharpterModel.content charpter:otherCharpterModel.name bounds:CGRectMake(0, 0, ScreenWidth-kLeftMargin-kRightMargin, ScreenHeight-kTopMargin-kBottomMargin) complete:^(NSAttributedString * _Nonnull content, NSArray * _Nonnull pages) {
                
                if (mirror) {
                    if (before) {
                        RDReadController * readController = [self p_creatReadController:otherCharpterModel.name content:[self p_getCurPageContentWithContent:content page:pages.count-1 pages:pages] page:pages.count-1 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:otherCharpterModel] totalCharpter:self.charpters.count charpterModel:otherCharpterModel charpterContent:content pages:pages];
                        RDReadController * mirror_readController = [self p_creatReadController:otherCharpterModel.name content:[self p_getCurPageContentWithContent:content page:pages.count-1 pages:pages] page:pages.count-1 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:otherCharpterModel] totalCharpter:self.charpters.count charpterModel:otherCharpterModel charpterContent:content pages:pages mirror:YES];
                        [self.pageViewController setViewControllers:@[readController,mirror_readController] direction:direction animated:animate completion:nil];
                    }
                    else{
                        RDReadController * mirror_readController = [self p_creatReadController:currentController.charpter content:currentController.content page:currentController.page totalPage:currentController.totalPage charpterIndex:currentController.charpterIndex totalCharpter:currentController.totalCharpter charpterModel:currentController.charpterModel charpterContent:currentController.charpterContent pages:currentController.pages mirror:YES];
                        //后一页
                        RDReadController * readController = [self p_creatReadController:otherCharpterModel.name content:[self p_getCurPageContentWithContent:content page:0 pages:pages] page:0 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:otherCharpterModel] totalCharpter:self.charpters.count charpterModel:otherCharpterModel charpterContent:content pages:pages];
                        [self.pageViewController setViewControllers:@[readController,mirror_readController] direction:direction animated:animate completion:nil];
                    }
                }
                else{
                    readController = [self p_creatReadController:otherCharpterModel.name content:[self p_getCurPageContentWithContent:content page:before?pages.count-1:0 pages:pages] page:before?pages.count-1:0 totalPage:pages.count charpterIndex:[self.charpters indexOfObject:otherCharpterModel] totalCharpter:self.charpters.count charpterModel:otherCharpterModel charpterContent:content pages:pages];
                    [self.pageViewController setViewControllers:@[readController] direction:direction animated:animate completion:nil];
                }
                
            }];
        }

    }
    else{
        
        if (mirror) {
            if (before) {
                RDReadController *readController = [self p_creatReadController:charpterModel.name content:[self p_getCurPageContentWithContent:charpterContent page:page-1 pages:pages] page:page-1 totalPage:pages.count charpterIndex:charpter totalCharpter:self.charpters.count charpterModel:charpterModel charpterContent:charpterContent pages:pages];
                RDReadController *mirror_readController = [self p_creatReadController:charpterModel.name content:[self p_getCurPageContentWithContent:charpterContent page:page-1 pages:pages] page:page-1 totalPage:pages.count charpterIndex:charpter totalCharpter:self.charpters.count charpterModel:charpterModel charpterContent:charpterContent pages:pages mirror:YES];
                [self.pageViewController setViewControllers:@[readController,mirror_readController] direction:direction animated:animate completion:nil];
            }
            else{
                RDReadController * mirror_readController = [self p_creatReadController:currentController.charpter content:currentController.content page:currentController.page totalPage:currentController.totalPage charpterIndex:currentController.charpterIndex totalCharpter:currentController.totalCharpter charpterModel:currentController.charpterModel charpterContent:currentController.charpterContent pages:currentController.pages mirror:YES];
                RDReadController *readController = [self p_creatReadController:charpterModel.name content:[self p_getCurPageContentWithContent:charpterContent page:page+1 pages:pages] page:page+1 totalPage:pages.count charpterIndex:charpter totalCharpter:self.charpters.count charpterModel:charpterModel charpterContent:charpterContent pages:pages];
                [self.pageViewController setViewControllers:@[readController,mirror_readController] direction:direction animated:animate completion:nil];
            }
        }
        else{
            RDReadController *readController = [self p_creatReadController:charpterModel.name content:[self p_getCurPageContentWithContent:charpterContent page:before?page-1:page+1 pages:pages] page:before?page-1:page+1 totalPage:pages.count charpterIndex:charpter totalCharpter:self.charpters.count charpterModel:charpterModel charpterContent:charpterContent pages:pages];
            [self.pageViewController setViewControllers:@[readController] direction:direction animated:animate completion:nil];
        }
    }
}
-(void)reload{
    
    RDReadController *currentController = (RDReadController *)_pageViewController.viewControllers.firstObject;
    NSInteger charpter = currentController.charpterIndex; //当前章节
    NSAttributedString *charpterContent = currentController.charpterContent;    //当前章节内容
    NSArray *pages = currentController.pages;       //分页信息数组
    [self.pageViewController setViewControllers:@[[self p_creatReadController:self.bookDetail.charpterModel.name content:[self p_getCurPageContentWithContent:charpterContent page:self.bookDetail.page pages:pages] page:[self p_safePage:self.bookDetail.page totalPages:pages.count] totalPage:pages.count charpterIndex:charpter totalCharpter:self.charpters.count charpterModel:self.bookDetail.charpterModel charpterContent:charpterContent pages:pages]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - Delegate
//选择章节
-(void)didSelectCharpter:(RDCharpterModel *)charpter
{
    [self invokeMenu:self.pageViewController.viewControllers.firstObject];
    [RDCharpterManager getCharpterWithBookId:self.bookDetail.bookId charpterId:charpter.charpterId complete:^(BOOL success,RDCharpterModel * _Nonnull model) {
        if (success) {
            self.bookDetail.charpterModel = model;
            self.bookDetail.page = 0;
            [RDReadRecordManager insertOrReplaceModel:self.bookDetail];
            [self initSteup];
        }
        
    }];
    
}
//滑动到某个章节
-(void)sliderToCharpter:(RDCharpterModel *)charpter
{
    [RDCharpterManager getCharpterWithBookId:self.bookDetail.bookId charpterId:charpter.charpterId complete:^(BOOL success,RDCharpterModel * _Nonnull model) {
        if (success) {
            self.bookDetail.charpterModel = model;
             self.bookDetail.page = 0;
            [RDReadRecordManager insertOrReplaceModel:self.bookDetail];
            [self initSteup];
        }
        
    }];

}
//返回
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//下载
-(void)downloadAction
{
    RDDownloadController *controller = [[RDDownloadController alloc] init];
    controller.record = self.bookDetail;
    [self pushToController:controller];
}
//意见反馈
-(void)qusetionAction
{
    [RDToastView showText:@"该功能不可使用" delay:1.5 inView:self.view];
}
//刷新当前章节
-(void)reloadAction
{
    [self invokeMenu:_pageViewController.viewControllers.firstObject];
    [self showLoading:@"正在刷新章节..." cancel:nil];
    RDForceUpdateApi *api = [[RDForceUpdateApi alloc] init];
    api.bookId = self.bookDetail.bookId;
    api.charpters = @[@(self.bookDetail.charpterModel.charpterId)];
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        [self hideLoading];
        if (!error) {
            RDCharpterModel *model = api.charptersContent.firstObject;
            if (model.content.length == 0) {
                [self showText:@"内容不存在"];
                return;
            }
            [self showText:@"刷新成功"];
            [RDCharpterDataManager insertObjectsWithCharpters:api.charptersContent];
            
            self.bookDetail.charpterModel = model;
            self.bookDetail.page = 0;
            [RDReadRecordManager insertOrReplaceModel:self.bookDetail];
            
            [RDReadParser paginateWithContent:self.bookDetail.charpterModel.content charpter:self.bookDetail.charpterModel.name bounds:CGRectMake(0, 0, ScreenWidth-kLeftMargin-kRightMargin, ScreenHeight-kTopMargin-kBottomMargin) complete:^(NSAttributedString * _Nonnull content, NSArray * _Nonnull pages) {
                [self.pageViewController setViewControllers:@[[self p_creatReadController:self.bookDetail.charpterModel.name content:[self p_getCurPageContentWithContent:content page:[self p_safePage:self.bookDetail.page totalPages:pages.count] pages:pages] page:[self p_safePage:self.bookDetail.page totalPages:pages.count] totalPage:pages.count charpterIndex:[self p_getCurCharpter] totalCharpter:self.charpters.count charpterModel:self.bookDetail.charpterModel charpterContent:content pages:pages]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }];
            
        }
        else{
            [self showText:error];
        }
    }];
    
    
}

//更改翻页方式
-(void)didChangePageType
{
    [self invokeMenu:self.pageViewController.viewControllers.firstObject];
    RDReadController *currentController = (RDReadController *)_pageViewController.viewControllers.firstObject;
    NSInteger charpter = currentController.charpterIndex; //当前章节
    NSAttributedString *charpterContent = currentController.charpterContent;    //当前章节内容
    NSArray *pages = currentController.pages;       //分页信息数组
    
    
    [_pageViewController.view removeFromSuperview];
    [_pageViewController removeFromParentViewController];
    _pageViewController = nil;
    [self addChildViewController:self.pageViewController];
    
    [self.pageViewController setViewControllers:@[[self p_creatReadController:self.bookDetail.charpterModel.name content:[self p_getCurPageContentWithContent:charpterContent page:self.bookDetail.page pages:pages] page:[self p_safePage:self.bookDetail.page totalPages:pages.count] totalPage:pages.count charpterIndex:charpter totalCharpter:self.charpters.count charpterModel:self.bookDetail.charpterModel charpterContent:charpterContent pages:pages]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}


-(void)cancelShowMenu:(RDMenuView *)menu
{
    [self invokeMenu:self.pageViewController.viewControllers.firstObject];
}

-(void)dealloc
{
    [RDCacheModel sharedInstance].book = nil;
    [[RDCacheModel sharedInstance] archive];
}

@end
