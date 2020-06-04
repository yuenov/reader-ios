//
//  RDCharpterDataManager.h
//  Reader
//
//  Created by yuenov on 2019/12/29.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RDCharpterModel;
NS_ASSUME_NONNULL_BEGIN

@interface RDCharpterDataManager : NSObject

/// 不包含章节内容的章节信息
+(NSArray *)getBriefCharptersWithBookId:(NSInteger)bookid;

+(BOOL)isExsitWithBookId:(NSInteger)bookid;

+(BOOL)isExsitWithBookId:(NSInteger)bookid charpterId:(NSInteger)charpterId;

/// 获取章节信息
/// @param bookId bookid
/// @param charpterId charpterid
+(RDCharpterModel *)getCharpterWithBookId:(NSInteger)bookId charpterId:(NSInteger)charpterId;

/// 获取书籍的第一章Id
/// @param bookId 书籍Id
+(NSInteger)getFirstCharpterIdWirhBookId:(NSInteger)bookId;

+(void)insertObjectsWithCharpters:(NSArray *)charpters;


/// 获取书籍的最后一章
/// @param bookId <#bookId description#>
+(RDCharpterModel *)getLastChapterWithBookId:(NSInteger)bookId;


/// 获取所有没有内容的章节
/// @param bookid 书籍Id
+(NSArray *)getAllNoContentCharpterWithBookId:(NSInteger)bookid;


/// 删除本地记录书籍
/// @param bookid
+(void)deleteAllCharpterWithBookId:(NSInteger)bookid;
@end

NS_ASSUME_NONNULL_END
