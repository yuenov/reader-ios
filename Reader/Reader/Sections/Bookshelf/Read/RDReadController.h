//
//  RDReadController.h
//  Reader
//
//  Created by yuenov on 2019/11/13.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RDCharpterModel;
@class RDReadController;
NS_ASSUME_NONNULL_BEGIN

@protocol RDReadControllerDelegate <NSObject>

-(void)lastPage:(RDReadController *)controller;

-(void)nextPage:(RDReadController *)controller;

-(void)invokeMenu:(RDReadController *)controller;

@end

@interface RDReadController : RDBaseViewController

@property (nonatomic,assign,getter=isMirror) BOOL mirror;   //是否是镜像，仿真翻页使用该参数

@property (nonatomic,assign,readonly) NSInteger page;   //当前阅读的页数
@property (nonatomic,assign,readonly) NSInteger charpterIndex; //当前阅读章节的索引

@property (nonatomic,strong,readonly) NSAttributedString *content;  //内容
@property (nonatomic,strong,readonly) NSString *charpter;       //章节
@property (nonatomic,assign,readonly) NSInteger totalPage;      //总页数
@property (nonatomic,assign,readonly) NSInteger totalCharpter;  //总章节

@property (nonatomic,strong) RDCharpterModel *charpterModel;    //当前阅读的章节
@property (nonatomic,strong) NSAttributedString *charpterContent;   //当前章节的所有内容包括标题
@property (nonatomic,strong) NSArray *pages;        //分页信息

@property (nonatomic,weak) id<RDReadControllerDelegate> delegate;
/// 设置内容显示
/// @param charpter 章节
/// @param content 内容
/// @param page 当前页数
/// @param totalPage 章节总页数
/// @param chaprterIndex 当前章节数
/// @param totalCharpter 总章节数
-(void)setCharpter:(NSString *)charpter content:(NSAttributedString *)content page:(NSInteger)page totalPage:(NSInteger)totalPage charpterIndex:(NSInteger)chaprterIndex totalCharpter:(NSInteger)totalCharpter;


@end

NS_ASSUME_NONNULL_END
