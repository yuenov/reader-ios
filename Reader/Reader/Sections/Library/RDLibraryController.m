//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import "RDLibraryController.h"
#import "RDLibarayCategoryController.h"
#import "RDConfigModel.h"
#import "RDSearchController.h"
#import "RDCategoryController.h"

@interface RDLibraryController ()
@property (nonatomic, strong) RDLayoutButton *categoryButton;
@property (nonatomic, strong) RDLayoutButton *searchButton;
@property (nonatomic, strong) NSArray <RDCategoryModel *>*categorySource;
@end
@implementation RDLibraryController

-(instancetype)init {
    self = [super init];
    if (self){
        self.menuViewStyle = WMMenuViewStyleDefault;
        self.titleSizeNormal = 15.f;
        self.titleSizeSelected = 18.f;
        self.itemMargin = 2;
        self.automaticallyCalculatesItemWidths = YES;
        self.titleColorNormal = RDLightGrayColor;
        self.titleColorSelected = RDGreenColor;
        self.menuView.backgroundColor = [UIColor colorWithHexValue:0xffffff];
        self.menuView.delegate = self;
        self.categorySource = [RDConfigModel getModel].categories;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    self.menuView.leftView = self.categoryButton;
    self.menuView.rightView = self.searchButton;
    self.progressViewIsNaughty = YES;
}

-(RDLayoutButton *)categoryButton {
    if (!_categoryButton){
        _categoryButton = [[RDLayoutButton alloc] init];
        [_categoryButton setImage:[UIImage imageNamed:@"library_fenlei"] forState:UIControlStateNormal];
        [_categoryButton setImageSize:CGSizeMake(17, 17)];
        [_categoryButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _categoryButton.frame = CGRectMake(0, 0, 37, 37);
        _categoryButton.centerY = [UIView navigationBar]/2;

    }
    return _categoryButton;
}

-(RDLayoutButton *)searchButton {
    if (!_searchButton){
        _searchButton = [[RDLayoutButton alloc] init];
        [_searchButton setImage:[UIImage imageNamed:@"library_search"] forState:UIControlStateNormal];
        [_searchButton setImageSize:CGSizeMake(17, 17)];
        [_searchButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _searchButton.frame = CGRectMake(0, 0, 37, 37);
        _searchButton.centerY = [UIView navigationBar]/2;
    }
    return _searchButton;
}

-(void)click:(UIButton *)sender{
    if (sender == self.categoryButton){
        RDCategoryController *controller = [[RDCategoryController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (sender == self.searchButton){
        RDSearchController *controller = [[RDSearchController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - WMPageControllerDataSource

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.categorySource.count;
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    RDLibarayCategoryController *categoryController = [[RDLibarayCategoryController alloc] init];
    categoryController.categoryModel = self.categorySource[index];
    return categoryController;
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return [self.categorySource objectAtIndex:index].name;
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, [UIView statusBar], ScreenWidth,[UIView navigationBar]);
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, [UIView statusBar] + [UIView navigationBar], ScreenWidth, self.view.height - [UIView statusBar] - [UIView navigationBar]);
}

#pragma mark - Menu Delegate
- (void)menuView:(WMMenuView *)menu didLayoutItemFrame:(WMMenuItem *)menuItem atIndex:(NSInteger)index
{
    menuItem.font = RDBoldFont18;
}
@end
