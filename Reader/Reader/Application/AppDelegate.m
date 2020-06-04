//
//  AppDelegate.m
//  Reader
//
//  Created by yuenov on 2019/10/23.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "AppDelegate.h"
#import "RDMainController.h"
#import "UIView+rd_dispalyInfo.h"
#import "RDNavigationController.h"

#import "SDWebImageWebPCoder.h"
#import "RDCheckApi.h"
#import "RDReadRecordManager.h"
#import "RDCharpterApi.h"
#import "RDCharpterDataManager.h"
#import "RDConfigModel.h"
#import "RDConfigApi.h"


@interface AppDelegate ()

@property(nonatomic, strong) RDMainController *mainController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    SDImageWebPCoder *webPCoder = [SDImageWebPCoder sharedCoder];
    [[SDImageCodersManager sharedManager] addCoder:webPCoder];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 13.0, *)) {
        //禁用dark model
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    RDNavigationController *navigationController = [[RDNavigationController alloc] initWithRootViewController:self.mainController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [self reloadData];
    
}


- (RDMainController *)mainController {
    if (!_mainController) {
        _mainController = [[RDMainController alloc] init];


    }
    return _mainController;
}

-(void)reloadData{
    RDConfigApi *configApi = [[RDConfigApi alloc] init];
    [configApi startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        if (!error) {
            RDConfigModel *configModel = [configApi configModel];
            [[RDConfigModel getModel] copyFrom:configModel];
            [[RDConfigModel getModel] archive];
        }
    }];
    
    
    NSArray *array = [RDReadRecordManager getAllOnBookshelfPram];
    if (array.count == 0) {
        return;
    }
    RDCheckApi *api = [[RDCheckApi alloc] init];
    api.books = array;
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        if (!error) {
            NSArray *array =  [api updateBooks];
            for (NSDictionary *dic in array) {
                RDCharpterApi *api = [[RDCharpterApi alloc] init];
                api.bookId = [dic[@"bookId"] integerValue];
                api.chapterId = [dic[@"chapterId"] integerValue];
                [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
                    if (!error) {
                        NSArray *charpters = [api charpters];
                        [RDReadRecordManager updateOnBookselfUpdateWithBookId:api.bookId update:YES];
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            [RDCharpterDataManager insertObjectsWithCharpters:charpters];
                        });
                    }
                }];
            }
            
        }
    }];
    
}
@end
