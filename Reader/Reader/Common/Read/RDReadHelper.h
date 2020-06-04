//
//  RDReadHelper.h
//  Reader
//
//  Created by yuenov on 2020/2/21.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RDBookDetailModel;

@interface RDReadHelper : NSObject

/// 直接打开书籍
/// @param book 书籍信息
+(void)beginReadWithBookDetail:(RDBookDetailModel *)book;

/// 直接打开书籍
/// @param book 书籍信息
/// @param animation 是否有push动画
+(void)beginReadWithBookDetail:(RDBookDetailModel *)book animation:(BOOL)animation;

/// 跳转到指定章节
/// @param book 书籍信息
/// @param charpterid 章节id
+(void)beginReadWithBookDetail:(RDBookDetailModel *)book charpterId:(NSInteger)charpterid;


/// 将书籍添加到书架
/// @param book 书籍信息
+(void)addBookshelfWithBookDetail:(RDBookDetailModel *)book comlpete:(void(^)(void))complete;

@end

