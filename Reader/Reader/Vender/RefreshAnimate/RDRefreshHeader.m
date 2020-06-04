//
//  RDRefreshHeader.m
//  Reader
//
//  Created by yuenov on 2019/10/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDRefreshHeader.h"
#import "KafkaReplicatorLayer.h"

const CGFloat kRefreshCommHeaderHeight = 44;//下拉刷新需要停留的高度

@interface RDRefreshHeader ()
@property (nonatomic,strong) KafkaReplicatorLayer *replicator;
@end
@implementation RDRefreshHeader

- (void)prepare {
    [super prepare];
    self.mj_h = kRefreshCommHeaderHeight;
    [self.layer addSublayer:self.replicator];
}
- (void)placeSubviews {
    [super placeSubviews];
    self.replicator.frame = CGRectMake(0, 0, self.width, self.height);
}
-(KafkaReplicatorLayer *)replicator
{
    if (!_replicator) {
        _replicator = [KafkaReplicatorLayer layer];
        _replicator.animationStyle = KafkaReplicatorLayerAnimationStyleAllen;
        _replicator.themeColor = RDGreenColor;
    }
    return _replicator;
}
#pragma mark 监听scrollView的contentOffset改变

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

-(void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            [self.replicator stopAnimating];
            break;
        case MJRefreshStatePulling:
            [self.replicator stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            [self.replicator startAnimating];
            break;
        default:
            break;
    }
    
}

@end
