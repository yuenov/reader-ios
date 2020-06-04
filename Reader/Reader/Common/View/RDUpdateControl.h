//
//  RDUpdateControl.h
//  Reader
//
//  Created by yuenov on 2020/2/21.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDUpdateControl : UIControl
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,assign) CGFloat spacing;
@property (nonatomic,assign) CGSize imageSize;
-(void)beginAnimation;
-(void)endAnimation;
@end
