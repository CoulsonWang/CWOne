//
//  ONENavigationBarTool.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ONENavigationBarTintColorGray,
    ONENavigationBarTintColorWhite,
    ONENavigationBarTintColorDark,
} ONENavigationBarTintColor;

@interface ONENavigationBarTool : NSObject

+ (instancetype)sharedInstance;


// 用于修改HomeNavigationBar的方法

- (void)updateTitleViewWithOffset:(CGFloat)offset;

/// 确定title的状态
- (void)confirmTitlViewWithOffset:(CGFloat)offset;

/// 修改返回今天按钮的显示性
- (void)updateTitleViewBackToTodayButtonVisible:(BOOL)isHidden;

/// 修改日期
- (void)updateTitleViewDateStringWithDateString:(NSString *)dateString;

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

/// 隐藏状态栏
- (void)hideStatusBarWithAnimated:(BOOL)animated;

/// 恢复状态栏显示s
- (void)resumeStatusBarWithAnimated:(BOOL)animated;

/// 修改导航按钮的主题色
- (void)changeNavigationBarTintColor:(ONENavigationBarTintColor)color;

@end
