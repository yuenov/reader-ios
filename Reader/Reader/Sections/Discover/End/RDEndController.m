//
//  RDOtherCategoryController.m
//  Reader
//
//  Created by yuenov on 2020/2/26.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDEndController.h"
#import "RDEndApi.h"
#import "RDDiscoverCell.h"
#import "RDDiscoverHeader.h"
#import "RDDiscoverFooter.h"
#import "RDBookDetailController.h"

#define kItemCount ([RDUtilities iPad] ? 6 : 4)

@interface RDEndController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray <RDDiscoverItemModel *>*sectionsSource;
@property (nonatomic,assign) NSInteger page;
@end

@implementation RDEndController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.collectionView];
    self.topView.titleLabel.text = @"完本";
    self.page = 1;
    [self fetch:RDRequestOrigin];
   
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
        [_collectionView registerClass:[RDDiscoverHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RDDiscoverHeader"];
        [_collectionView registerClass:[RDDiscoverFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"RDDiscoverFooter"];
        
    }

    return _collectionView;
}

-(void)headerFresh{
    self.page = 1;
    [self fetch:RDRequestRefresh];
}


-(void)footerFresh
{
    [self fetch:RDRequestMore];
}

-(void)fetch:(RDRequestState)state
{
    RDEndApi *api = [[RDEndApi alloc] init];
    api.page = self.page;
    if (state == RDRequestOrigin) {
        [self showLoadingGifWithCancel:^{
            [api stop];
        }];
    }
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (state == RDRequestOrigin) {
            [self hideLoadingGif];
        }
        if (!error) {
            self.page++;
            NSArray *sections = [api list];
            if (state == RDRequestMore) {
                [self.sectionsSource addObjectsFromArray:sections];
            }
            else{
                self.sectionsSource = sections.mutableCopy;
                
            }
            if (sections.count<api.size) {
                self.collectionView.mj_footer = nil;
            }
            else{
                self.collectionView.mj_footer = [RDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFresh)];
            }
            [self.collectionView reloadData];
        }
        else{
            if (state == RDRequestOrigin) {
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
    [self fetch:RDRequestOrigin];
}


#pragma marl - Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sectionsSource[section].categories.count;

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionsSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RDLibraryDetailModel *itemModel = self.sectionsSource[indexPath.section].categories[indexPath.row];
    RDDiscoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RDDiscoverCell" forIndexPath:indexPath];
    RDLibraryDetailModel *item = itemModel;
    cell.model = item;
    return cell;

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        RDDiscoverItemModel *itemModel = self.sectionsSource[indexPath.section];
        RDDiscoverHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RDDiscoverHeader" forIndexPath:indexPath];
        header.category = itemModel.title;
        return header;

    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        RDDiscoverItemModel *itemModel = self.sectionsSource[indexPath.section];
        RDDiscoverFooter *footer =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"RDDiscoverFooter" forIndexPath:indexPath];
        footer.model = itemModel;
        footer.pageType = RDPageEndType;
        __weak typeof(self) ws = self;
        [footer setNeedReload:^(RDDiscoverItemModel * model) {
            NSInteger index = [ws.sectionsSource indexOfObject:model];
            if (index!=NSNotFound) {
                [ws.collectionView reloadData];
            }
        }];
        return footer;

    }
    return [UICollectionReusableView new];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.width, 45);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
   return CGSizeMake(self.view.width, 50);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int width = (ScreenWidth-(kItemCount+1)*15) / kItemCount;
    return CGSizeMake(width, width*1.3+55);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    RDLibraryDetailModel *model = self.sectionsSource[indexPath.section].categories[indexPath.row];
    RDBookDetailController *controller = [[RDBookDetailController alloc] init];
    controller.bookId = [model.bookId integerValue];
    [self pushToController:controller];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(0, self.topView.bottom, self.view.width, self.view.height-self.topView.bottom);
}

@end
