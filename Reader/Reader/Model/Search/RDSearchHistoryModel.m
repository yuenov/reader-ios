//
//  RDSearchHistoryModel.m
//  Reader
//
//  Created by yuenov on 2020/2/19.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSearchHistoryModel.h"
#import "RDModelAgent.h"

@interface RDSearchHistoryModel ()
@property (nonatomic,strong) NSMutableArray *words;
@end

@implementation RDSearchHistoryModel
+ (instancetype)getModel
{
    static RDSearchHistoryModel *info = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[RDModelAgent agent] readModelForClass:[self class]];
        if (!info) {
            info = [RDSearchHistoryModel new];
        }

    });
    return info;
}
-(NSArray *)allWords
{
    return self.words;
}

-(NSMutableArray *)words
{
    if (!_words) {
        _words = [NSMutableArray array];
    }
    return _words;
}
-(void)addWords:(NSString *)word
{
    NSInteger index = [_words indexOfObject:word];
    if (index != NSNotFound) {
        [_words removeObjectAtIndex:index];
    }
    if (_words.count >= 10) {
        [self.words removeLastObject];
    }
    [self.words insertObject:word atIndex:0];
}
-(void)removeAllWords
{
    [self.words removeAllObjects];
}
@end
