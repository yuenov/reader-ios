//
//  RDCharpterApi.h
//  Reader
//
//  Created by yuenov on 2019/12/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDCharpterApi : RDBaseApi
@property (nonatomic,assign) NSInteger bookId;
@property (nonatomic,assign) NSInteger chapterId;
-(NSString *)name;
-(NSString *)author;
-(NSArray *)charpters;

@end

NS_ASSUME_NONNULL_END
