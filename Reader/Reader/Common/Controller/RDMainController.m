//
//  RDMainController.m
//  Reader
//
//  Created by yuenov on 2019/10/23.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDMainController.h"
#import "UIView+rd_dispalyInfo.h"
#import "RDBookshelfController.h"
#import "RDDiscoverController.h"
#import "RDLibraryController.h"
#import "RDVTabBarItem.h"
#import "UIColor+rd_wid.h"
#import "NSArray+rd_wid.h"
#import "UIView+rd_wid.h"
#import "UINavigationController+FDFullscreenPopGesture.h"



@interface RDMainController ()

@end

@implementation RDMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBarHidden = YES;
    if (@available(iOS 11.0, *)) {
        CGFloat safeAreaBottom = UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;
         self.tabBar.contentEdgeInsets = UIEdgeInsetsMake(0, 0,  safeAreaBottom / 1.5f, 0);
    }
    self.delegate = self;
    self.fd_prefersNavigationBarHidden = YES;
   [self initSetup];

}

-(void)initSetup{
    self.viewControllers = @[({
        RDBookshelfController *bookshelfController = [[RDBookshelfController alloc] init];
        bookshelfController;
    }),({
        RDDiscoverController *discoverController = [[RDDiscoverController alloc] init];
        discoverController;
    }),({
        RDLibraryController *libraryController = [[RDLibraryController alloc] init];
        libraryController;
    })];

    NSArray *normalIcons = @[@"tabbar_unselect",@"tabbar_faxian_unselect",@"tabbar_shucheng_unselect",@"tabbar_wo_unselect"];
    NSArray *selectedIcons = @[@"tabbar_select",@"tabbar_faxian_select",@"tabbar_shucheng_select",@"tabbar_wo_select"];
    NSArray *titleArray = @[@"书架",@"发现", @"书城", @"我"];
    for (int i = 0; i < self.tabBar.items.count; ++i) {
        RDVTabBarItem *item = self.tabBar.items[i];
        item.backgroundColor = [UIColor colorWithHexValue:0xf9f9f9];
        item.title = [titleArray objectAtIndexSafely:i];
        item.titlePositionAdjustment = UIOffsetMake(0, 4);
        NSDictionary *tabBarTitleUnselectedDic = @{NSForegroundColorAttributeName: [UIColor colorWithHexValue:0xc5c5c7], NSFontAttributeName: [UIFont systemFontOfSize:11]};
        NSDictionary *tabBarTitleSelectedDic = @{NSForegroundColorAttributeName: [UIColor colorWithHexValue:0x23b383], NSFontAttributeName: [UIFont systemFontOfSize:11]};
        item.selectedTitleAttributes = tabBarTitleSelectedDic;
        item.unselectedTitleAttributes = tabBarTitleUnselectedDic;
        [item setFinishedSelectedImage:[UIImage imageNamed:selectedIcons[i]] withFinishedUnselectedImage:[UIImage imageNamed:normalIcons[i]]];
        [item removeTarget:self.tabBar action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [item addTarget:self.tabBar action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    //添加分割线
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, -1 / [UIScreen mainScreen].scale, self.tabBar.width, 1 / [UIScreen mainScreen].scale)];
    separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    separatorView.backgroundColor = [UIColor colorWithHexValue:0xcdcdce];
    [self.tabBar addSubview:separatorView];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
