//
//  RDChapterManager.m
//  Reader
//
//  Created by yuenov on 2019/12/29.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDCharpterManager.h"
#import "RDCharpterModel.h"
#import "RDCharpterDataManager.h"
#import "RDCharpterApi.h"
#import "RDCharpterContentApi.h"


@implementation RDCharpterManager


+(void)getCharpterWithBookId:(NSInteger)bookId complete:(void(^)(BOOL success,RDCharpterModel *model))complete
{
    BOOL isExist = [RDCharpterDataManager isExsitWithBookId:bookId];
    if (isExist) {
        NSInteger charpterId = [RDCharpterDataManager getFirstCharpterIdWirhBookId:bookId];
         [self getCharpterWithBookId:bookId charpterId:charpterId complete:complete];
    }
    else{
        [self getCharpterWithBookId:bookId charpterId:-1 complete:complete];
    }
}

+(void)getCharpterWithBookId:(NSInteger)bookId charpterId:(NSInteger)charpterId complete:(void(^)(BOOL success,RDCharpterModel *model))complete
{
    BOOL isExist = [RDCharpterDataManager isExsitWithBookId:bookId charpterId:charpterId];
    __block NSInteger charpterId_block = charpterId;
    if (!isExist) {
        //不存在章节信息
        RDCharpterApi *api = [[RDCharpterApi alloc] init];
        api.bookId = bookId;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
            if (!error) {
                NSArray *charpters = api.charpters;
                [RDCharpterDataManager insertObjectsWithCharpters:charpters];
                if (charpterId_block == -1) {
                    //取第一章
                    RDCharpterModel *model = charpters.firstObject;
                    charpterId_block = model.charpterId;
                }
                RDCharpterContentApi *contentApi = [[RDCharpterContentApi alloc] init];
                contentApi.charpters = @[@(charpterId_block)];
                contentApi.bookId = bookId;
                [contentApi startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
                    if (!error) {
                        [hud hideAnimated:NO];
                        RDCharpterModel *model = contentApi.charptersContent.firstObject;
                        if (model.content.length == 0) {
                            [RDToastView showText:@"内容不存在" delay:1 inView:[UIApplication sharedApplication].keyWindow];
                            return;
                        }
                        [RDCharpterDataManager insertObjectsWithCharpters:contentApi.charptersContent];
                        if (complete) {
                            complete(YES,model);
                        }
                    }
                    else{
                        hud.mode = MBProgressHUDModeText;
                        hud.detailsLabel.text = error;
                        [hud hideAnimated:YES afterDelay:kAnimateDelay];
                        if (complete) {
                            complete(NO,nil);
                        }
                    }
                }];
            }
            else{
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabel.text = error;
                [hud hideAnimated:YES afterDelay:kAnimateDelay];
                if (complete) {
                    complete(NO,nil);
                }
            }
        }];
    }
    else{
        RDCharpterModel *charpter = [RDCharpterDataManager getCharpterWithBookId:bookId charpterId:charpterId_block];
        if (charpter.content.length==0) {
            RDCharpterContentApi *contentApi = [[RDCharpterContentApi alloc] init];
            contentApi.charpters = @[@(charpterId_block)];
            contentApi.bookId = bookId;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            [contentApi startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
                if (!error) {
                    [hud hideAnimated:NO];
                    RDCharpterModel *model = contentApi.charptersContent.firstObject;
                    if (model.content.length == 0) {
                        [RDToastView showText:@"内容不存在" delay:1 inView:[UIApplication sharedApplication].keyWindow];
                        return;
                    }
                    [RDCharpterDataManager insertObjectsWithCharpters:contentApi.charptersContent];
                    if (complete) {
                        complete(YES,model);
                    }
                    
                }
                else{
                    hud.mode = MBProgressHUDModeText;
                    hud.detailsLabel.text = error;
                    [hud hideAnimated:YES afterDelay:kAnimateDelay];
                    if (complete) {
                        complete(NO,nil);
                    }
                }
            }];
        }
        else{
            if (complete) {
                complete(YES,charpter);
            }
        }
    }
}

+(void)slientDownWithBookId:(NSInteger)bookId charpterIds:(NSArray *)charpters
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //判断章节是否存在，如果存在不下载
        NSMutableArray *downloads = [NSMutableArray array];
        for (NSNumber *charpter in charpters) {
            RDCharpterModel *model = [RDCharpterDataManager getCharpterWithBookId:bookId charpterId:charpter.integerValue];
            if (model.content.length==0) {
                [downloads addObject:charpter];
            }
        }
        if (downloads.count == 0) {
            return ;
        }
        RDCharpterContentApi *contentApi = [[RDCharpterContentApi alloc] init];
        contentApi.charpters = downloads;
        contentApi.bookId = bookId;
        [contentApi startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
            if (!error) {
                [RDCharpterDataManager insertObjectsWithCharpters:contentApi.charptersContent];
            }
        }];
    });
    
}
+(void)getAllNoConetntCharpterWithBookId:(NSInteger)bookId complete:(void(^)(NSArray <RDCharpterModel *>*charpters))complete
{
    BOOL isExist = [RDCharpterDataManager isExsitWithBookId:bookId];
    if (!isExist) {
        RDCharpterApi *api = [[RDCharpterApi alloc] init];
        api.bookId = bookId;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
            if (!error) {
                [hud hideAnimated:YES];
                NSArray *charpters = api.charpters;
                [RDCharpterDataManager insertObjectsWithCharpters:charpters];
                if (complete) {
                    complete(charpters);
                }
            }
            else{
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabel.text = error;
                [hud hideAnimated:YES afterDelay:kAnimateDelay];
            }
        }];
    }
    else{
        NSArray *charpters = [RDCharpterDataManager getAllNoContentCharpterWithBookId:bookId];
        if (complete) {
            complete(charpters);
        }
    }
}
@end
