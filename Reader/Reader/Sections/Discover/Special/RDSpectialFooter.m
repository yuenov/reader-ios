//
//  RDSpectialFooter.m
//  Reader
//
//  Created by yuenov on 2020/4/1.
//  Copyright © 2020 yuenov. All rights reserved.
//

#import "RDSpectialFooter.h"
#import "RDUpdateControl.h"
#import "RDAllSpecialApi.h"
#import "RDCommCategoryController.h"

@implementation RDSpectialFooter
-(void)setSpecialModel:(RDSpecialModel *)specialModel
{
    _specialModel = specialModel;
    [super setModel:specialModel];
    
}

-(void)click:(UIButton *)sender
{
    RDCommCategoryController *controller = [[RDCommCategoryController alloc] init];
    controller.catagoryId = self.specialModel.specialId;
    controller.categoryName = self.specialModel.name;
    controller.type = self.model.type;
    controller.pageType = RDPageTopicType;
    [[RDUtilities getCurrentVC].navigationController pushViewController:controller animated:YES];
}

-(void)update:(RDUpdateControl *)sender
{
    [sender beginAnimation];
    RDSpecialModel *model = self.specialModel;
    model.page++;
    RDAllSpecialApi *api = [[RDAllSpecialApi alloc] init];
    api.page = model.page;
    api.size = model.size;
    api.specialId = model.specialId;
    [api startWithCompletionBlock:^(RDBaseApi * _Nonnull request, NSString * _Nonnull error) {
        [sender endAnimation];
        if (!error) {
            NSArray *list = api.list;
            if (list.count<model.size) {
                model.page = 0;
            }
            if (list.count>0) {
                model.bookList = list;
                if (self.specialNeedReload) {
                    self.specialNeedReload(model);
                }
            }
        }
    }];
}
@end
