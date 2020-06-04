//
//  RDRankResultController.m
//  Reader
//
//  Created by yuenov on 2020/2/27.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDRankResultController.h"
#import "RDChannelModel.h"
#import "RDRankContentApi.h"
#import "RDRankResultCell.h"
#import "RDBookDetailController.h"
@interface RDRankResultController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray <RDLibraryDetailModel *>*dataSource;
@property (nonatomic,assign) NSInteger page;
@end

@implementation RDRankResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    self.topView.titleLabel.text = self.rank;
    self.page = 1;
    [self fetchData:RDRequestOrigin];
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

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)fetchData:(RDRequestState)state
{
    RDRankContentApi *api = [[RDRankContentApi alloc] init];
    api.page = self.page;
    api.channelId = self.channelId;
    api.rankId = self.rankId;
    if (state == RDRequestOrigin) {
        [self showLoadingGifWithCancel:^{
            [api stop];
        }];
    }
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (state == RDRequestOrigin) {
            [self hideLoadingGif];
        }
        if (!error) {
            self.page++;
            NSArray *list = api.list;
            if (state == RDRequestRefresh) {
                self.dataSource = list.mutableCopy;
            }
            else{
                [self.dataSource addObjectsFromArray:list];
            }
            if (list.count<api.size) {
                self.tableView.mj_footer = nil;
            }
            else{
                self.tableView.mj_footer = [RDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFresh)];
            }
            [self.tableView reloadData];
        }
        else{
            [RDToastView showText:error delay:kAnimateDelay inView:self.view];
        }
    }];
}

-(void)headerFresh
{
    self.page = 1;
    [self fetchData:RDRequestRefresh];
}
-(void)footerFresh{
    [self fetchData:RDRequestMore];
}
#pragma mark - Delagete
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RDRankResultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(RDRankResultCell.class)];
    if (!cell) {
        cell = [[RDRankResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(RDRankResultCell.class)];
    }
    cell.index = indexPath.row;
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

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, self.topView.bottom, self.view.width, self.view.height-self.topView.bottom);
}

@end
