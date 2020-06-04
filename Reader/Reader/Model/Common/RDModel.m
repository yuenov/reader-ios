//
//  RDModel.m
//  Reader
//
//  Created by yuenov on 2019/10/26.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDModel.h"
#import "RDModelAgent.h"

@implementation RDModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}

#pragma mark - helper

- (BOOL)archive {
    return [[RDModelAgent agent] writeModel:self];
}

- (BOOL)archiveToFileWithName:(NSString *)fileName {
    return [[RDModelAgent agent] writeModel:self toFileWithName:fileName];
}

- (BOOL)archiveToPath:(NSString *)path {
    return [[RDModelAgent agent] writeModel:self toDisk:path];
}

- (BOOL)deleteToFileWithName:(NSString *)fileName {
    return [[RDModelAgent agent] removeModel:self toFileWithName:fileName];
}

- (void)copyFrom:(RDModel *)other {
    if (!other) {
        NSAssert(NO, @"other model is nil");
        return;
    }

    if ([other isEqual:self]) {
        return;
    }

    NSArray *propertyKeys = [[self class] propertyKeys].allObjects;
    for (NSString *key in propertyKeys) {
        if (![self isKindOfClass:[other class]]) {
            NSArray *propertyKeys = [[other class] propertyKeys].allObjects;
            if (![propertyKeys containsObject:key]) {
                continue;
            }
        }
        [self setValue:[other valueForKey:key] forKey:key];
    }
}

- (void)copyFrom:(RDModel *)other blackList:(NSArray *)list {
    if (!other) {
        NSAssert(NO, @"other model is nil");
        return;
    }

    if ([other isEqual:self]) {
        return;
    }

    NSArray *propertyKeys = [[self class] propertyKeys].allObjects;
    for (NSString *key in propertyKeys) {
        if (![self isKindOfClass:[other class]]) {
            NSArray *propertyKeys = [[other class] propertyKeys].allObjects;
            if (![propertyKeys containsObject:key]) {
                continue;
            }
        }
        if (![list containsObject:key]) {
            [self setValue:[other valueForKey:key] forKey:key];
        }
    }
}

- (void)updateFrom:(RDModel *)other blackList:(NSArray *)list {

    if (!other) {
        NSAssert(NO, @"other model is nil");
        return;
    }

    if ([other isEqual:self]) {
        return;
    }

    NSArray *propertyKeys = [[self class] propertyKeys].allObjects;
    for (NSString *key in propertyKeys) {
        id value = [other valueForKey:key];
        if (!value || ([value isKindOfClass:[NSNumber class]] && ([value integerValue] == 0))) {
            continue;
        }
        if (![list containsObject:key]) {
            [self setValue:value forKey:key];
        }
    }

}

+ (NSSet *)propertyKeys {
    NSMutableSet *keys = [NSMutableSet set];

    Class cls = self;
    unsigned count = 0;
    while (![cls isEqual:RDModel.class]) {
        objc_property_t *properties = class_copyPropertyList(cls, &count);

        cls = cls.superclass;
        if (properties == NULL) continue;

        for (unsigned i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString *key = @(property_getName(property));
            [keys addObject:key];
        }

        free(properties);
    }

    return keys;
}

- (int)transformStr:(NSString *)str
       defaultValue:(int)defaultValue
           fromDict:(NSDictionary *)dict {
    str = MakeNSString(str);
    dict = MakeNSDictionary(dict);
    NSNumber *number = MakeNSNumber(dict[str]);
    return number != nil ? [number intValue] : defaultValue;
}

- (NSString *)reverseTransform:(int)number
                  defaultValue:(NSString *)defaultValue
                      fromDict:(NSDictionary *)dict {
    dict = MakeNSDictionary(dict);

    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithCapacity:dict.count];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [resultDictionary setObject:key forKey:obj];
    }];

    NSString *string = MakeNSString(resultDictionary[@(number)]);
    return string != nil ? string : defaultValue;
}


@end
