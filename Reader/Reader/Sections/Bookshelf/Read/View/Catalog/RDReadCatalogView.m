//
//  RDReadCatalogView.m
//  Reader
//
//  Created by yuenov on 2019/11/20.
//  Copyright © 2019 yuenov. All rights reserved.
//


#import "RDReadCatalogView.h"
#import "RDReadCatalogHeader.h"
#import "RDReadCatalogCell.h"
#import "RDReadCatalogView.h"
#import "RDBookDetailModel.h"
#import "RDNotifications.h"

@interface RDReadCatalogView () <UITableViewDelegate,UITableViewDataSource,RDReadCatalogHeaderDelegate,RDReadCatalogCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) RDReadCatalogHeader *header;
@property (nonatomic,strong) UIView *contentView;
@end

@implementation RDReadCatalogView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClicked)];
               [self addGestureRecognizer:tapGesture];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.header];
        [self.contentView addSubview:self.tableView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadSuccess:) name:kDownloadSuccess object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)downloadSuccess:(NSNotification *)no
{
     NSInteger bookId = [no.object integerValue];
    if (bookId == self.book.bookId) {
        [self.tableView reloadData];
    }
}
-(void)setCharpters:(NSArray<RDCharpterModel *> *)charpters
{
    _charpters = charpters.copy;
    [self.tableView reloadData];
}
-(void)setBook:(RDBookDetailModel *)book
{
    _book = book;
    self.header.nameLabel.text = book.title;
    
    NSInteger index = [self.charpters indexOfObject:book.charpterModel];
    if (index!=NSNotFound) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, self.contentView.height-50-50-[UIView safeBottomBar]) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2];
    }
    return _tableView;
}

-(RDReadCatalogHeader *)header
{
    if (!_header) {
        _header = [[RDReadCatalogHeader alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 50)];
        _header.delegate = self;
        _header.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2];
    }
    return _header;
}
-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-[UIView statusBar]-[UIView navigationBar])];
    }
    return _contentView;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RDReadCatalogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RDReadCatalogCell"];
    if (!cell) {
        cell = [[RDReadCatalogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RDReadCatalogCell"];
        cell.delegate = self;
    }
    cell.model = self.charpters[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.charpters.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)aesedecing {
    self.charpters = [[self.charpters reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)descending {
    self.charpters = [[self.charpters reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(void)btnClicked
{
    if (self.clickBg) {
        self.clickBg();
    }
}

-(void)show
{
    UIView *view = [UIApplication sharedApplication].delegate.window;
    self.frame = view.bounds;
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
       [UIView animateWithDuration:.35 animations:^{
           self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
           self.contentView.frame = CGRectMake(0, [UIView statusBar]+[UIView navigationBar], ScreenWidth, self.height-[UIView statusBar]-[UIView navigationBar]);
       }];
}
-(void)dismiss
{
    [UIView animateWithDuration:.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.contentView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, self.height-[UIView statusBar]-[UIView navigationBar]);
    }                completion:^(BOOL finished) {
        if (finished) {
            self.frame = CGRectMake(0, ScreenHeight, self.width, self.height);
        }
    }];
}

#pragma mark - Delegate

-(void)didSelectCharpter:(RDCharpterModel *)charpter
{
    if (self.clickBg) {
        self.clickBg();
    }
    if ([self.delegate respondsToSelector:@selector(didSelectCharpter:)]) {
        [self.delegate didSelectCharpter:charpter];
    }
}

@end
