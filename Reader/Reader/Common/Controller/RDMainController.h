//
//  RDMainController.h
//  Reader
//
//  Created by yuenov on 2019/10/23.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDVTabBarController.h"

typedef NS_ENUM(NSInteger,RDMainBarItemType){
    RDMainBookShelf = 0,
    RDMainDiscover,
    RDMainLibrary,
    RDMainMe
};

@interface RDMainController : RDVTabBarController <RDVTabBarControllerDelegate>

@end
