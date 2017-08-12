//
//  ONENavigationBarTool.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEMainTabBarController.h"
#import "ONENavigationBarTool.h"
#import "ONENavigationBar.h"
#import "ONEHomeNavigationController.h"

static ONENavigationBarTool *_instance;

@interface ONENavigationBarTool ()

- (ONENavigationBar *)homeNavigationBar;

@end

@implementation ONENavigationBarTool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ONENavigationBarTool alloc] init];
    });
    return _instance;
}

// 用于修改HomeNavigationBar的方法
- (ONENavigationBar *)homeNavigationBar {
    ONEMainTabBarController *tabBarVc = (ONEMainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    ONEHomeNavigationController *navController = tabBarVc.viewControllers.firstObject;
    ONENavigationBar *navBar = (ONENavigationBar *)navController.navigationBar;
    return navBar;
}
/// 更新title的状态
- (void)updateTitleViewWithOffset:(CGFloat)offset {
    [self.homeNavigationBar updateTitleViewWithOffset:offset];
}

/// 确定title的状态
- (void)confirmTitlViewWithOffset:(CGFloat)offset {
    [self.homeNavigationBar confirmTitlViewWithOffset:offset];
}

/// 修改返回今天按钮的显示性
- (void)updateTitleViewBackToTodayButtonVisible:(BOOL)isHidden {
    [self.homeNavigationBar updateTitleViewBackToTodayButtonVisible:isHidden];
}

/// 修改日期
- (void)updateTitleViewDateStringWithDateString:(NSString *)dateString {
    [self.homeNavigationBar updateTitleViewDateStringWithDateString:dateString];
}

/// 隐藏日期
- (void)hideCustomTitleView {
    [self.homeNavigationBar hideCustomTitleView];
}

/// 显示日期
- (void)showCustomTitleView {
    [self.homeNavigationBar showCustomTitleView];
}


- (void)hideNavigationBar {
    [self.homeNavigationBar changeNavigationBarToShortMode];
}
- (void)changeNavigationBarToShortMode {
    [self.homeNavigationBar changeNavigationBarToShortMode];
}

- (void)changeNavigationBarToLucencyMode {
    [self.homeNavigationBar changeNavigationBarToLucencyMode];
}

- (void)resumeNavigationBar {
    [self.homeNavigationBar resumeNavigationBar];
}

- (void)hideStatusBarWithAnimated:(BOOL)animated {
    NSTimeInterval duration = animated ? 0.5 : 0;
    [UIView animateWithDuration:duration animations:^{
        UIApplication *app = [UIApplication sharedApplication];
        // 通过KVC拿到statusBar
        UIView *statusBar = [app valueForKeyPath:@"statusBar"];
        statusBar.alpha = 0;
    }];
}

- (void)changeStatusBarAlpha:(CGFloat)alpha {
    UIApplication *app = [UIApplication sharedApplication];
    // 通过KVC拿到statusBar
    UIView *statusBar = [app valueForKeyPath:@"statusBar"];
    statusBar.alpha = alpha;
}

- (void)resumeStatusBarWithAnimated:(BOOL)animated {
    NSTimeInterval duration = animated ? 0.5 : 0;
    [UIView animateWithDuration:duration animations:^{
        UIApplication *app = [UIApplication sharedApplication];
        // 通过KVC拿到statusBar
        UIView *statusBar = [app valueForKeyPath:@"statusBar"];
        statusBar.alpha = 1;
    }];
}

- (void)changeNavigationBarTintColor:(ONENavigationBarTintColor)color {
    switch (color) {
        case ONENavigationBarTintColorGray:
            [self.homeNavigationBar setTintColor:[UIColor grayColor]];
            break;
        case ONENavigationBarTintColorWhite:
            [self.homeNavigationBar setTintColor:[UIColor whiteColor]];
            break;
        case ONENavigationBarTintColorDark:
            [self.homeNavigationBar setTintColor:[UIColor darkGrayColor]];
            break;
            
        default:
            break;
    }
}

@end
