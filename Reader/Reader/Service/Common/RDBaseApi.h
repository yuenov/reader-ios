//
//  RDBaseApi.h
//  Reader
//
//  Created by yuenov on 2019/12/23.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKRequest.h"
#import "RDHttpModel.h"
#import "RDModelAgent.h"
#define kBaseApiOtherError  @"服务器错误，请稍后再试"

#define kSuccHttpCode 0
#define kCreatUserCode 101
NS_ASSUME_NONNULL_BEGIN

@interface RDBaseApi : YTKRequest
@property(nonatomic, strong) RDHttpModel *httpModel;
- (BOOL)isSucc;

- (NSString *)errorMsg;

- (void)startWithCompletionBlock:(void (^)(RDBaseApi *request, NSString *error))block;
@end

NS_ASSUME_NONNULL_END
