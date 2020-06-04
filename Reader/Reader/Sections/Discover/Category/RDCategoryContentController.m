//
//  RDCategoryContentController.m
//  Reader
//
//  Created by yuenov on 2020/2/25.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDCategoryContentController.h"
#import "RDCategoryCollectionCell.h"
#import "RDCategoryResultController.h"

@interface RDCategoryContentController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation RDCategoryContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        int width = (ScreenWidth-45) / 2;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(width, width/2);
        layout.minimumInteritemSpacing = 15;//水平方向的间距
        layout.minimumLineSpacing = 15; // 垂直方向的间距
        layout.sectionInset = UIEdgeInsetsMake(20,15,20,15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[RDCategoryCollectionCell class] forCellWithReuseIdentifier:@"RDCategoryCollectionCell"];
        
    }

    return _collectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.categories.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RDChannelItem *item = self.model.categories[indexPath.row];
    RDCategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RDCategoryCollectionCell" forIndexPath:indexPath];
    cell.item = item;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    RDChannelItem *item = self.model.categories[indexPath.row];
    RDCategoryResultController *controller = [[RDCategoryResultController alloc] init];
    controller.category = item.category;
    controller.catagoryId = item.categoryId;
    controller.channelId = self.model.channelId;
    [self pushToController:controller];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

@end
