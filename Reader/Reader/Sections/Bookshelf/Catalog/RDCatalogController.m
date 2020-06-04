//
//  RDCategoryController.m
//  Reader
//
//  Created by yuenov on 2019/12/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDCatalogController.h"
#import "RDReadCatalogHeader.h"
#import "RDCharpterApi.h"
#import "RDCharpterModel.h"
#import "RDReadCatalogCell.h"
#import "RDReadPageViewController.h"
#import "RDCharpterDataManager.h"
#import "RDNotifications.h"
@interface RDCatalogController () <UITableViewDelegate,UITableViewDataSource,RDReadCatalogHeaderDelegate,RDReadCatalogCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) RDReadCatalogHeader *header;
@property (nonatomic,strong) NSArray <RDCharpterModel *>*dataSource;
@end

@implementation RDCatalogController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.header];
    [self.view addSubview:self.tableView];
    self.topView.titleLabel.text = self.model.title;
    self.header.nameLabel.text = self.model.updateEnd?[NSString stringWithFormat:@"已完结 共%ld章",self.model.total]:[NSString stringWithFormat:@"连载中 共%ld章",self.model.total];
    [self fetch];
}
-(void)fetch{
    
    self.dataSource = [RDCharpterDataManager getBriefCharptersWithBookId:self.model.bookId];
    [self.tableView reloadData];
    RDCharpterApi *api = [[RDCharpterApi alloc] init];
    api.bookId = self.model.bookId;
    api.chapterId = self.dataSource.lastObject.charpterId;
    if (self.dataSource.count == 0) {
        [self showLoadingGifWithCancel:^{
            [api stop];
        }];
    }
    
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        if (self.dataSource.count == 0) {
            [self hideLoadingGif];
        }
        if (!error) {
            NSArray *charpters = [api charpters];
            if (self.dataSource.count == 0) {
                self.dataSource = charpters;
                [self.tableView reloadData];
            }
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [RDCharpterDataManager insertObjectsWithCharpters:charpters];
            });
            
        }
        else{
            if (self.dataSource.count==0) {
                [RDToastView showText:error delay:kAnimateDelay inView:self.view];
            }
        }
    }];
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
-(RDReadCatalogHeader *)header
{
    if (!_header) {
        _header = [[RDReadCatalogHeader alloc] init];
        _header.delegate = self;
        _header.backgroundColor = [UIColor whiteColor];
        _header.nameLabel.font = RDFont15;
    }
    return _header;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RDReadCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RDReadCatalogCell"];
    if (!cell) {
        cell = [[RDReadCatalogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RDReadCatalogCell"];
        cell.delegate = self;
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (void)didSelectCharpter:(RDCharpterModel *)charpter
{
    [RDReadHelper beginReadWithBookDetail:self.model charpterId:charpter.charpterId];
}

- (void)aesedecing {
    self.dataSource = [[self.dataSource reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
}

- (void)descending {
    self.dataSource = [[self.dataSource reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, self.topView.bottom, self.view.width,50);
    self.tableView.frame = CGRectMake(0, self.header.bottom, self.view.width, self.view.height-self.header.bottom);
}
@end
