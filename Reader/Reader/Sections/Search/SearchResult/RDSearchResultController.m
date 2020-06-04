//
//  RDSearchResultController.m
//  Reader
//
//  Created by yuenov on 2020/2/20.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchResultController.h"
#import "RDSearchResultMainCell.h"
#import "RDConfigModel.h"
#import "RDBookDetailController.h"
#import "RDSearchApi.h"
#import "RDSearchBottomView.h"


@interface RDSearchResultController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSString *word;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) RDSearchBottomView *bottomView;
@end

@implementation RDSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
}

-(void)fetchData:(RDRequestState)state
{
    RDSearchApi *api = [[RDSearchApi alloc] init];
    api.page = self.page;
    api.word = self.word;
    if (state == RDRequestOrigin) {
        [self showLoadingGifWithCancel:^{
            [api stop];
        }];
    }
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        if (state == RDRequestOrigin) {
            [self hideLoadingGif];
        }
        if (!error) {
            self.page++;
            NSArray *list = api.list;
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
            if (self.dataSource.count>0 && state == RDRequestOrigin) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
        }
        else
        {
            [RDToastView showText:error delay:kAnimateDelay inView:self.view];
        }
    }];
}

-(void)search:(NSString *)word
{
    _word = word;
    self.page = 1;
    [self fetchData:RDRequestOrigin];
}

-(void)footerFresh{
    [self fetchData:RDRequestMore];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

-(RDSearchBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[RDSearchBottomView alloc] init];
        [_bottomView.feedback addTarget:self action:@selector(feedback) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(void)feedback
{
    [RDToastView showText:@"该功能不可使用" delay:1.5 inView:self.view];
}

#pragma mark - UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        RDSearchResultMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RDSearchResultMainCell"];
        if (!cell) {
            cell = [[RDSearchResultMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RDSearchResultMainCell"];
        }
        cell.book = self.dataSource[indexPath.row];
        cell.word = self.word;
        return cell;
    }
    
    else{
        RDSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RDSearchResultCell"];
        if (!cell) {
            cell = [[RDSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RDSearchResultCell"];
        }
        cell.book = self.dataSource[indexPath.row];
        cell.word = self.word;
        return cell;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 190;
    }
    return 140;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RDBookDetailModel *model = self.dataSource[indexPath.row];
    RDBookDetailController *controller = [[RDBookDetailController alloc] init];
    controller.bookId = model.bookId;
    [[RDUtilities getCurrentVC].navigationController pushViewController:controller animated:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.bottomView.frame = CGRectMake(0, 0, self.view.width, 40+[UIView safeBottomBar]);
    self.bottomView.bottom = self.view.height;
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height-self.bottomView.height);
}

@end
