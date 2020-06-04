//
//  RDDateUtil.m
//  Reader
//
//  Created by yuenov on 2019/12/24.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDDateUtil.h"

@implementation RDDateUtil
+(NSString *)lastUpdateTimeWith:(NSTimeInterval)time
{
    NSTimeInterval interval = ([NSDate date].timeIntervalSince1970*1000-time)/1000;
    NSInteger year,month,day,hour,mintiue;
    mintiue = interval/60;
    hour = interval/60/60;
    day = interval/60/60/24;
    month = interval/60/60/24/30;
    year = interval/60/60/24/365;
    if (year>0) {
        return [NSString stringWithFormat:@"%d年前",year];
    }
    if (month>0) {
        return [NSString stringWithFormat:@"%d月前",month];
    }
    if (day>0) {
        return [NSString stringWithFormat:@"%d天前",day];
    }
    if (hour>0) {
        return [NSString stringWithFormat:@"%d小时前",hour];
    }
    if (mintiue>0) {
        return [NSString stringWithFormat:@"%d分钟前",mintiue];
    }
    return nil;
}
@end
