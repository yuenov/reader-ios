//
//  RDBookDetailController.m
//  Reader
//
//  Created by yuenov on 2019/10/30.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBookDetailController.h"
#import "RDBookDetailCoverCell.h"
#import "RDBookDetailRecomCell.h"
#import "RDBookToolBar.h"
#import "RDReadController.h"
#import "RDReadDetailApi.h"
#import "RDReadRecordManager.h"
#import "RDReadPageViewController.h"
#import "RDCharpterManager.h"
#import "RDDownloadController.h"
#import "RDCharpterDataManager.h"
#import "RDCheckApi.h"
#import "RDCharpterApi.h"
#import "RDHistoryRecordManager.h"
#import <StoreKit/StoreKit.h>
@interface RDBookDetailController () <UITableViewDelegate,UITableViewDataSource,RDBookToolBarDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) RDBookDetailModel *model;
@property (nonatomic,strong) RDBookToolBar *toolbar;
@end
 
@implementation RDBookDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    adjustsContentInsets(self.tableView);
    [self fetch];
}

-(void)fetch{
    RDReadDetailApi *api = [[RDReadDetailApi alloc] init];
    api.bookId = self.bookId;
    [self showLoadingGifWithCancel:^{
        [api stop];
    }];
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        [self hideLoadingGif];
        if (!error) {
            
            [self.view addSubview:self.tableView];
            [self.view addSubview:self.topView];
            [self.view addSubview:self.toolbar];
            self.topView.titleLabel.text = self.model.title;
            self.topView.alpha = 0;
            RDBookDetailModel *record = [RDReadRecordManager getReadRecordWithBookId:self.bookId];
            if (record.charpterModel) {
                //阅读记录存在
                [self.toolbar.begin setTitle:@"继续阅读" forState:UIControlStateNormal];
            }
            
            if (record.onBookshelf) {
                self.toolbar.addBook.enabled = NO;
            }
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.top.equalTo(self.view);
                make.bottom.equalTo(self.toolbar.mas_top).offset(5);
            }];
            [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.bottom.equalTo(self.view);
                make.height.mas_equalTo(65+[UIView safeBottomBar]);
            }];
            self.model = api.detailBook;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [RDHistoryRecordManager insertOrReplaceModel:self.model];
                if (@available(iOS 10.3, *)) {
                    NSInteger count = [RDHistoryRecordManager getHisoryCount];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (count%16 == 15) {
                            [SKStoreReviewController requestReview];
                        }
                        
                    });
                    
                }
            });
            
            [self.tableView reloadData];
            
//            if (@available()) {
//
//            }
            
        }
        else{
            [self showErrorWithString:error];
        }
        
    }];
    
    if ([RDCharpterDataManager isExsitWithBookId:self.bookId]) {
        //本地有缓存的目录
        RDCharpterModel *chapter = [RDCharpterDataManager getLastChapterWithBookId:self.bookId];
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

-(void)reloadFetch
{
    [self hiddenError];
    [self fetch];
}

-(NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"RDBookDetailCoverCell",@"RDBookDetailRecomCell"];
    }
    return _dataSource;
}

-(RDBookToolBar *)toolbar
{
    if (!_toolbar) {
        _toolbar = [[RDBookToolBar alloc] init];
        _toolbar.delegate = self;
    }
    return _toolbar;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 350;
        _tableView.backgroundColor = [UIColor colorWithHexValue:0xf5f7fa];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RDBookDetailBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:self.dataSource[indexPath.row]];
    if (!cell) {
        cell = [[NSClassFromString(self.dataSource[indexPath.row]) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.dataSource[indexPath.row]];
        if ([cell isKindOfClass:RDBookDetailRecomCell.class]) {
            RDBookDetailRecomCell *recomCell = (RDBookDetailRecomCell *)cell;
            __weak typeof(self) ws = self;
            [recomCell setNeedReload:^(RDBookDetailModel * _Nonnull model) {
                [ws.tableView reloadData];
            }];
        }
    }
    cell.model = self.model;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>40) {
        if (self.topView.alpha == 0) {
            [UIView animateWithDuration:0.35 animations:^{
                self.topView.alpha = 1;
            }];
        }
        
    }
    else {
        if (self.topView.alpha == 1){
            [UIView animateWithDuration:0.35 animations:^{
                self.topView.alpha = 0;
            }];
        }
    }
}


-(void)didAddBook
{
    [RDReadHelper addBookshelfWithBookDetail:self.model comlpete:^{
        self.toolbar.addBook.enabled = NO;
    }];
    
}
-(void)didDownload
{
    RDDownloadController *downloadController = [[RDDownloadController alloc] init];
    
    RDBookDetailModel *record = [RDReadRecordManager getReadRecordWithBookId:self.bookId];
    if (!record) {
        record = self.model.yy_modelCopy;
    }
    downloadController.record = record;
    [self pushToController:downloadController];
}
-(void)didBegin
{
    
    [RDReadHelper beginReadWithBookDetail:self.model];
    
}
@end
