//
//  ONENavigationBar.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEHomeWeatherItem;

@interface ONENavigationBar : UINavigationBar

- (void)updateTitleViewWithOffset:(CGFloat)offset;

/// 确定title的状态
- (void)confirmTitlViewWithOffset:(CGFloat)offset;

/// 修改返回今天按钮的显示性
- (void)updateTitleViewBackToTodayButtonVisible:(BOOL)isHidden;

/// 修改日期
- (void)updateTitleViewDateStringWithDateString:(NSString *)dateString;

/// 修改天气
- (void)updateTitleViewWeatherStringWithWeatherItem:(ONEHomeWeatherItem *)weatherItem;

/// 隐藏日期
- (void)hideCustomTitleView;

/// 显示日期
- (void)showCustomTitleView;

/// 将导航条修改为只显示20的高度的白底格式
- (void)changeNavigationBarToShortMode;

/// 将导航条修改为无背景，按钮和状态栏均为白色的格式
- (void)changeNavigationBarToLucencyMode;

/// 恢复为原大小
- (void)resumeNavigationBar;

@end
