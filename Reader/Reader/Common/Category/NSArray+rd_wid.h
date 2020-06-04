//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@interface NSArray (rd_wid)
- (id)objectAtIndexSafely:(NSUInteger)index;

- (NSString *)stringWithIndex:(NSUInteger)index;

- (NSNumber *)numberWithIndex:(NSUInteger)index;

- (NSArray *)arrayWithIndex:(NSUInteger)index;

- (NSDictionary *)dictionaryWithIndex:(NSUInteger)index;

- (NSInteger)integerWithIndex:(NSUInteger)index;

- (NSUInteger)unsignedIntegerWithIndex:(NSUInteger)index;

- (BOOL)boolWithIndex:(NSUInteger)index;

- (int16_t)int16WithIndex:(NSUInteger)index;

- (int32_t)int32WithIndex:(NSUInteger)index;

- (int64_t)int64WithIndex:(NSUInteger)index;

- (char)charWithIndex:(NSUInteger)index;

- (short)shortWithIndex:(NSUInteger)index;

- (float)floatWithIndex:(NSUInteger)index;

- (double)doubleWithIndex:(NSUInteger)index;

- (CGPoint)pointWithIndex:(NSUInteger)index;

- (CGSize)sizeWithIndex:(NSUInteger)index;

- (CGRect)rectWithIndex:(NSUInteger)index;
@end
@interface NSMutableArray (wid)

- (void)addObjectSafely:(id)anObject;

- (void)removeObjectSafely:(id)object;

- (void)insertObjectSafely:(id)anObject atIndex:(NSUInteger)index;

- (void)removeObjectSafelyAtIndex:(NSUInteger)index;

- (void)replaceObjectSafelyAtIndex:(NSUInteger)index withObject:(id)anObject;

- (void)exchangeObjectSafelyAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;

- (void)uniqueAddObject:(id)objcet;

- (void)safeAddNilObject;

- (void)addPoint:(CGPoint)point;

- (void)addSize:(CGSize)size;

- (void)addRect:(CGRect)rect;

@end
