//
//  RDModel.h
//  Reader
//
//  Created by yuenov on 2019/10/26.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RDModel : NSObject <NSCopying, NSCoding>
- (BOOL)archive;

- (BOOL)archiveToFileWithName:(NSString *)fileName;

- (BOOL)deleteToFileWithName:(NSString *)fileName;

- (void)copyFrom:(RDModel *)other;

- (void)copyFrom:(RDModel *)other blackList:(NSArray *)list;


// other无值不覆盖
- (void)updateFrom:(RDModel *)other blackList:(NSArray *)list;

- (int)transformStr:(NSString *)str
       defaultValue:(int)defaultValue
           fromDict:(NSDictionary *)dict;

- (NSString *)reverseTransform:(int)number
                  defaultValue:(NSString *)defaultValue
                      fromDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
