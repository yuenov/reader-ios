//
//  RDBaseApi.m
//  Reader
//
//  Created by yuenov on 2019/12/23.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBaseApi.h"
#import "RDGlobalModel.h"
#import "RDModelAgent.h"
#import "RDUserModel.h"
@implementation RDBaseApi

- (void)dealloc {
    NSLog(@"dealloc %@", [NSString stringWithUTF8String:class_getName([self class])]);
}
- (NSString *)baseUrl {
    return [RDGlobalModel sharedInstance].baseUrl;
}



- (BOOL)ignoreCache {
    return YES;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (RDHttpModel *)httpModel {
    if (!_httpModel) {
        NSArray *arr = [[RDModelAgent agent] createModel:[RDHttpModel class] fromJson:self.responseJSONObject];
        _httpModel = [arr objectAtIndexSafely:0];
    }

    return _httpModel;
}
- (BOOL)isSucc {
    RDHttpModel *httpModel = self.httpModel;
    return httpModel && httpModel.code == kSuccHttpCode;
}
- (NSString *)errorMsg {
    RDHttpModel *httpModel = self.httpModel;
    return httpModel.msg.length > 0 ? httpModel.msg : kBaseApiOtherError;
}
- (void)startWithCompletionBlock:(void (^)(RDBaseApi *request, NSString *error))block {
    
    __weak __typeof(self) weakSelf = self;
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (!block) {
            return;
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([strongSelf isSucc]) {
            block(strongSelf, nil);
        }
        else {
            block(strongSelf, [strongSelf errorMsg]);
        }
    }     failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        
        if (!block) {
            return;
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        block(strongSelf, request.error.userInfo[NSLocalizedDescriptionKey] ?: kBaseApiOtherError);
    }];
}
@end
