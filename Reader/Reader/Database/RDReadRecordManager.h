//
//  RDReadRecordManager.h
//  Reader
//
//  Created by yuenov on 2020/1/31.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDBookDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface RDReadRecordManager : NSObject

+(void)insertOrReplaceModel:(RDBookDetailModel *)model;

+(RDBookDetailModel *)getReadRecordWithBookId:(NSInteger)bookid;


+(void)updateReadTime:(RDBookDetailModel *)model;

+(void)updateBookshelfState:(RDBookDetailModel *)model;

+(void)removeBookFromBookShelfWithBookId:(NSInteger)bookid;

/// 获取所有书架上的书籍
+(NSArray *)getAllOnBookshelf;

/// 获取所有书架上的书籍的相关参数
+(NSArray *)getAllOnBookshelfPram;

/// 书架上的书籍是否有更新的章节
/// @param bookid
/// @param update 是否有更新的章节
+(void)updateOnBookselfUpdateWithBookId:(NSInteger)bookid update:(BOOL)update;

@end

NS_ASSUME_NONNULL_END
