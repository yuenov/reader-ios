//
//  RDDownloadController.m
//  Reader
//
//  Created by yuenov on 2020/2/9.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDDownloadController.h"
#import "RDDownloadCell.h"
#import "RDCharpterManager.h"
#import "RDBookDetailModel.h"
#import "RDCharpterModel.h"
#import "RDCharpterContentApi.h"
#import "RDCharpterDataManager.h"
#import "RDNotifications.h"
#import "RDToastView.h"

@interface RDDownloadController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *headerLabel;
@property (nonatomic,strong) NSArray *charpters;
@end

@implementation RDDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    [RDCharpterManager getAllNoConetntCharpterWithBookId:self.record.bookId complete:^(NSArray<RDCharpterModel *> *charpters) {
        self.charpters = charpters;
        [self.view addSubview:self.tableView];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadSuccess:) name:kDownloadSuccess object:nil];
    self.topView.titleLabel.text = @"选择下载的章节";
    
}
-(void)downloadSuccess:(NSNotification *)no
{
    NSInteger bookId = [no.object integerValue];
    if (bookId == self.record.bookId) {
        MBProgressHUD *hud =[MBProgressHUD HUDForView:self.view];
        if (hud) {
            [hud hideAnimated:NO];
            [RDToastView showText:@"下载完成" delay:kAnimateDelay inView:self.view];
        }
    }
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RDBackgroudColor;
        _tableView.tableHeaderView = self.headerLabel;
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

-(UILabel *)headerLabel
{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
        _headerLabel.textColor = RDLightGrayColor;
        _headerLabel.font = RDFont13;
        _headerLabel.text = @"跳过已下载的章节，已下载的不计数";
        _headerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headerLabel;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RDDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RDDownloadCell"];
    if (!cell) {
        cell = [[RDDownloadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RDDownloadCell"];
    }
    cell.index = indexPath.row;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    NSMutableArray *downloadCharpter = [NSMutableArray array];
    

    int beginIndex = -1;
    for (int i=0; i<self.charpters.count; i++) {
        RDCharpterModel *model = self.charpters[i];
        if (!self.record.charpterModel) {
            beginIndex = 0;
            break;
        }
        else{
            if (model.charpterId > self.record.charpterModel.charpterId) {
                beginIndex=i;
                break;
            }
        }
        
    }
    
    if (beginIndex == -1) {
        [RDToastView showText:@"没有更多了" delay:kAnimateDelay inView:self.view];
        return;
        
    }
    switch (indexPath.row) {
        case 0:{
            for (int i=beginIndex; i<self.charpters.count; i++) {
                if (i-beginIndex<50) {
                    [downloadCharpter addObject:self.charpters[i]];
                }
            }
        }
            break;
        case 1:{
            for (int i=beginIndex; i<self.charpters.count; i++) {
                if (i-beginIndex<100) {
                    [downloadCharpter addObject:self.charpters[i]];
                }
            }
        }
            break;
        case 2:{
            for (int i=beginIndex; i<self.charpters.count; i++) {
                if (i-beginIndex<200) {
                    [downloadCharpter addObject:self.charpters[i]];
                }
            }

        }
            break;
        case 3:{
            [downloadCharpter addObjectsFromArray:self.charpters];
        }
            break;
        default:
            break;
    }
    if (downloadCharpter.count>0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在下载...";
        RDCharpterContentApi *api = [[RDCharpterContentApi alloc] init];
        api.bookId = self.record.bookId;
        api.charpters = [downloadCharpter valueForKey:@"charpterId"];
        [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
            [hud hideAnimated:NO];
            if (!error) {
                NSArray *array = api.charptersContent;
                [RDCharpterDataManager insertObjectsWithCharpters:array];
                [RDToastView showText:@"成功下载1章" delay:1 inView:self.view];
                
            }
            else{
                [RDToastView showText:error delay:kAnimateDelay inView:self.view];
            }
        }];
       
    }
    else{
        [RDToastView showText:@"下载完成" delay:kAnimateDelay inView:self.view];
    }
    
}


-(void)click
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, self.topView.bottom, self.view.width, self.view.height);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
