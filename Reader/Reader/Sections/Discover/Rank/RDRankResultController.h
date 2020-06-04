//
//  RDRankResultController.h
//  Reader
//
//  Created by yuenov on 2020/2/27.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDBaseViewController.h"
@class RDChannelModel;
NS_ASSUME_NONNULL_BEGIN

@interface RDRankResultController : RDBaseViewController
@property (nonatomic,strong) NSString *rank;    //排行名称
@property (nonatomic,assign) NSInteger channelId;   //频道id
@property (nonatomic,assign) NSInteger rankId;  //排行id
@end

NS_ASSUME_NONNULL_END
