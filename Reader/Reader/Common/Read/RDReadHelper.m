//
//  RDReadHelper.m
//  Reader
//
//  Created by yuenov on 2020/2/21.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDReadHelper.h"
#import "RDBookDetailModel.h"
#import "RDReadPageViewController.h"
#import "RDReadRecordManager.h"
#import "RDCharpterManager.h"
#import "AppDelegate.h"
#import "RDMainController.h"

@implementation RDReadHelper
/// 直接打开书籍
/// @param book 书籍信息
+(void)beginReadWithBookDetail:(RDBookDetailModel *)book
{
    [self beginReadWithBookDetail:book animation:YES];
}

+(void)beginReadWithBookDetail:(RDBookDetailModel *)book animation:(BOOL)animation
{
    RDBookDetailModel *record = [RDReadRecordManager getReadRecordWithBookId:book.bookId];
       RDReadPageViewController *controller = [[RDReadPageViewController alloc] init];
       if (record.charpterModel) {
           //存在阅读记录
           controller.bookDetail = record;
           [RDReadRecordManager updateReadTime:record];
           [RDAppDelegate.mainController.navigationController pushViewController:controller animated:animation];
       }
       else{
           [RDCharpterManager getCharpterWithBookId:book.bookId complete:^(BOOL success,RDCharpterModel * _Nonnull model) {
               if (success) {
                   RDBookDetailModel *detail  = [book yy_modelCopy];
                   //可能没有下载数据直接加入了书架
                   detail.onBookshelf = record.onBookshelf;
                   detail.charpterModel = model;
                   [RDReadRecordManager insertOrReplaceModel:detail];
                   controller.bookDetail = detail;
                   [RDAppDelegate.mainController.navigationController pushViewController:controller animated:animation];
               }
               
           }];
       }
}

/// 跳转到指定章节
/// @param book 书籍信息
/// @param charpterid 章节id
+(void)beginReadWithBookDetail:(RDBookDetailModel *)book charpterId:(NSInteger)charpterid
{
    [RDCharpterManager getCharpterWithBookId:book.bookId charpterId:charpterid complete:^(BOOL success, RDCharpterModel *model) {
        if (success) {
            RDReadPageViewController *controller = [[RDReadPageViewController alloc] init];
            RDBookDetailModel *detail = [book yy_modelCopy];
            detail.charpterModel = model;
            [RDReadRecordManager insertOrReplaceModel:detail];
            controller.bookDetail = detail;
            [[RDUtilities getCurrentVC].navigationController pushViewController:controller animated:YES];
        }
    }];
}


/// 将书籍添加到书架
/// @param book 书籍信息
+(void)addBookshelfWithBookDetail:(RDBookDetailModel *)book comlpete:(void(^)(void))complete
{
    RDBookDetailModel *record = [RDReadRecordManager getReadRecordWithBookId:book.bookId];
    if (record) {
        record.onBookshelf = YES;
        [RDReadRecordManager updateBookshelfState:record];
        if (complete) {
            complete();
        }
    }
    else{
        RDBookDetailModel *detail = [book yy_modelCopy];
        detail.onBookshelf = YES;
        [RDReadRecordManager insertOrReplaceModel:detail];
        if (complete) {
            complete();
        }
        
    }
    
    
}
@end
