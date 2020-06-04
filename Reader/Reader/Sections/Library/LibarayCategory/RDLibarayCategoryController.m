//
// Created by yuenov on 2019/10/25.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import "RDLibarayCategoryController.h"
#import "RDRefreshHeader.h"
#import "RDLibraryCategoryCell.h"
#import "RDBookDetailController.h"
#import "RDCategoryApi.h"
#import "RDCacheModel.h"

@interface RDLibarayCategoryController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page;
@end

@implementation RDLibarayCategoryController

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *data = [RDCacheModel sharedInstance].catagories[@(self.categoryModel.type)];
    if ([data isKindOfClass:NSArray.class]) {
        self.dataSource = data.mutableCopy;
    }
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
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
-(void)headerFresh{
    self.page = 1;
    [self fetchData:RDRequestRefresh];
}

-(void)footerFresh{
    [self fetchData:RDRequestMore];
}

-(void)fetchData:(RDRequestState)state{
    RDCategoryApi *api = [[RDCategoryApi alloc] init];
    api.page = self.page;
    api.type = self.categoryModel.type;
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (!error) {
            self.page++;
            NSArray *categories = [api categories];
            if (state == RDRequestRefresh) {
                self.dataSource = categories.mutableCopy;
                [RDCacheModel sharedInstance].catagories[@(self.categoryModel.type)] = self.dataSource.copy;
                [[RDCacheModel sharedInstance] archive];
            }
            else{
                [self.dataSource addObjectsFromArray:categories];
            }
            if (categories.count<api.size) {
                self.tableView.mj_footer = nil;
            }
            else{
                self.tableView.mj_footer = [RDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFresh)];
            }
            [self.tableView reloadData];
        }
        else{
            if (self.dataSource.count == 0) {
                //初次加载没有数据
                [self showErrorWithString:error];
            }
            else{
                 [RDToastView showText:error delay:kAnimateDelay inView:self.view];
            }
           
            
        }
    }];
}

-(void)reloadFetch
{
    [self hiddenError];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Delagete
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RDLibraryCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(RDLibraryCategoryCell.class)];
    if (!cell) {
        cell = [[RDLibraryCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(RDLibraryCategoryCell.class)];
    }
    cell.model = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RDLibraryDetailModel *model = [self.dataSource objectAtIndex:indexPath.row];
    return [RDLibraryCategoryCell categoryCellHeigh:model];
    
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
    _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
}
@end
