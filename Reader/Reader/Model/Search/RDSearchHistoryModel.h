//
//  RDSearchHistoryModel.h
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDSearchHistoryModel : RDModel
-(NSArray *)allWords;
-(void)addWords:(NSString *)word;
-(void)removeAllWords;
+ (instancetype)getModel;
@end

NS_ASSUME_NONNULL_END
