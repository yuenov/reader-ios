//
// Created by yuenov on 2019/10/24.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSArray+rd_wid.h"


@implementation NSArray (rd_wid)

- (id)objectAtIndexSafely:(NSUInteger)index
{
    if (index < self.count) {
        return self[index];
    } else {
        return nil;
    }
}

- (NSString *)stringWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];
    if (value == nil || value == [NSNull null]) {
        return @"";
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *) value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }

    return nil;
}

- (NSNumber *)numberWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *) value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString *) value];
    }
    return nil;
}

- (NSArray *)arrayWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)dictionaryWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSInteger)integerWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (NSUInteger)unsignedIntegerWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value unsignedIntegerValue];
    }
    return 0;
}

- (BOOL)boolWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];

    if (value == nil || value == [NSNull null]) {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    return NO;
}

- (int16_t)int16WithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];

    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (int32_t)int32WithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];

    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (int64_t)int64WithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];

    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value longLongValue];
    }
    return 0;
}

- (char)charWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];

    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value charValue];
    }
    return 0;
}

- (short)shortWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];

    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (float)floatWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];

    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    }
    return 0;
}

- (double)doubleWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];

    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value doubleValue];
    }
    return 0;
}

- (CGPoint)pointWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];

    CGPoint point = CGPointFromString(value);

    return point;
}

- (CGSize)sizeWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];

    CGSize size = CGSizeFromString(value);

    return size;
}

- (CGRect)rectWithIndex:(NSUInteger)index
{
    id value = [self objectAtIndexSafely:index];

    CGRect rect = CGRectFromString(value);

    return rect;
}

@end
@implementation NSMutableArray (wid)

- (void)addObjectSafely:(id)anObject
{
    if (anObject != nil) {
        [self addObject:anObject];
    }
}

- (void)removeObjectSafely:(id)object
{
    if (object) {
        [self removeObject:object];
    }
}

- (void)insertObjectSafely:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject && index <= self.count) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)removeObjectSafelyAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

- (void)replaceObjectSafelyAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (anObject && index < self.count) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

- (void)exchangeObjectSafelyAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
    if (idx1 < self.count && idx2 < self.count) {
        [self exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    }
}

- (void)uniqueAddObject:(id)objcet
{
    if (objcet && ![self containsObject:objcet]) {
        [self addObjectSafely:objcet];
    }
}

- (void)safeAddNilObject
{
    [self addObject:[NSNull null]];
}

- (void)addPoint:(CGPoint)o
{
    [self addObject:NSStringFromCGPoint(o)];
}

- (void)addSize:(CGSize)o
{
    [self addObject:NSStringFromCGSize(o)];
}

- (void)addRect:(CGRect)o
{
    [self addObject:NSStringFromCGRect(o)];
}

@end
