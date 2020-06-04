//
//  RDCharpterModel.h
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDCharpterModel : RDModel
@property (nonatomic,strong) NSString *primaryId;

@property (nonatomic,assign) NSInteger charpterId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *content;

//数据库存储使用
@property (nonatomic,assign) NSInteger bookId;
@property (nonatomic,strong) NSString *bookName;
@property (nonatomic,strong) NSString *author;
@end
