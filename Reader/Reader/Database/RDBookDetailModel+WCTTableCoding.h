//
//  RDBookDetailModel+WCTTableCoding.h
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBookDetailModel.h"
#import <WCDB/WCDB.h>

@interface RDBookDetailModel (WCTTableCoding) <WCTTableCoding>


WCDB_PROPERTY(bookId)
WCDB_PROPERTY(coverImg)
WCDB_PROPERTY(title)
WCDB_PROPERTY(author)
WCDB_PROPERTY(desc)

WCDB_PROPERTY(bookUpdate)
WCDB_PROPERTY(charpterModel)
WCDB_PROPERTY(page)
WCDB_PROPERTY(readTime)
WCDB_PROPERTY(onBookshelf)

@end
