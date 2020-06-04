//
//  RDBookDetailBaseCell.m
//  Reader
//
//  Created by yuenov on 2019/10/31.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDBookDetailBaseCell.h"

@implementation RDBookDetailBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


@end
