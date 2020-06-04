//
//  RDSearchHotCell.m
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchHistoryCell.h"
#define kMaxButtonWidth 160
@interface RDSearchHistoryCell ()
@property (nonatomic,strong) NSMutableArray <UIButton *>*buttons;
@end
@implementation RDSearchHistoryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(void)setWords:(NSArray<NSString *> *)words
{
    if ([words isEqualToArray:_words]) {
        return;
    }
    _words = words;
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];
    for (NSString *word in words) {
        UIButton *button = [self createButtonWithTitle:word];
        [self.buttons addObject:button];
        [self.contentView addSubview:button];
    }
}

-(UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage stretchableImageNamed:@"btn_corner_white"] forState:UIControlStateNormal];
    [button setTitleColor:RDBlackColor forState:UIControlStateNormal];
    button.titleLabel.font = RDFont14;
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat width = [title sizeWithFont:RDFont14 maxWidth:CGFLOAT_MAX].width+24;
    button.size = CGSizeMake(width>kMaxButtonWidth?kMaxButtonWidth:width, 30);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    return button;
}

-(void)click:(UIButton *)sender
{
    if (self.didWord) {
        self.didWord(sender.titleLabel.text);
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat x = 15;
    CGFloat y = 10;
    
    for (NSInteger i=0; i<self.buttons.count; i++) {
        if (x+self.buttons[i].width > self.width-15) {
            x = 15;
            y += 30 + 10;
            
        }
        self.buttons[i].origin = CGPointMake(x, y);
        x = self.buttons[i].right+10;
    }
}

+(CGFloat)cellHeight:(NSArray <NSString *>*)words
{
    CGFloat x = 15;
    CGFloat y = 10;
    
    
    
    for (NSInteger i=0; i<words.count; i++) {
        CGFloat stringWidth = [words[i] sizeWithFont:RDFont14 maxWidth:CGFLOAT_MAX].width+24;
        CGFloat btnWidth = stringWidth>kMaxButtonWidth?kMaxButtonWidth:stringWidth;
        
        if (x+btnWidth > ScreenWidth-15) {
            x = 15;
            y += 30 + 10;
            
        }
        x = x+btnWidth+10;
    }
    return y+30;
}

@end
