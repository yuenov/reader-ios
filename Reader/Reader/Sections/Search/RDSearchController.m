//
//  RDSearchController.m
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchController.h"
#import "RDTextField.h"
#import "RDConfigModel.h"
#import "RDLimitInput.h"
#import "RDSearchHistoryModel.h"
#import "RDSearchHotCell.h"
#import "RDSearchHistoryCell.h"
#import "RDSearchHeaderFooterView.h"
#import "RDSearchHotCell.h"
#import "RDSearchResultController.h"
#import "LEEAlert.h"

@interface RDSearchTopView : UIView
@property (nonatomic,strong) RDTextField *textField;
@property (nonatomic,strong) UIButton *cancel;

@end

@implementation RDSearchTopView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, [UIView statusBar] + [UIView navigationBar] + 20);
        [self addSubview:self.textField];
        [self addSubview:self.cancel];
    }
    return self;
}



-(RDTextField *)textField
{
    if (!_textField) {
        _textField = [[RDTextField alloc] init];
        _textField.backgroundColor = [UIColor colorWithHexValue:0xf1f2f5];
        _textField.font = RDFont14;
        _textField.textColor = RDBlackColor;
        NSString *placeholder = [RDConfigModel getModel].hotSearch.firstObject.title?:@"搜索";
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{
                NSFontAttributeName: RDFont14,
                NSForegroundColorAttributeName: RDLightGrayColor
        }];
        _textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_reading_search"]];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.leftViewFrame = CGRectMake(10, (36-15)/2, 15, 15);
        _textField.contentInsets = UIEdgeInsetsMake(0, 30, 0, 14);
        _textField.returnKeyType = UIReturnKeySearch;
        [_textField setValue:@(30) forKey:kLimitInputKey];
    }
    return _textField;
}

-(UIButton *)cancel
{
    if (!_cancel) {
        _cancel = [[UIButton alloc] init];
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_cancel setTitleColor:RDBlackColor forState:UIControlStateNormal];
        _cancel.titleLabel.font = RDFont14;
        [_cancel addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancel;
}

-(void)click
{
    [[RDUtilities getCurrentVC].navigationController popViewControllerAnimated:YES];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textField.frame = CGRectMake(15, 0, self.width-15-60, 36);
    self.textField.bottom = self.height-6;
    self.textField.layer.cornerRadius = 18;
    self.cancel.frame = CGRectMake(self.textField.right, 0, 60, 36);
    self.cancel.centerY = self.textField.centerY;
}
@end

@interface RDSearchController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) RDSearchTopView *searchTopView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray <NSString *>*historySource;
@property (nonatomic,strong) NSMutableArray <RDBookDetailModel *>*hotSource;
@property (nonatomic,strong) NSMutableArray <NSArray *> *dataSource;
@property (nonatomic,strong) RDSearchResultController *resultController;
@end

@implementation RDSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.searchTopView];
    [self.view addSubview:self.tableView];
    [self p_reload];
    [self.searchTopView.textField becomeFirstResponder];
}


-(void)p_showResultController
{
    [self addChildViewController:self.resultController];
    self.resultController.view.frame = self.tableView.frame;
    [self.view addSubview:self.resultController.view];
    [self.resultController didMoveToParentViewController:self.resultController];
}

-(void)p_dismissResultController
{
    [self.resultController removeFromParentViewController];
    [self.resultController.view removeFromSuperview];
}


-(void)p_reload
{
    [self.historySource removeAllObjects];
    [self.hotSource removeAllObjects];
    [self.dataSource removeAllObjects];
    
    self.historySource = [[RDSearchHistoryModel getModel] allWords].mutableCopy;
    
    if (self.historySource.count>0) {
        [self.dataSource addObject:@[@"RDSearchHistoryCell"]];
    }
    self.hotSource = [RDConfigModel getModel].hotSearch.mutableCopy;
    if (self.hotSource.count>0) {
        [self.dataSource addObject:self.hotSource];
    }
    [self.tableView reloadData];
}

-(RDSearchResultController *)resultController
{
    if (!_resultController) {
        _resultController = [[RDSearchResultController alloc] init];
    }
    return _resultController;
}

-(NSMutableArray <NSString *>*)historySource
{
    if (!_historySource) {
        _historySource = [NSMutableArray array];
    }
    return _historySource;
}

-(NSMutableArray <RDBookDetailModel *>*)hotSource
{
    if (!_hotSource) {
        _hotSource = [NSMutableArray array];
    }
    return _hotSource;
}

-(NSMutableArray <NSArray *>*)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(RDSearchTopView *)searchTopView
{
    if (!_searchTopView) {
        _searchTopView = [[RDSearchTopView alloc] init];
        _searchTopView.textField.delegate = self;
    }
    return _searchTopView;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RDBackgroudColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}
#pragma mark - Delegate
#pragma makk -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource[section].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataSource[indexPath.section][indexPath.row];
    if ([model isKindOfClass:NSString.class] && [model isEqualToString:@"RDSearchHistoryCell"]) {
        RDSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RDSearchHistoryCell"];
        if (!cell) {
            cell = [[RDSearchHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RDSearchHistoryCell"];
            __weak typeof(self)  ws = self;
            [cell setDidWord:^(NSString * keyword) {
                [ws p_search:keyword];
            }];
        }
        cell.words = self.historySource;
        return cell;
    }
    if ([model isKindOfClass:RDBookDetailModel.class]) {
        RDSearchHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RDSearchHotCell"];
        if (!cell) {
            cell = [[RDSearchHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RDSearchHotCell"];
        }
        cell.bookDetail = model;
        cell.index = indexPath.row+1;
        return cell;
    }
    
    return [UITableViewCell new];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id model = self.dataSource[section];
    if ([model isEqualToArray:@[@"RDSearchHistoryCell"]]) {
        RDSearchHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RDSearchHistoryHeader"];
        if (!header) {
            header = [[RDSearchHeaderFooterView alloc] initWithReuseIdentifier:@"RDSearchHistoryHeader"];
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:@"清空" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexValue:0xbbbbc8] forState:UIControlStateNormal];
            button.titleLabel.font = RDFont13;
            [button addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
            [header addButton:button];
        }
        header.title = @"搜索历史";
        return header;
    }
    if (model == self.hotSource) {
        RDSearchHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RDSearchHotHeader"];
        if (!header) {
            header = [[RDSearchHeaderFooterView alloc] initWithReuseIdentifier:@"RDSearchHotHeader"];
        }
        header.title = @"热搜书籍";
        return header;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataSource[indexPath.section][indexPath.row];
    if ([model isKindOfClass:NSString.class] && [model isEqualToString:@"RDSearchHistoryCell"])
    {
        return [RDSearchHistoryCell cellHeight:self.historySource];
    }
    if ([model isKindOfClass:RDBookDetailModel.class]) {
        return 80;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //开始编辑
    [self p_dismissResultController];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString *search = nil;
    if (textField.text.length == 0) {
        search = textField.placeholder;
    }
    else{
        search = textField.text;
    }
    [self p_search:search];
    
    return YES;
}

-(void)p_search:(NSString *)keyWord
{
    if (keyWord.length>0) {
        self.searchTopView.textField.text = keyWord;
        [self.searchTopView.textField resignFirstResponder];
        [[RDSearchHistoryModel getModel] addWords:keyWord];
        [[RDSearchHistoryModel getModel] archive];
        [self p_reload];
        [self p_showResultController];
        [self.resultController search:keyWord];
        
    }
}
-(void)clear:(UIButton *)sender
{
    
    [LEEAlert alert].config.LeeAddContent(^(UILabel *label){
        label.text = @"确定要清空吗？";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
    }).LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        
        action.title = @"取消";
        
        action.titleColor = RDGreenColor;
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = ^{
            
        };
    }).LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = @"确定";
        
        action.titleColor = RDGreenColor;
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = ^{
            [[RDSearchHistoryModel getModel] removeAllWords];
            [[RDSearchHistoryModel getModel] archive];
            [self p_reload];
        };
    }).LeeHeaderColor(RDGreenColor).LeeShow();
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, self.searchTopView.bottom, self.view.width, self.view.height-self.searchTopView.bottom);
}
@end
