//
//  RDRankResultCell.m
//  Reader
//
//  Created by yuenov on 2020/2/27.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDRankResultCell.h"
@interface RDRankResultCell ()
@property (nonatomic,strong) UIImageView *numImageView;
@end
@implementation RDRankResultCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.coverImg addSubview:self.numImageView];
    }
    return self;
}
-(void)setIndex:(NSInteger)index
{
    _index = index;
    self.numImageView.hidden = index>2;
    switch (index) {
        case 0:
            self.numImageView.image = [UIImage imageNamed:@"img_num1"];
            break;
        case 1:
            self.numImageView.image = [UIImage imageNamed:@"img_num2"];
            break;
        case 2:
            self.numImageView.image = [UIImage imageNamed:@"img_num3"];
            break;
        default:
            self.numImageView.image = nil;
            break;
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.numImageView.frame = CGRectMake(0, 0, 19,25);
}

-(UIImageView *)numImageView
{
    if (!_numImageView) {
        _numImageView = [[UIImageView alloc] init];
        
    }
    return _numImageView;
}

@end
