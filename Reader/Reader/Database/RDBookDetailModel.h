//
//  RDBookDetailModel.h
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDLibraryDetailModel.h"
#import "RDShareModel.h"
@class RDCharpterModel;

@interface RDBookDetailModel : RDModel

@property (nonatomic,assign) NSInteger bookId;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *coverImg;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *word;
@property (nonatomic,strong) NSString *charpter;    //最近更新的章节
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,assign) NSTimeInterval time;   //更新时间
@property (nonatomic,assign) BOOL end;          //是否连载
@property (nonatomic,assign) BOOL updateEnd;    //是否连载
@property (nonatomic,assign) NSInteger updateCharpterId;  //更新的章节
@property (nonatomic,assign) NSInteger total;   //总章节数
@property (nonatomic,strong) NSArray <RDLibraryDetailModel *>*recommend;
@property (nonatomic,strong) RDShareModel *share;


//添加到书架时的阅读进度
@property (nonatomic,assign) BOOL bookUpdate;   //书架上的书是否有更新
@property (nonatomic,strong) RDCharpterModel *charpterModel;  //当前阅读的章节
@property (nonatomic,assign) NSInteger page;        //当前阅读的进度
@property (nonatomic,assign) NSTimeInterval readTime;   //阅读的最后时间
@property (nonatomic,assign) BOOL onBookshelf;      //是否在书架上
@end
