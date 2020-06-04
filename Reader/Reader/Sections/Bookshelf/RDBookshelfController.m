//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import "RDBookshelfController.h"
#import "RDRefreshHeader.h"
#import "RDBookshelfNoneCell.h"
#import "RDBookshelfSearchCell.h"
#import "RDBookDetailModel.h"
#import "RDReadRecordManager.h"
#import "RDBookshelfCell.h"
#import "RDConfigApi.h"
#import "RDConfigModel.h"
#import "RDCheckApi.h"
#import "RDCacheModel.h"
#import "RDReadHelper.h"
#import "RDCheckApi.h"
#import "RDCharpterApi.h"
#import "RDCharpterDataManager.h"
#import "LEEAlert.h"


#import "RDCharpterModel.h"

#define kItemCount ([RDUtilities iPad] ? 5 : 3)

@interface RDBookshelfController ()
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *bookSource;
@end

@implementation RDBookshelfController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    
    [self requestConfigModel];
    [self checkBookUpdate];
    //如果异常退出是阅读状态，那么直接打开书籍
    RDBookDetailModel *book = [RDCacheModel sharedInstance].book;
    if(book){
         [RDReadHelper beginReadWithBookDetail:book animation:NO];
    }
    
}
//更新配置文件
- (void)requestConfigModel
{
    RDConfigApi *api = [[RDConfigApi alloc] init];
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        if (!error) {
            RDConfigModel *configModel = [api configModel];
            [[RDConfigModel getModel] copyFrom:configModel];
            [[RDConfigModel getModel] archive];
        }
    }];
}

//检查书籍上的书籍是否有更新
-(void)checkBookUpdate
{
    NSArray *array = [RDReadRecordManager getAllOnBookshelfPram];
    if (array.count == 0) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        return;
    }
    RDCheckApi *api = [[RDCheckApi alloc] init];
    api.books = array;
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (!error) {
            NSArray *array =  [api updateBooks];
            for (NSDictionary *dic in array) {
                RDCharpterApi *api = [[RDCharpterApi alloc] init];
                api.bookId = [dic[@"bookId"] integerValue];
                api.chapterId = [dic[@"chapterId"] integerValue];
                [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
                    if (self.tableView.mj_header.isRefreshing) {
                        [self.tableView.mj_header endRefreshing];
                    }
                    if (!error) {
                        NSArray *charpters = [api charpters];
                        [RDReadRecordManager updateOnBookselfUpdateWithBookId:api.bookId update:YES];
                        [self p_reload];
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            [RDCharpterDataManager insertObjectsWithCharpters:charpters];
                        });
                    }
                }];
            }
            
        }
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_reload];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RDBackgroudColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)bookSource
{
    if (!_bookSource) {
        _bookSource = [NSMutableArray array];
    }
    return _bookSource;
}

- (RDTopView *)topView {
    if (!_topView) {
        _topView = [[RDTopView alloc] init];
        _topView.titleLabel.text = @"书架";
        _topView.titleLabel.font = RDBoldFont17;
    }

    return _topView;
}

#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [self.dataSource objectAtIndexSafely:indexPath.row];
    if ([model isKindOfClass:[NSString class]] && [model isEqualToString:@"RDBookshelfSearchCell"]) {
        RDBookshelfSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:model];
        if (!cell) {
            cell = [[RDBookshelfSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model];
        }
        return cell;
    }
    if ([model isKindOfClass:[NSString class]] && [model isEqualToString:@"RDBookshelfNoneCell"]) {
        RDBookshelfNoneCell *cell = [tableView dequeueReusableCellWithIdentifier:model];
        if (!cell) {
            cell = [[RDBookshelfNoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model];
        }
        return cell;
    }
    
    if ([model isKindOfClass:NSArray.class]) {
        RDBookshelfCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RDBookshelfCell"];
        if (!cell) {
            cell = [[RDBookshelfCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RDBookshelfCell"];
            
            __weak typeof(self) weakSelf = self;
            [cell setNeedReload:^{
                [weakSelf p_reload];
            }];
        }
        cell.books = model;
        return cell;
    }
    
    return [UITableViewCell new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [self.dataSource objectAtIndexSafely:indexPath.row];
    if ([model isKindOfClass:[NSString class]] && [model isEqualToString:@"RDBookshelfSearchCell"]){
        return 80;
    }
    if ([model isKindOfClass:[NSString class]] && [model isEqualToString:@"RDBookshelfNoneCell"]){
        return ScreenHeight-80-[UIView navigationBar]-[UIView tarBar]-[UIView statusBar];
    }
    if ([model isKindOfClass:NSArray.class]) {
        return [RDBookshelfCell cellHeight];
    }
    return CGFLOAT_MIN;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
#pragma mark - action

-(void)p_reload
{
    [self.dataSource removeAllObjects];
    [self.bookSource removeAllObjects];
    [self.dataSource addObject:@"RDBookshelfSearchCell"];

    
    
    NSArray *books = [RDReadRecordManager getAllOnBookshelf];
    
    _tableView.mj_header =books.count>0?[RDRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFresh)]:nil;
    
    if (books.count == 0) {
        [self.dataSource addObject:@"RDBookshelfNoneCell"];
    }
    else{
        NSMutableArray *array;
        for (int i=0; i<books.count; i++) {
            if (i%kItemCount == 0) {
                array = [NSMutableArray array];
                [self.bookSource addObject:array];
            }
            [array addObject:books[i]];
        }
        [self.dataSource addObjectsFromArray:self.bookSource];
    }
    
    
    [self.tableView reloadData];
}

-(void)headerFresh
{
    [self checkBookUpdate];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, self.topView.bottom, self.view.width, self.view.height-self.topView.bottom);
}
@end
