//
//  RDReadParser.h
//  Reader
//
//  Created by yuenov on 2019/11/21.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kTopMargin (40+[UIView safeTopBar])
#define kBottomMargin (40+[UIView safeBottomBar])
#define kLeftMargin 20
#define kRightMargin 20

@interface RDReadParser : UIView

+(void)paginateWithContent:(NSString *)content charpter:(NSString *)charpter bounds:(CGRect)bounds complete:(void(^)(NSAttributedString *content,NSArray *pages))complete;


+(NSString *)getShowContent:(NSString *)content charpter:(NSString *)charpter;

/// 解析内容属性
+(NSDictionary *)paraserFontArrribute:(RDReadConfigManager *)config;

/// 解析章节属性
+(NSDictionary *)paraserChapterFontArrribute:(RDReadConfigManager *)config;


@end

NS_ASSUME_NONNULL_END
