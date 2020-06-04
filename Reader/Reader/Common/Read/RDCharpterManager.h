//
//  RDChapterManager.h
//  Reader
//
//  Created by yuenov on 2019/12/29.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RDCharpterModel;

@interface RDCharpterManager : NSObject

/// 从第一章开始阅读返回第一章
/// @param bookId
/// @param complete
+(void)getCharpterWithBookId:(NSInteger)bookId complete:(void(^)(BOOL success,RDCharpterModel *model))complete;

/// 从某一章节开始阅读
/// @param bookId
/// @param charpterId 阅读的章节
/// @param complete 
+(void)getCharpterWithBookId:(NSInteger)bookId charpterId:(NSInteger)charpterId complete:(void(^)(BOOL success,RDCharpterModel *model))complete;
+(void)slientDownWithBookId:(NSInteger)bookId charpterIds:(NSArray *)charpters;


/// 获取所有没有内容的章节信息
/// @param bookId <#bookId description#>
/// @param complete <#complete description#>
+(void)getAllNoConetntCharpterWithBookId:(NSInteger)bookId complete:(void(^)(NSArray <RDCharpterModel *>*charpters))complete;

@end
