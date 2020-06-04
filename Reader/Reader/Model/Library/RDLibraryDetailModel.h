//
//  RDLibraryDetailModel.h
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDLibraryDetailModel : RDModel

@property (nonatomic,strong) NSString *bookId;
@property (nonatomic,strong) NSString *coverImg;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,assign) BOOL end;          //是否连载
@property (nonatomic,strong) NSString *category;
@end
