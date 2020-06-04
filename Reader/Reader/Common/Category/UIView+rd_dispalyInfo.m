//
// Created by yuenov on 2019/10/23.
// Copyright (c) 2019 yuenov. All rights reserved.
//

#import "UIView+rd_dispalyInfo.h"
#import "GBDeviceInfo.h"


@implementation UIView (rd_dispalyInfo)
+ (CGFloat)statusBar {
    if ([self isIphoneX]) {
        return 44;
    } else {
        return 20;
    }
}

+ (CGFloat)navigationBar {
    return 44;
}

///判断是否为X,指带刘海屏的设备
+ (BOOL)isIphoneX {
    CGFloat safeAreaBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeAreaBottom = UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;
    }
    return safeAreaBottom != 0;
}

+ (CGFloat)tarBar {
    if ([self isIphoneX]) {
        return 49 + 34;
    }
    return 49;
}

+ (CGFloat)safeBottomBar {
    CGFloat safeAreaBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeAreaBottom = UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;
    }
    return safeAreaBottom;
}

+ (CGFloat)safeTopBar {
    if ([self isIphoneX]) {
        return 24;
    } else {
        return 0;
    }
}

+ (CGFloat)margins {
    return 15;
}

+ (CGFloat)mainMargins {
    return 20;
}

+ (CGFloat)getAdMargin {
    GBDeviceDisplay display = [GBDeviceInfo deviceInfo].displayInfo.display;
    CGFloat insets = 0.0f;

    if (display == GBDeviceDisplay3p5Inch) {
        insets = 100;
    } else if (display == GBDeviceDisplay4Inch) {
        insets = 110;
    } else if (display == GBDeviceDisplay4p7Inch) {
        insets = 120;
    } else {
        insets = 130;
    }

    return insets;
}
@end
