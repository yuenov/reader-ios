//
//  RDBookshelfBaseCell.m
//  Reader
//
//  Created by yuenov on 2019/10/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBookshelfBaseCell.h"

@implementation RDBookshelfBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
