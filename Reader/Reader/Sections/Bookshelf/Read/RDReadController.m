//
//  RDReadController.m
//  Reader
//
//  Created by yuenov on 2019/11/13.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDReadController.h"
#import "RDMenuView.h"
#import "RDReadParser.h"
#import "RDBatteryView.h"
#import <CoreText/CoreText.h>
#import "RDReadConfigManager.h"

@interface RDReadView : UIView
@property (nonatomic,strong) NSAttributedString *attributeString;
@end

@implementation RDReadView

-(void)setAttributeString:(NSAttributedString *)attributeString
{
    _attributeString = attributeString;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) self.attributeString);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
//    if (self.mirror) {
//        CGContextTranslateCTM(ctx, self.bounds.size.width,0);
//        CGContextScaleCTM(ctx, -1.0, 1.0);
//    }
    CGPathRef pathRef = CGPathCreateWithRect(self.bounds, NULL);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), pathRef, NULL);
    CTFrameDraw(frameRef, ctx);
    
    CFRelease(frameRef);
    CGPathRelease(pathRef);
    CFRelease(frameSetter);
}

@end


@interface RDReadProxy : NSProxy
@property (nonatomic, weak) id obj;
@end

@implementation RDReadProxy
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig;
    sig = [self.obj methodSignatureForSelector:aSelector];
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.obj];
}
@end

@interface RDReadController ()
@property (nonatomic,strong) UILabel *charpterLabel;
@property (nonatomic,strong) RDReadView *readView;
@property (nonatomic,strong) RDBatteryView *battery;
@property (nonatomic,strong) UILabel *progressLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UIImageView *coverBackgroundImageVIew;


@property (nonatomic, strong) RDReadProxy *proxy;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL is12Hour;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger charpterIndex;

@property (nonatomic,strong) NSAttributedString *content;
@property (nonatomic,strong) NSString *charpter;
@property (nonatomic,assign) NSInteger totalPage;
@property (nonatomic,assign) NSInteger totalCharpter;
@end

@implementation RDReadController
- (instancetype)init {
    self = [super init];
    if (self){
        self.proxy = [RDReadProxy alloc];
        self.proxy.obj = self;
        self.is12Hour = [self is12HourFormat];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeBatteryLevel:) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.proxy selector:@selector(setTimer) userInfo:nil repeats:YES];

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.charpterLabel];
    [self.backgroundImageView addSubview:self.battery];
    [self.backgroundImageView addSubview:self.progressLabel];
    [self.backgroundImageView addSubview:self.timeLabel];
    [self.backgroundImageView addSubview:self.readView];
    [self.backgroundImageView addSubview:self.coverBackgroundImageVIew];
    //主题背景
    [self.KVOController observe:[RDReadConfigManager sharedInstance] keyPath:@"theme" options:NSKeyValueObservingOptionNew block:^(RDReadController *  _Nullable observer, RDReadConfigManager *  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        observer.backgroundImageView.image = object.background;
        observer.coverBackgroundImageVIew.image = object.background;
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:observer.content];
        [attributeString addAttribute:NSForegroundColorAttributeName value:object.fontColor range:NSMakeRange(0, attributeString.length)];
        observer.readView.attributeString = attributeString;
        observer.content = attributeString.copy;
        observer.battery.batteryColor = object.toolColor;
        observer.timeLabel.textColor = object.toolColor;
        observer.progressLabel.textColor = object.toolColor;
        observer.charpterLabel.textColor = [RDReadConfigManager sharedInstance].samllCharpterColor;
        
        NSMutableAttributedString *charpterContent = [[NSMutableAttributedString alloc] initWithAttributedString:observer.charpterContent];
        [charpterContent addAttribute:NSForegroundColorAttributeName value:object.fontColor range:NSMakeRange(0, charpterContent.length)];
        observer.charpterContent = charpterContent.copy;
        
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    
    RDPageType pageType = [RDReadConfigManager sharedInstance].pageType;
    if (pageType == RDNoneTypePage) {
        UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.view addGestureRecognizer:ges];
    }
    
}
//无效果时左右滑动翻页
-(void)pan:(UIPanGestureRecognizer *)ges
{
    //有效滑动距离
    CGFloat distance = 10.f;
    CGPoint translation = [ges translationInView:self.view];
    if (ges.state == UIGestureRecognizerStateEnded) {
        if (translation.x>0 && translation.x>distance) {
            //像右滑动
            if ([self.delegate respondsToSelector:@selector(lastPage:)]) {
                [self.delegate lastPage:self];
            }
        }
        else if (fabs(translation.x)>distance){
            //向左滑动
            if ([self.delegate respondsToSelector:@selector(nextPage:)]) {
                [self.delegate nextPage:self];
            }
        }
    }
}



-(void)tap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.view];
    CGFloat width = self.view.width/3;
    if(point.x<width){
        if ([self.delegate respondsToSelector:@selector(lastPage:)]) {
            [self.delegate lastPage:self];
        }
    }
    else if (point.x>2*width){
        if ([self.delegate respondsToSelector:@selector(nextPage:)]) {
            [self.delegate nextPage:self];
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(invokeMenu:)]) {
            [self.delegate invokeMenu:self];
        }
    }
}

-(void)setCharpter:(NSString *)charpter content:(NSAttributedString *)content page:(NSInteger)page totalPage:(NSInteger)totalPage charpterIndex:(NSInteger)chaprterIndex totalCharpter:(NSInteger)totalCharpter
{
    _charpter = charpter;_content = content;_page = page; _totalPage = totalPage; _charpterIndex = chaprterIndex;totalCharpter = _totalCharpter = totalCharpter;
    self.charpterLabel.text = self.charpter;
    self.readView.attributeString = content;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    CGFloat lastCharpterPercent = chaprterIndex/(CGFloat)totalCharpter;
    
    CGFloat charpterPercent = (chaprterIndex+1)/(CGFloat)totalCharpter;
    
    CGFloat pagePercent = (page+1)/(CGFloat)totalPage;
    
    CGFloat percent = (lastCharpterPercent+(charpterPercent-lastCharpterPercent)*pagePercent)*100;
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.1f%%",percent];
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.charpterLabel.frame = CGRectMake(20, [UIView safeTopBar], self.view.width-40,40 );
    self.battery.frame = CGRectMake(20, 0, self.battery.size.width, self.battery.size.height);
    self.timeLabel.frame = CGRectMake(self.battery.right+6, 0, 80, 40);
    self.timeLabel.bottom = self.view.height-[UIView safeBottomBar];
    self.battery.centerY = self.timeLabel.centerY;
    self.progressLabel.frame = CGRectMake(0, self.timeLabel.top, 80, 40);
    self.progressLabel.right = self.view.width-20;
    self.readView.frame = CGRectMake(20, self.charpterLabel.bottom, self.view.width-40, self.timeLabel.top-self.charpterLabel.bottom);
    self.backgroundImageView.frame = self.view.bounds;
    self.coverBackgroundImageVIew.frame = self.view.bounds;
    if (self.isMirror) {
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformScale(transform, -1, 1);
        self.backgroundImageView.transform = transform;
        self.coverBackgroundImageVIew.alpha = 0.9;
    }
}

- (UILabel *)charpterLabel {
    if (!_charpterLabel){
        _charpterLabel = [[UILabel alloc] init];
        _charpterLabel.textColor = [RDReadConfigManager sharedInstance].samllCharpterColor;
        _charpterLabel.font = RDFont14;
        
    }
    return _charpterLabel;
}

- (RDBatteryView *)battery {
    if (!_battery){
        _battery = [[RDBatteryView alloc] initWithFrame:CGRectMake(0, 0, 22, 11)];
        _battery.batteryColor = [RDReadConfigManager sharedInstance].toolColor;
        [self setBatteryLevel];

    }
    return _battery;
}

- (UILabel *)progressLabel {
    if (!_progressLabel){
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.textColor = [RDReadConfigManager sharedInstance].toolColor;
        _progressLabel.font = RDFont12;
        _progressLabel.textAlignment = NSTextAlignmentRight;
    }
    return _progressLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [RDReadConfigManager sharedInstance].toolColor;
        _timeLabel.font = RDFont12;
        [self setTimer];
    }
    return _timeLabel;
}

-(RDReadView *)readView
{
    if (!_readView) {
        _readView = [[RDReadView alloc] init];
        _readView.backgroundColor = [UIColor clearColor];
    }
    return _readView;
}

-(UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[RDReadConfigManager sharedInstance].background];
    }
    return _backgroundImageView;
}
-(UIImageView *)coverBackgroundImageVIew
{
    if (!_coverBackgroundImageVIew) {
        _coverBackgroundImageVIew = [[UIImageView alloc] initWithImage:[RDReadConfigManager sharedInstance].background];
        _coverBackgroundImageVIew.alpha = 0;
    }
    return _coverBackgroundImageVIew;
}

-(void)setTimer
{
    if (_is12Hour){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.AMSymbol = @"上午";
        dateFormatter.PMSymbol = @"下午";
        [dateFormatter setDateFormat:@"aaah:mm"];
        [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
        NSString *str = [dateFormatter stringFromDate:[NSDate date]];
        self.timeLabel.text = str;
    } else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"H:mm"];
        [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
        NSString *str = [dateFormatter stringFromDate:[NSDate date]];
        self.timeLabel.text = str;
    }

}
- (BOOL)is12HourFormat{
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA =[formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM =containsA.location != NSNotFound;
    return hasAMPM;
}
-(void)setBatteryLevel{
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    [self.battery setBatteryValue:(int)(device.batteryLevel*100)];

}
-(void)didChangeBatteryLevel:(NSNotification *)notification{
    [self setBatteryLevel];
}
-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
