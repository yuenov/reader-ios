//
//  RDChannelModel.h
//  Reader
//
//  Created by yuenov on 2020/2/25.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDChannelItem : RDModel
@property (nonatomic,strong) NSString *category;    //分类名称
@property (nonatomic,assign) NSInteger categoryId;
@property (nonatomic,strong) NSString *rank;        //排行榜
@property (nonatomic,assign) NSInteger rankId;
@property (nonatomic,strong) NSArray <NSString *>*coverImgs;    //分类前三个书籍封面
@end
 
@interface RDChannelModel : RDModel
@property (nonatomic,strong) NSString *channel; //大分类
@property (nonatomic,assign) NSInteger channelId;
@property (nonatomic,strong) NSArray <RDChannelItem *>*categories;  //分类
@property (nonatomic,strong) NSArray <RDChannelItem *>*ranks;   //榜单
@end


NS_ASSUME_NONNULL_END
