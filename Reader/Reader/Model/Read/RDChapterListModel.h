//
//  RDChapterListModel.h
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDModel.h"
#import "RDCharpterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RDChapterListModel : RDModel
@property (nonatomic,assign) NSInteger bookId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSArray <RDCharpterModel *>*charpters;
@end

NS_ASSUME_NONNULL_END
