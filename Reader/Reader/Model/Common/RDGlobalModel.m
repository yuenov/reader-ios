//
//  RDGlobalModel.m
//  Reader
//
//  Created by yuenov on 2019/12/23.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDGlobalModel.h"
#import "GBDeviceInfo.h"
#import "UICKeyChainStore.h"
#import <AdSupport/AdSupport.h>
#import "RDCommParamManager.h"
#import "RDConfigModel.h"



static inline uint32_t fnv_32a(void *buf, size_t len) {
    uint32_t hval = 0x811C9DC5;
    unsigned char *bp = (unsigned char *) buf;
    unsigned char *be = bp + len;
    while (bp < be) {
        hval ^= (uint32_t) *bp++;
        hval += (hval << 1) + (hval << 4) +
                (hval << 7) + (hval << 8) + (hval << 24);
    }
    return hval;
}

@implementation RDGlobalModel
+ (RDGlobalModel *)sharedInstance {
    static RDGlobalModel *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
            if ([RDCommParamManager sharedInstance].port == 0) {
                if ([RDConfigModel getModel].ports.count>0) {
                    [RDCommParamManager sharedInstance].port = [RDConfigModel getModel].ports.firstObject;
                }
                else{
                    [RDCommParamManager sharedInstance].port = @"80";
                }
                [[RDCommParamManager sharedInstance] archive];
                
            }
            if ([[RDCommParamManager sharedInstance].port isEqualToString:@"80"]) {
                sharedInstance.baseUrl = [NSString stringWithFormat:@"%@%@", [sharedInstance prefix], [sharedInstance domain]];
                sharedInstance.picBaseUrl = [NSString stringWithFormat:@"%@pt.%@", [sharedInstance prefix], [sharedInstance domain]];
            }
            else{
                sharedInstance.baseUrl = [NSString stringWithFormat:@"%@%@:%@", [sharedInstance prefix], [sharedInstance domain],[RDCommParamManager sharedInstance].port];
                sharedInstance.picBaseUrl = [NSString stringWithFormat:@"%@pt.%@:%@", [sharedInstance prefix], [sharedInstance domain],[RDCommParamManager sharedInstance].port];
            }
        }
    });

    return sharedInstance;
}
- (NSString *)domain
{
    return @"yuenov.com";
}
-(NSString *)prefix
{
    return @"http://";
}



- (NSString *)fnv1aHashForStr:(NSString *)str {
    if (str.length == 0) {
        NSAssert(NO, @"nil input");
        return nil;
    }

    return [NSString stringWithFormat:@"%x", fnv_32a((void *) [str UTF8String], str.length)];
}

-(void)changePort
{
    if ([RDConfigModel getModel].ports == 0) {
        return;
    }
    NSInteger index = [[RDConfigModel getModel].ports indexOfObject:[RDCommParamManager sharedInstance].port];
    if (index == NSNotFound) {
        [RDCommParamManager sharedInstance].port = [RDConfigModel getModel].ports.firstObject;
    }
    else{
        index += 1;
        if (index == [RDConfigModel getModel].ports.count) {
            index = 0;
        }
        [RDCommParamManager sharedInstance].port =[[RDConfigModel getModel].ports objectAtIndex:index];
    }
    [[RDCommParamManager sharedInstance] archive];
    
    if ([[RDCommParamManager sharedInstance].port isEqualToString:@"80"]) {
        self.baseUrl = [NSString stringWithFormat:@"%@%@", [self prefix], [self domain]];
        self.picBaseUrl = [NSString stringWithFormat:@"%@pt.%@", [self prefix], [self domain]];
    }
    else{
        self.baseUrl = [NSString stringWithFormat:@"%@%@:%@", [self prefix], [self domain],[RDCommParamManager sharedInstance].port];
        self.picBaseUrl = [NSString stringWithFormat:@"%@pt.%@:%@", [self prefix], [self domain],[RDCommParamManager sharedInstance].port];
    }
}
@end
