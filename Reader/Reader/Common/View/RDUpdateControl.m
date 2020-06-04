//
//  RDUpdateControl.m
//  Reader
//
//  Created by yuenov on 2020/2/21.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDUpdateControl.h"

@interface RDUpdateControl ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) BOOL stop;
@property (nonatomic,strong) CABasicAnimation *rotation;
@end

@implementation RDUpdateControl
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        self.stop = YES;
    }
    return self;
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"book_rolate"]];
        
    }
    return _imageView;
}

-(void)beginAnimation
{
    self.stop = NO;
    [self excuteAnimation];
}
-(void)endAnimation
{
    self.stop = YES;
}
-(void)excuteAnimation
{
    __weak typeof(self) ws = self;
    self.enabled = NO;
    [UIView animateWithDuration:0.75 animations:^{
        ws.imageView.transform = CGAffineTransformRotate(ws.imageView.transform, 2*M_PI_2);
        
    } completion:^(BOOL finished) {
        if (!ws.stop) {
            [ws excuteAnimation];
        }
        else{
            ws.enabled = YES;
        }
    }];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = CGRectMake(0, 0, [self.label.text sizeWithFont:self.label.font maxWidth:CGFLOAT_MAX].width, self.label.font.lineHeight);
    self.imageView.frame = CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
    CGFloat diff =(self.label.width+self.spacing+self.imageView.width)/2;
    self.label.left = self.width/2-diff;
    self.label.centerY = self.height/2;
    self.imageView.left = self.label.right+self.spacing;
    self.imageView.centerY = self.height/2;
}
-(void)dealloc
{
    
}

@end
