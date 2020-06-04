//
//  RDUtilities.m
//  Reader
//
//  Created by yuenov on 2019/12/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDUtilities.h"
#import "RDMainController.h"
#import "RDGlobalModel.h"
#import "GBDeviceInfo.h"

@implementation RDUtilities
+ (UIViewController *_Nullable)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }


    UIView *frontView = [[window subviews] objectAtIndexSafely:0];
    id nextResponder = [frontView nextResponder];


    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    UIViewController *vc = [self currentVCWithVC:result];
    if ([vc isKindOfClass:[RDMainController class]]) {
        return [(RDMainController *) vc selectedViewController] ?: vc;
    }

    return vc;
}
+ (UIViewController *)currentVCWithVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self currentVCWithVC:((UITabBarController *) vc).selectedViewController];
    }

    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self currentVCWithVC:((UINavigationController *) vc).visibleViewController];
    }

    return vc;
}

+ (NSString *)buildPicUrlWithPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@",[RDGlobalModel sharedInstance].picBaseUrl,path];
}

+ (BOOL)iPad
{
    GBDeviceInfo *info = [GBDeviceInfo deviceInfo];
    return info.family == GBDeviceFamilyiPad;
}
@end
