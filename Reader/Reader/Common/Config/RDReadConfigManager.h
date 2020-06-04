//
//  RDReadConfigManager.h
//  Reader
//
//  Created by yuenov on 2019/11/13.
//  Copyright © 2019 yuenov. All rights reserved.
//

#import "RDModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kConfigMaxBrightnessValue 0.5
#define kConfigMinFontSize 14.f
#define kConfigMaxFontSize 30.f

@interface RDReadConfigManager : RDModel
@property (nonatomic,assign) CGFloat lineSpace; //行间距
@property (nonatomic,assign) CGFloat fontSize;  //字体大小
@property (nonatomic,strong) NSString *fontName;    //字体名称
@property (nonatomic,strong) UIColor *fontColor;    //字体颜色
@property (nonatomic,strong) UIImage *background;   //主题
@property (nonatomic,assign) CGFloat chapterFontSize;   //标题字体大小
@property (nonatomic,assign) CGFloat chapterLineSpace;  //标题行间距
@property (nonatomic,assign) CGFloat firstLineHeadIndent;  //首行缩紧
@property (nonatomic,assign) CGFloat brightness;        //屏幕亮度
@property (nonatomic,assign) RDPageType pageType;       //翻页效果
@property (nonatomic,strong) UIColor *samllCharpterColor;   //左上角小标题颜色
@property (nonatomic,strong) UIColor *toolColor;        //下面电量进度颜色
//设置主题
@property (nonatomic,assign) RDThemeType theme;
+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
