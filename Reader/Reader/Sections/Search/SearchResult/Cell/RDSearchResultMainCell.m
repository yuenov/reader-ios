//
//  RDSearchResultMainCell.m
//  Reader
//
//  Created by yuenov on 2020/2/20.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchResultMainCell.h"
#import "RDReadPageViewController.h"
#import "RDReadRecordManager.h"

@interface RDSearchResultMainCell ()
@property (nonatomic,strong) UIButton *addBook;
@property (nonatomic,strong) UIButton *begin;
@end

@implementation RDSearchResultMainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.addBook];
        [self.contentView addSubview:self.begin];
    }
    return self;
}

-(void)setBook:(RDBookDetailModel *)book
{
    [super setBook:book];
    RDBookDetailModel *record = [RDReadRecordManager getReadRecordWithBookId:self.book.bookId];;
    self.addBook.enabled = !record.onBookshelf;
}

-(UIButton *)addBook
{
    if (!_addBook) {
        _addBook = [[UIButton alloc] init];
        [_addBook setTitle:@"加书架" forState:UIControlStateNormal];
        [_addBook setTitle:@"已加书架" forState:UIControlStateDisabled];
        [_addBook setTitleColor:RDGreenColor forState:UIControlStateNormal];
        [_addBook setTitleColor:RDLightGrayColor forState:UIControlStateDisabled];
        [_addBook setBackgroundImage:[UIImage stretchableImageNamed:@"btn_square"] forState:UIControlStateNormal];
        _addBook.titleLabel.font = RDBoldFont14;
        [_addBook addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBook;
}

-(UIButton *)begin
{
    if (!_begin) {
        _begin = [[UIButton alloc] init];
        [_begin setTitle:@"开始阅读" forState:UIControlStateNormal];
        [_begin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_begin setBackgroundImage:[UIImage stretchableImageNamed:@"green_btn_1"] forState:UIControlStateNormal];
        _begin.titleLabel.font = RDBoldFont14;
        [_begin addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _begin;
}
-(void)click:(UIButton *)sender
{
    if (sender == self.addBook) {
        [RDReadHelper addBookshelfWithBookDetail:self.book comlpete:^{
            self.addBook.enabled = NO;
        }];
    }
    else if (sender == self.begin){
        [RDReadHelper beginReadWithBookDetail:self.book];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.addBook.frame = CGRectMake(15, self.coverImg.bottom+12, (self.width-30-10)/2, 33);
    self.begin.frame = CGRectMake(self.addBook.right+10, self.addBook.top, self.addBook.width, self.addBook.height);
}

@end
