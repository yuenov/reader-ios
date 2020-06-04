//
//  RDRankContentController.m
//  Reader
//
//  Created by yuenov on 2020/2/26.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDRankContentController.h"
#import "RDRankCell.h"
#import "RDRankResultController.h"
@interface RDRankContentController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation RDRankContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RDBackgroudColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 105;
        _tableView.showsVerticalScrollIndicator = NO;
        
    }
    return _tableView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RDRankResultController *controller = [[RDRankResultController alloc] init];
    controller.rank = self.model.ranks[indexPath.row].rank;
    controller.rankId = self.model.ranks[indexPath.row].rankId;
    controller.channelId = self.model.channelId;
    [self pushToController:controller];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.ranks.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RDRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RDRankCell"];
    if (!cell) {
        cell = [[RDRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RDRankCell"];
    }
    cell.item = self.model.ranks[indexPath.row];
    return cell;
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

@end
