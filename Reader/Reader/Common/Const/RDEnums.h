//
//  RDEnums.h
//  Reader
//
//  Created by yuenov on 2019/11/19.
//  Copyright © 2019 yuenov. All rights reserved.
//

typedef NS_ENUM(NSInteger,RDPageType) {
    RDNoneTypePage,
    RDRealTypePage,
    RDSliderPage,
};

typedef NS_ENUM(NSInteger,RDThemeType) {
    RDWhiteTheme,
    RDYellowTheme,
    RDBlueTheme,
    RDGreenTheme,
    RDBlackTheme,
};

typedef NS_ENUM(NSUInteger, RDRequestState) {
    RDRequestOrigin = 0, //初次请求
    RDRequestRefresh,   //下拉刷新
    RDRequestMore       //上拉加载更多
};
typedef NS_ENUM(NSUInteger, RDCategoryType) {
    RDEndType = 0, //完本
    RDTopicType,   //专题
};

typedef NS_ENUM(NSInteger,RDCategoryFilter) {
    RDCategoryNewFilter = 1000,
    RDCategoryHotFilter,
    RDCategoryEndFilter
};

typedef NS_ENUM(NSInteger,RDGenderType) {
    RDMaleType = 0,
    RDFemaleType
};

typedef NS_ENUM(NSInteger,RDCommPageType) {
    RDPageDiscoverType,
    RDPageEndType,
    RDPageTopicType,
    RDPageRecommendType,    //书籍详情里面的推荐
};
