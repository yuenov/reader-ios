//
//  RDBookToolBar.m
//  Reader
//
//  Created by yuenov on 2019/11/5.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBookToolBar.h"
#import "RDLayoutButton.h"
@interface RDBookToolBar ()
@property (nonatomic,strong) UIView *bg;


@end
@implementation RDBookToolBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        [self addSubview:self.bg];
        [self addSubview:self.download];
        [self addSubview:self.addBook];
        [self addSubview:self.begin];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-[UIView safeBottomBar]);
        make.top.mas_equalTo(5);
    }];
    [self.begin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(55);
        make.centerX.equalTo(self);
    }];
    [self.download mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bg);
        make.left.equalTo(self);
        make.height.equalTo(self.bg);
        make.right.equalTo(self.begin.mas_left);
    }];
    [self.addBook mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bg);
        make.left.equalTo(self.begin.mas_right);
        make.height.equalTo(self.bg);
        make.right.equalTo(self);
    }];
}

-(RDLayoutButton *)download
{
    if (!_download) {
        _download = [[RDLayoutButton alloc] init];
        [_download setImage:[UIImage imageNamed:@"book_download"] forState:UIControlStateNormal];
        [_download setTitle:@"下载" forState:UIControlStateNormal];
        [_download setTitleColor:RDGreenColor forState:UIControlStateNormal];
        _download.imageAndTitleInset = 5;
        _download.imageSize = CGSizeMake(20, 20);
        _download.titleLabel.font = RDFont14;
        [_download addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _download;
}
-(RDLayoutButton *)addBook
{
    if (!_addBook) {
        _addBook = [[RDLayoutButton alloc] init];
        [_addBook setImage:[UIImage imageNamed:@"book_add"] forState:UIControlStateNormal];
        [_addBook setTitle:@"加书架" forState:UIControlStateNormal];
        [_addBook setTitleColor:RDGreenColor forState:UIControlStateNormal];
        
        [_addBook setImage:[UIImage imageNamed:@"book_exist"] forState:UIControlStateDisabled];
        [_addBook setTitle:@"在书架" forState:UIControlStateDisabled];
        [_addBook setTitleColor:[UIColor colorWithHexValue:0x5D646E] forState:UIControlStateDisabled];
    
        
        _addBook.imageAndTitleInset = 5;
        _addBook.imageSize = CGSizeMake(20, 20);
        _addBook.titleLabel.font = RDFont14;
         [_addBook addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBook;
}

-(RDLayoutButton *)begin
{
    if (!_begin) {
        _begin = [[RDLayoutButton alloc] init];
        [_begin setTitle:@"开始阅读" forState:UIControlStateNormal];
        [_begin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _begin.titleLabel.font = RDBoldFont18;
        [_begin setBackgroundColor:RDGreenColor];
        _begin.layer.cornerRadius = 55.0/2;
        _begin.clipsToBounds = YES;
        [_begin addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _begin;
}


-(void)click:(RDLayoutButton *)sender
{
    if (sender == self.download) {
        if ([self.delegate respondsToSelector:@selector(didDownload)]) {
            [self.delegate didDownload];
        }
    }
    else if (sender == self.begin){
        if ([self.delegate respondsToSelector:@selector(didBegin)]){
            [self.delegate didBegin];
        }
    }
    else if (sender == self.addBook){
        if ([self.delegate respondsToSelector:@selector(didAddBook)]){
            [self.delegate didAddBook];
        }
    }
}

-(UIView *)bg
{
    if (!_bg) {
        _bg = [[UIView alloc] init];
        _bg.backgroundColor = [UIColor whiteColor];
    }
    return _bg;
}

@end
