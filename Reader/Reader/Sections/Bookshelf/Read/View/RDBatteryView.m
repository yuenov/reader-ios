//
//  RDBatteryView.m
//  Reader
//
//  Created by yuenov on 2019/12/15.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBatteryView.h"
@interface RDBatteryView ()
///电池宽度
@property (nonatomic,assign) CGFloat b_width;
///电池高度
@property (nonatomic,assign) CGFloat b_height;
///电池外线宽
@property (nonatomic,assign) CGFloat b_lineW;
@property (nonatomic,strong) UIView *batteryView;
@property (nonatomic,assign) CGFloat value;

@property (nonatomic,strong) CAShapeLayer *batteryLayer;

@property (nonatomic,strong) CAShapeLayer *layerRight;

@end
@implementation RDBatteryView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _batteryView = [[UIView alloc] init];
        [self addSubview:self.batteryView];
        ///x坐标
        CGFloat b_x = 1;
        ///y坐标
        CGFloat b_y = 1;
        _b_height = self.bounds.size.height - 2;
        _b_width = self.bounds.size.width - 5;
        _b_lineW = 1;
        
        //画电池【左边电池】
        UIBezierPath *pathLeft = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(b_x, b_y, _b_width, _b_height) cornerRadius:2];
        _batteryLayer = [CAShapeLayer layer];
        _batteryLayer.lineWidth = _b_lineW;
        _batteryLayer.fillColor = [UIColor clearColor].CGColor;
        _batteryLayer.path = [pathLeft CGPath];
        [self.layer addSublayer:_batteryLayer];
        
        //画电池【右边电池箭头】
        UIBezierPath *pathRight = [UIBezierPath bezierPath];
        [pathRight moveToPoint:CGPointMake(b_x + _b_width+1, b_y + _b_height/3)];
        [pathRight addLineToPoint:CGPointMake(b_x + _b_width+1, b_y + _b_height * 2/3)];
        _layerRight = [CAShapeLayer layer];
        _layerRight.lineWidth = 2;
        _layerRight.fillColor = [UIColor clearColor].CGColor;
        _layerRight.path = [pathRight CGPath];
        [self.layer addSublayer:_layerRight];
        
        ///电池内填充
        _batteryView.frame = CGRectMake(b_x + 1.5,b_y + _b_lineW+0.5, 0, _b_height - (_b_lineW+0.5) * 2);
        _batteryView.layer.cornerRadius = 1;
        
    }
    return self;
}

-(void)setBatteryColor:(UIColor *)batteryColor
{
    _batteryColor = batteryColor;
    _batteryView.backgroundColor = batteryColor;
    _layerRight.strokeColor = batteryColor.CGColor;
    _batteryLayer.strokeColor = batteryColor.CGColor;
    [self setBatteryValue:self.value];
}

- (void)setBatteryValue:(NSInteger)value{
    _value = value;
    if (value<=0) {
        return;
    }
    _batteryView.backgroundColor = self.batteryColor;
    CGRect rect = _batteryView.frame;
    rect.size.width = (value*(_b_width - (_b_lineW+0.5) * 2))/100;
    _batteryView.frame  = rect;
}
@end

