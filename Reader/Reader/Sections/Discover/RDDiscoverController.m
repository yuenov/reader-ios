//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import "RDDiscoverController.h"
#import "RDRefreshHeader.h"
#import "RDDiscoverItemModel.h"
#import "RDDiscoverCell.h"
#import "RDDiscoverHeader.h"
#import "RDDiscoverFooter.h"
#import "RDDiscoverCategoryView.h"
#import "RDSearchController.h"
#import "RDDiscoverApi.h"
#import "RDBookDetailController.h"
#import "RDCacheModel.h"

#define kItemCount ([RDUtilities iPad] ? 6 : 4)

@interface RDDiscoverController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *categorySource;
@property (nonatomic,strong) NSMutableArray <RDDiscoverItemModel *>*sectionsSource;
@property (nonatomic,assign) NSInteger page;
@end
@implementation RDDiscoverController
-(void)viewDidLoad{
    [super viewDidLoad];
    NSArray *sections = [RDCacheModel sharedInstance].discovers;
    if (sections.count>0) {
        self.sectionsSource = sections.mutableCopy;
    }
    [self.view addSubview:self.topView];
    [self.view addSubview:self.collectionView];
    [self p_reload];
    [self.collectionView.mj_header beginRefreshing];

}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)categorySource
{
    if (!_categorySource) {
        _categorySource = [NSMutableArray array];
        [_categorySource addObject:@"RDDiscoverCategoryView"];
    }
    return _categorySource;
}
-(NSMutableArray <RDDiscoverItemModel *>*)sectionsSource
{
    if (!_sectionsSource) {
        _sectionsSource = [NSMutableArray array];
    }
    return _sectionsSource;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        int width = (ScreenWidth-(kItemCount+1)*15) / kItemCount;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(width, width*1.3+55);
        layout.minimumInteritemSpacing = 15;// 垂直方向的间距
        layout.minimumLineSpacing = 0; // 水平方向的间距
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.mj_header = [RDRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFresh)];
        [_collectionView registerClass:[RDDiscoverCell class] forCellWithReuseIdentifier:@"RDDiscoverCell"];
         [_collectionView registerClass:[RDDiscoverCategoryView class] forCellWithReuseIdentifier:@"RDDiscoverCategoryView"];
        [_collectionView registerClass:[RDDiscoverHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RDDiscoverHeader"];
        [_collectionView registerClass:[RDDiscoverFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"RDDiscoverFooter"];
        
    }

    return _collectionView;
}

- (RDTopView *)topView {
    if (!_topView) {
        _topView = [[RDTopView alloc] init];
        _topView.titleLabel.text = @"发现";
        _topView.titleLabel.font = RDBoldFont17;
        RDLayoutButton *button = [[RDLayoutButton alloc] init];
        [button setImage:[UIImage imageNamed:@"faxian_search"] forState:UIControlStateNormal];
        [button setImageSize:CGSizeMake(17, 17)];
        [button addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addRightBtn:button];
        button.right = ScreenWidth;
    }

    return _topView;
}

-(void)search:(UIButton *)sender
{
    RDSearchController *controller = [[RDSearchController alloc] init];
    [self pushToController:controller];
}

-(void)headerFresh{
    self.page = 1;
    [self fetch:RDRequestRefresh];
}


-(void)footerFresh
{
    [self fetch:RDRequestMore];
}

-(void)p_reload
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:self.categorySource];
    if (self.sectionsSource.count>0) {
        [self.dataSource addObjectsFromArray:self.sectionsSource];
    }
    [self.collectionView reloadData];
}

-(void)fetch:(RDRequestState)state
{
    [self hiddenError];
    RDDiscoverApi *api = [[RDDiscoverApi alloc] init];
    api.page = self.page;
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (!error) {
            self.page++;
            NSArray *sections = [api list];
            if (state == RDRequestRefresh) {
                self.sectionsSource = sections.mutableCopy;
                [RDCacheModel sharedInstance].discovers = sections;
                [[RDCacheModel sharedInstance] archive];
            }
            else{
                [self.sectionsSource addObjectsFromArray:sections];
            }
            if (sections.count<api.size) {
                self.collectionView.mj_footer = nil;
            }
            else{
                self.collectionView.mj_footer = [RDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFresh)];
            }
            [self p_reload];
        }
        else{
            if (self.sectionsSource.count == 0) {
                //初次请求本地没有数据
                [self showErrorWithString:error inView:self.collectionView frame:CGRectMake(0, 85, self.view.width, self.view.height-85)];
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
    [self.collectionView.mj_header beginRefreshing];
}
#pragma marl - Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id model = self.dataSource[section];
    if (model == self.categorySource) {
        return self.categorySource.count;
    }
    else if ([model isKindOfClass:RDDiscoverItemModel.class]){
        RDDiscoverItemModel *itemModel = model;
        return itemModel.categories.count;
    }
    return 0;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.section];
    if (model == self.categorySource) {
        if ([self.categorySource[indexPath.row] isEqualToString:@"RDDiscoverCategoryView"]) {
            RDDiscoverCategoryView *categoryView = [collectionView dequeueReusableCellWithReuseIdentifier:@"RDDiscoverCategoryView" forIndexPath:indexPath];
            return categoryView;
            
        }
    }
    else if ([model isKindOfClass:RDDiscoverItemModel.class]){
        RDDiscoverItemModel *itemModel = model;
        RDDiscoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RDDiscoverCell" forIndexPath:indexPath];
        RDLibraryDetailModel *item = itemModel.categories[indexPath.row];
        cell.model = item;
        return cell;
    }
    return [UICollectionViewCell new];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
      id model = self.dataSource[indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (model == self.categorySource){
            if ([self.categorySource[indexPath.row] isEqualToString:@"RDDiscoverCategoryView"]){
                return [UICollectionReusableView new];
            }
        }
        else if ([model isKindOfClass:RDDiscoverItemModel.class]){
            RDDiscoverItemModel *itemModel = model;
            RDDiscoverHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RDDiscoverHeader" forIndexPath:indexPath];
            header.category = itemModel.title;
            return header;
        }
        
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        if (model == self.categorySource){
            if ([self.categorySource[indexPath.row] isEqualToString:@"RDDiscoverCategoryView"]){
                return [UICollectionReusableView new];
            }
        }
        else if ([model isKindOfClass:RDDiscoverItemModel.class]){
            RDDiscoverFooter *footer =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"RDDiscoverFooter" forIndexPath:indexPath];
            footer.pageType = RDPageDiscoverType;
            footer.model = model;
            __weak typeof(self) ws = self;
            [footer setNeedReload:^(RDDiscoverItemModel * model) {
                NSInteger index = [ws.sectionsSource indexOfObject:model];
                if (index!=NSNotFound) {
                    [ws p_reload];
                }
            }];
            return footer;
        }
        
    }
    return [UICollectionReusableView new];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    id model = self.dataSource[section];
    if (model == self.categorySource){
        return CGSizeZero;
    }
    return CGSizeMake(self.view.width, 45);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    id model = self.dataSource[section];
    if (model == self.categorySource){
        return CGSizeZero;
    }
    return CGSizeMake(self.view.width, 50);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataSource[indexPath.section];
    if (model == self.categorySource) {
        if ([self.categorySource[indexPath.row] isEqualToString:@"RDDiscoverCategoryView"]) {
            return CGSizeMake(self.view.width, 85);
        }
    }
    else if ([model isKindOfClass:RDDiscoverItemModel.class]){
        int width = (ScreenWidth-(kItemCount+1)*15) / kItemCount;
        return CGSizeMake(width, width*1.3+55);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    id model = self.dataSource[section];
    if (model == self.categorySource) {
        return 0;
    }
    else if ([model isKindOfClass:RDDiscoverItemModel.class]){
        return 15;
    }
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    id model = self.dataSource[indexPath.section];
    if ([model isKindOfClass:RDDiscoverItemModel.class]) {
        RDLibraryDetailModel *item =  ((RDDiscoverItemModel *)model).categories[indexPath.row];
        RDBookDetailController *controller = [[RDBookDetailController alloc] init];
        controller.bookId = [item.bookId integerValue];
        [self pushToController:controller];
    }
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(0, self.topView.bottom, self.view.width, self.view.height-self.topView.bottom);
}
@end
