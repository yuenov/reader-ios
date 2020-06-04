//
//  RDModelAgent.h
//  Reader
//
//  Created by yuenov on 2019/10/26.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RDModel;

NS_ASSUME_NONNULL_BEGIN
@protocol RDModelPersist <NSObject>

- (BOOL)writeModel:(RDModel *)model toDisk:(NSString *)path;

- (RDModel *)readModelFromDisk:(NSString *)path;

@end
@interface RDModelAgent : NSObject <RDModelPersist>
/**
 *  Quick way to create Agent
 *
 *  @return instance of JHModelAgent
 */
+ (instancetype)agent;

/**
 *  Write Model instance to File
 *
 *  @param modelClass Should be derived from JHModel.
 *
 */
- (BOOL)writeModel:(RDModel *)model;

/**
 *  Write Model instance to File
 *
 *  @param modelClass Should be derived from JHModel.
 *  @param fileName   fileName but not full path.
 *
 */
- (BOOL)writeModel:(RDModel *)model toFileWithName:(NSString *)fileName;

/**
 *  Write Model instance to File
 *
 *  @param modelClass Should be derived from JHModel.
 *  @param path  fullpath.
 *
 */
- (BOOL)writeModel:(RDModel *)model toDisk:(NSString *)path;

/**
 *  Read Model instance for Class
 *
 *  @param class .
 *
 */
- (id)readModelForClass:(Class)class1;

/**
 *  Read Model instance from File
 *
 *  @param fileName  fileName but not full path.
 *
 */
- (id)readModelFromFileWithName:(NSString *)fileName;

/**
 *  Read Model instance from File
 *
 *  @param path  fullpath.
 *
 */
- (id)readModelFromDisk:(NSString *)path;

/*
 *  Delete Model from File
 *
 *  @param modelClass Should be derived from JHModel.
 *  @param fileName   fileName but not full path.
 */
- (BOOL)removeModel:(RDModel *)model toFileWithName:(NSString *)fileName;

/**
*  Create Model instance from Json Data
*
*  @param modelClass maybe any class.
*  @param json       Json data. Should be a NSArray or a NSDictionary.
*
*  @return A NSArray contains the Model instances.
*/
- (NSArray *)createModel:(Class)modelClass fromJson:(id)json;


/**
*  Create Json data from a JHModel.
*
*  @param model Should be derived from JHModel.
*
*  @return Json data.(NSDictionary)
*/
- (NSDictionary *)createJsonFromModel:(RDModel *)model;

/**
*  Create Json data from a JHModel.
*
*  @param modelArray A NSArray contains models. Models Should be derived from JHModel.
*
*  @return Json data.(NSArray)
*/
- (NSArray *)createJsonArrayFromModel:(NSArray *)modelArray;


@end

NS_ASSUME_NONNULL_END
