//
//  RDModelAgent.m
//  Reader
//
//  Created by yuenov on 2019/10/26.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDModelAgent.h"
#import "NSFileManager+rd_wid.h"
#import "RDModel.h"
#define kModelFileExt                     (@"model")
#define kModelFileDir                     (@"YYModel")

@implementation RDModelAgent
+ (instancetype)agent {
    return [[RDModelAgent alloc] init];
}

#pragma mark - read/write/delete

- (BOOL)writeModel:(RDModel *)model {
    if (model) {
        NSString *fileName = [NSString stringWithUTF8String:class_getName([model class])];
        return [self writeModel:model toFileWithName:fileName];
    } else {
        NSLog(@"model is null");
        return NO;
    }
}

- (BOOL)writeModel:(RDModel *)model toFileWithName:(NSString *)fileName {
    if (CheckValidString(fileName)) {
        return [self writeModel:model toDisk:[self filePathWithName:fileName]];
    } else {
        NSLog(@"fileName is null");
        return NO;
    }
}

- (BOOL)writeModel:(RDModel *)model toDisk:(NSString *)path {
    BOOL result = NO;
    if (CheckValidString(path)) {
        path = [path stringByAppendingPathExtension:kModelFileExt];
        result = [NSKeyedArchiver archiveRootObject:model toFile:path];
        if (!result) {
            NSLog(@"Failed to archive. Path :%@", path);
        }
    } else {
        NSLog(@"Path is null");
    }
    return result;
}

- (id)readModelForClass:(Class)class {
    return [self readModelFromFileWithName:[NSString stringWithUTF8String:class_getName(class)]];
}

- (id)readModelFromFileWithName:(NSString *)fileName {
    if (CheckValidString(fileName)) {
        return [self readModelFromDisk:[self filePathWithName:fileName]];
    } else {
        NSLog(@"fileName is nil");
        return nil;
    }
}

- (id)readModelFromDisk:(NSString *)path {
    RDModel *result = nil;
    if (CheckValidString(path)) {
        path = [path stringByAppendingPathExtension:kModelFileExt];
        id data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if ([data isKindOfClass:RDModel.class]) {
            result = data;
        } else if (data) {
            NSLog(@"Class Type is wrong. %@", [data class]);
        }
    } else {
        NSLog(@"Path is null");
    }
    return result;
}

- (BOOL)removeModel:(RDModel *)model toFileWithName:(NSString *)fileName {
    if (CheckValidString(fileName)) {
        return [self deleteModel:model toFilePath:[self filePathWithName:fileName]];
    } else {
        NSLog(@"fileName is null");
        return NO;
    }
}

- (BOOL)deleteModel:(RDModel *)model toFilePath:(NSString *)filePath {
    BOOL result = NO;
    if (CheckValidString(filePath)) {
        filePath = [filePath stringByAppendingPathExtension:kModelFileExt];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager isDeletableFileAtPath:filePath]) {
            result = [fileManager removeItemAtPath:filePath error:nil];
            if (!result) {
                NSLog(@"Failed to archive. Path :%@", filePath);
            }
        } else {
            result = NO;
        }
    } else {
        NSLog(@"Path is null");
    }

    return result;
}

- (NSString *)filePathWithName:(NSString *)name {
    NSString *dir = [PATH_DOCUMENT stringByAppendingPathComponent:kModelFileDir];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        [NSFileManager addSkipBackupAttributeToPath:dir];
    }

    return [dir stringByAppendingPathComponent:name];
}

#pragma mark - json to model

- (NSArray *)createModel:(Class)modelClass fromJson:(id)json {
//    if (![modelClass isSubclassOfClass:JHModel.class]) {
//        NSLog(@"Not JHModel. %@", modelClass);
//        return nil;
//    }

    NSArray *result = nil;
    if (CheckValidArray(json)) {
        result = [NSArray yy_modelArrayWithClass:modelClass json:json];
    } else if (CheckValidDictionary(json)) {
        id model = [modelClass yy_modelWithDictionary:json];
        if (model) {
            result = @[model];
        } else {
            NSLog(@"Fail to create model");
        }
    } else {
        NSLog(@"Not json data.");
    }

    return result;
}


- (NSDictionary *)createJsonFromModel:(RDModel *)model {
    NSDictionary *result = [model yy_modelToJSONObject];
    if (!CheckValidDictionary(result)) {
        NSLog(@"Fail to get Json data.");
    }
    return result;
}

- (NSArray *)createJsonArrayFromModel:(NSArray *)modelArray {
    NSArray *result = [modelArray yy_modelToJSONObject];

    if (!CheckValidArray(result)) {
        NSLog(@"Fail to get Json data.");
    }
    return result;
}
@end
