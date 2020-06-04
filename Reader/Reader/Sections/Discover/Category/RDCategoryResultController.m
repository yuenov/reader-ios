//
//  RDCategoryResultController.m
//  Reader
//
//  Created by yuenov on 2020/2/28.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDCategoryResultController.h"
#import "RDLibraryDetailModel.h"
#import "RDCategoryApi.h"
#import "RDBookDetailController.h"
#import "RDCategoryResultCell.h"
#import "RDCategoryResultHeader.h"

@interface RDCategoryResultController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray <RDLibraryDetailModel *>*dataSource;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) RDCategoryFilter filter;
@end

@implementation RDCategoryResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    self.topView.titleLabel.text = self.category;
    self.page = 1;
    self.filter = RDCategoryNewFilter;
     [self fetchData:RDRequestOrigin filter:NO];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RDBackgroudColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = [RDRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFresh)];
        _tableView.rowHeight = 120;
        
    }
    return _tableView;
}

-(NSMutableArray <RDLibraryDetailModel *>*)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)fetchData:(RDRequestState)state filter:(BOOL)filter
{
    RDCategoryApi *api = [[RDCategoryApi alloc] init];
    api.page = self.page;
    api.channelId = self.channelId;
    api.type = self.catagoryId;
    api.filter = self.filter;
    MBProgressHUD *hud;
    if (filter) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else{
        if (state == RDRequestOrigin) {
            [self showLoadingGifWithCancel:^{
                [api stop];
            }];
        }
    }
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (filter) {
            [hud hideAnimated:YES];
        }
        if (state == RDRequestOrigin) {
            [self hideLoadingGif];
        }
        if (!error) {
            self.page++;
            NSArray *list = api.categories;
            if (state == RDRequestMore) {
                 [self.dataSource addObjectsFromArray:list];
            }
            else{
               self.dataSource = list.mutableCopy;
            }
            if (list.count<api.size) {
                self.tableView.mj_footer = nil;
            }
            else{
                self.tableView.mj_footer = [RDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFresh)];
            }
            [self.tableView reloadData];
            if (self.dataSource.count>0 && filter) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        else{
            [RDToastView showText:error delay:kAnimateDelay inView:self.view];
        }
    }];
}

-(void)headerFresh
{
    self.page = 1;
    [self fetchData:RDRequestRefresh filter:NO];
}
-(void)footerFresh{
    [self fetchData:RDRequestMore filter:NO];
}
-(void)filterFresh
{
    self.page = 1;
    [self fetchData:RDRequestOrigin filter:YES];
}
#pragma mark - Delagete
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RDCategoryResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(RDCategoryResultCell.class)];
    if (!cell) {
        cell = [[RDCategoryResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(RDCategoryResultCell.class)];
    }
    cell.model = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RDLibraryDetailModel *model = [self.dataSource objectAtIndex:indexPath.row];
    RDBookDetailController *controller = [[RDBookDetailController alloc] init];
    controller.bookId = [model.bookId integerValue];
    [self pushToController:controller];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RDCategoryResultHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RDCategoryResultHeader"];
    if (!header) {
        header = [[RDCategoryResultHeader alloc] initWithReuseIdentifier:@"RDCategoryResultHeader"];
        header.categoryFilter = self.filter;
        __weak typeof(self) ws = self;
        [header setFilter:^(RDCategoryFilter filter) {
            ws.filter = filter;
            [ws filterFresh];
        }];
    }
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, self.topView.bottom, self.view.width, self.view.height-self.topView.bottom);
}

@end
