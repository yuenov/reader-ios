//
//  RDReadTopBar.m
//  Reader
//
//  Created by yuenov on 2019/11/13.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDReadTopBar.h"
#import "RDLayoutButton.h"
#import "RDReadRecordManager.h"
@interface RDReadTopBar ()
@property (nonatomic,strong) RDLayoutButton *download;
@property (nonatomic,strong) RDLayoutButton *question;
@property(nonatomic, strong) RDLayoutButton *backBtn;
@property (nonatomic,strong) RDLayoutButton *add;
@property (nonatomic,strong) RDLayoutButton *reload;
@end
@implementation RDReadTopBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.download];
        [self addSubview:self.question];
        [self addSubview:self.backBtn];
        [self addSubview:self.add];
        [self addSubview:self.reload];
        [self setBackgroundColor:RDReadBg];
        
    }
    return self;
}

-(void)setRecord:(RDBookDetailModel *)record
{
    _record = record;
    self.add.hidden = self.record.onBookshelf;
}

-(RDLayoutButton *)download
{
    if (!_download) {
        _download = [[RDLayoutButton alloc] init];
        [_download setImage:[UIImage imageNamed:@"book_download_black"] forState:UIControlStateNormal];
        _download.imageSize = CGSizeMake(20, 20);
        [_download addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _download;
}

-(RDLayoutButton *)question
{
    if (!_question) {
        _question = [[RDLayoutButton alloc] init];
        [_question setImage:[UIImage imageNamed:@"book_help"] forState:UIControlStateNormal];
        _question.imageSize = CGSizeMake(20, 20);
        [_question addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _question;
}


-(RDLayoutButton *)add
{
    if (!_add) {
        _add = [[RDLayoutButton alloc] init];
        [_add setImage:[UIImage imageNamed:@"book_add_black"] forState:UIControlStateNormal];
        _add.imageSize = CGSizeMake(22, 22);
        [_add addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _add;
}

- (RDLayoutButton *)backBtn {
    if (!_backBtn) {
        RDLayoutButton *button = [[RDLayoutButton alloc] initWithFrame:CGRectMake(0, [UIView statusBar], 40, [UIView navigationBar])];
        button.adjustsImageWhenDisabled = NO;
        [button setImage:[UIImage imageNamed:@"button_back"] forState:UIControlStateNormal];
        button.imageSize = CGSizeMake(11, 19);
        _backBtn = button;
        [_backBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _backBtn;
}

-(RDLayoutButton *)reload
{
    if (!_reload) {
        _reload = [[RDLayoutButton alloc] init];
        [_reload setImage:[UIImage imageNamed:@"button_reload_thin"] forState:UIControlStateNormal];
        _reload.imageSize = CGSizeMake(20, 20);
        [_reload addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reload;
}
-(void)click:(RDLayoutButton *)sender
{
    if (sender == self.backBtn) {
        if ([self.delegate respondsToSelector:@selector(backAction)]) {
            [self.delegate backAction];
        }
    }
    else if (sender == self.question){
        if ([self.delegate respondsToSelector:@selector(qusetionAction)]) {
            [self.delegate qusetionAction];
        }
    }
    else if (sender == self.download){
        if ([self.delegate respondsToSelector:@selector(downloadAction)]) {
            [self.delegate downloadAction];
        }
    }
    else if (sender == self.add){
        self.add.hidden = YES;
        self.record.onBookshelf = YES;
        [RDReadRecordManager updateBookshelfState:self.record];
        [RDToastView showText:@"已添加到书架" delay:1 inView:[RDUtilities getCurrentVC].view];
    }
    else if (sender == self.reload){
        if ([self.delegate respondsToSelector:@selector(reloadAction)]) {
            [self.delegate reloadAction];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = [UIView navigationBar];
    self.question.frame = CGRectMake(0, [UIView statusBar], height, height);
    self.question.right = self.width;
    self.download.frame = CGRectMake(0, [UIView statusBar], height, height);
    self.download.right = self.question.left;
    self.reload.frame = CGRectMake(0, [UIView statusBar], height, height);
    self.reload.right = self.download.left;
    self.add.frame = CGRectMake(0, [UIView statusBar], height, height);
    self.add.right = self.reload.left;
}
@end
