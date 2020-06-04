//
//  RDBookshelfCell.m
//  Reader
//
//  Created by yuenov on 2020/2/18.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBookshelfCell.h"
#import "RDBookDetailModel.h"
#import "UIImageView+WebCache.h"
#import "RDReadRecordManager.h"
#import "RDReadPageViewController.h"
#import "RDCharpterManager.h"
#import "LEEAlert.h"
#import "RDBookDetailController.h"
#import "RDCharpterDataManager.h"


#define kItemCount ([RDUtilities iPad] ? 5 : 3)
@interface RDBookshelfCoverView : UIView
@property (nonatomic,strong) UIImageView *cover;
@property (nonatomic,strong) UILabel *bookLabel;
@property (nonatomic,strong) UIImageView *updateTag;

@property (nonatomic,strong) RDBookDetailModel *book;
@end

@implementation RDBookshelfCoverView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cover];
        [self addSubview:self.bookLabel];
        [self.cover addSubview:self.updateTag];
        
    }
    return self;
}

-(void)setBook:(RDBookDetailModel *)book
{
    _book = book;
    [self.cover sd_setImageWithURL:[NSURL URLWithString:[RDUtilities buildPicUrlWithPath:book.coverImg]] placeholderImage:[UIImage imageNamed:@"app_placeholder"]];
    self.updateTag.hidden = !book.bookUpdate;
    self.bookLabel.text = book.title;
}

-(UIImageView *)cover
{
    if(!_cover){
        _cover = [[UIImageView alloc] init];
        _cover.contentMode = UIViewContentModeScaleAspectFill;
        _cover.clipsToBounds = YES;
        _cover.layer.cornerRadius = 3;
    }
    return _cover;
}

-(UIImageView *)updateTag
{
    if (!_updateTag) {
        _updateTag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_update"]];
        _updateTag.hidden = YES;
    }
    return _updateTag;
}

-(UILabel *)bookLabel
{
    if (!_bookLabel) {
        _bookLabel = [[UILabel alloc] init];
        _bookLabel.font = RDBoldFont13;
        _bookLabel.textColor = RDBlackColor;
    }
    return _bookLabel;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.cover.frame = CGRectMake(0, 0, self.width, self.height-45);
    self.updateTag.frame = CGRectMake(0, 0, 28, 15);
    self.updateTag.right = self.cover.width-4;
    self.bookLabel.frame = CGRectMake(0, self.cover.bottom+8, self.width, RDBoldFont13.lineHeight);
}

@end


@interface RDBookshelfCell ()
@property (nonatomic,strong) NSArray <RDBookshelfCoverView *>*items;
@end

@implementation RDBookshelfCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (RDBookshelfCoverView *view in self.items) {
            [self.contentView addSubview:view];
        }
    }
    return self;
}

-(NSArray <RDBookshelfCoverView *>*)items
{
    if (!_items) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<kItemCount; i++) {
            RDBookshelfCoverView *view = [[RDBookshelfCoverView alloc] init];
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
            [view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            [array addObject:view];
        }
        _items = array.copy;
        
    }
    return _items;
}

-(void)tap:(UITapGestureRecognizer *)ges
{
    RDBookshelfCoverView *view = (RDBookshelfCoverView *)ges.view;
    RDBookDetailModel *model = view.book;
    if (model){
        if (model.bookUpdate) {
            [RDReadRecordManager updateOnBookselfUpdateWithBookId:model.bookId update:NO];
            if (self.needReload) {
                self.needReload();
            }
        }
        [RDReadHelper beginReadWithBookDetail:model];
    }
    
}

-(void)longPress:(UILongPressGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
        [LEEAlert actionsheet].config
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeDefault;
            action.title = @"书籍详情";
            action.titleColor = RDBlackColor;
            action.font = RDBoldFont17;
            [action setClickBlock:^{
                RDBookshelfCoverView *view = (RDBookshelfCoverView *)ges.view;
                RDBookDetailModel *model = view.book;
                RDBookDetailController *controller = [[RDBookDetailController alloc] init];
                controller.bookId = model.bookId;
                [[RDUtilities getCurrentVC].navigationController pushViewController:controller animated:YES];
            }];
        }).LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeDestructive;
            action.title = @"删除";
            action.titleColor = [UIColor systemRedColor];
            action.font = RDBoldFont17;
            [action setClickBlock:^{
                RDBookshelfCoverView *view = (RDBookshelfCoverView *)ges.view;
                RDBookDetailModel *model = view.book;
                [RDReadRecordManager removeBookFromBookShelfWithBookId:model.bookId];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [RDCharpterDataManager deleteAllCharpterWithBookId:model.bookId];
                });
                if (self.needReload) {
                    self.needReload();
                }
            }];
        }).LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            action.title = @"取消";
            action.titleColor = RDBlackColor;
            action.font = RDBoldFont17;
        })
        .LeeActionSheetCancelActionSpaceColor([UIColor colorWithHexValue:0xf9f9f9]) // 设置取消按钮间隔的颜色
        .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
        .LeeCornerRadii(CornerRadiiMake(7, 7, 0, 0))   // 指定整体圆角半径
        .LeeActionSheetHeaderCornerRadii(CornerRadiiZero()) // 指定头部圆角半径
        .LeeActionSheetCancelActionCornerRadii(CornerRadiiZero()) // 指定取消按钮圆角半径
        .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
            return ScreenWidth;
        })
        .LeeActionSheetBackgroundColor([UIColor whiteColor]) // 通过设置背景颜色来填充底部间隙
        .LeeShow();
        
        
    }
    

}

-(void)setBooks:(NSArray<RDBookDetailModel *> *)books
{
    _books = books;
    for (int i=0; i<books.count; i++) {
        self.items[i].book = books[i];
        self.items[i].hidden = NO;
    }
    if (self.items.count>books.count) {
        for (NSInteger i=self.items.count-1; i>self.books.count-1; i--) {
            self.items[i].hidden = YES;
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat space = 30;
    CGFloat width = (self.width-space*(kItemCount+1))/kItemCount;
    for (int i=0; i<self.items.count; i++) {
        self.items[i].frame = CGRectMake(space+(width+space)*i, 0, width, self.height);
    }
}


+(CGFloat )cellHeight
{
    CGFloat itemWidth = (ScreenWidth-30*(kItemCount+1))/kItemCount;
    return itemWidth*1.32+45;
}

@end
