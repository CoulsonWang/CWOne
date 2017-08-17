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

- (ONENavigationBar *)currentNavigationBar;

@property (weak, nonatomic) UIViewController *currentVC;

@end

@implementation ONENavigationBarTool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ONENavigationBarTool alloc] init];
    });
    return _instance;
}

- (void)updateCurrentViewController:(UIViewController *)viewController {
    self.currentVC = viewController;
}

// 获取当前的navigationBar
- (ONENavigationBar *)currentNavigationBar {
    ONEHomeNavigationController *navController = (ONEHomeNavigationController *)self.currentVC.navigationController;
    ONENavigationBar *navBar = (ONENavigationBar *)navController.navigationBar;
    return navBar;
}

/// 更新title的状态
- (void)updateTitleViewWithOffset:(CGFloat)offset {
    [self.currentNavigationBar updateTitleViewWithOffset:offset];
}

/// 确定title的状态
- (void)confirmTitlViewWithOffset:(CGFloat)offset {
    [self.currentNavigationBar confirmTitlViewWithOffset:offset];
}

/// 修改返回今天按钮的显示性
- (void)updateTitleViewBackToTodayButtonVisible:(BOOL)isHidden {
    [self.currentNavigationBar updateTitleViewBackToTodayButtonVisible:isHidden];
}

/// 修改日期
- (void)updateTitleViewDateStringWithDateString:(NSString *)dateString {
    [self.currentNavigationBar updateTitleViewDateStringWithDateString:dateString];
}

/// 修改天气
- (void)updateTitleViewWeatherStringWithWeatherItem:(ONEHomeWeatherItem *)weatherItem {
    [self.currentNavigationBar updateTitleViewWeatherStringWithWeatherItem:weatherItem];
}

/// 隐藏日期
- (void)hideCustomTitleView {
    [self.currentNavigationBar hideCustomTitleView];
}

/// 显示日期
- (void)showCustomTitleView {
    [self.currentNavigationBar showCustomTitleView];
}


- (void)hideNavigationBar {
    [self.currentNavigationBar changeNavigationBarToShortMode];
}

- (void)changeNavigationBarToShortMode {
    [self.currentNavigationBar changeNavigationBarToShortMode];
}

- (void)changeNavigationBarToLucencyMode {
    [self.currentNavigationBar changeNavigationBarToLucencyMode];
}

- (void)resumeNavigationBar {
    [self.currentNavigationBar resumeNavigationBar];
}

- (void)changeNavigationBarTintColor:(ONENavigationBarTintColor)color {
    switch (color) {
        case ONENavigationBarTintColorGray:
            [self.currentNavigationBar setTintColor:[UIColor grayColor]];
            break;
        case ONENavigationBarTintColorWhite:
            [self.currentNavigationBar setTintColor:[UIColor whiteColor]];
            break;
        case ONENavigationBarTintColorDark:
            [self.currentNavigationBar setTintColor:[UIColor darkGrayColor]];
            break;
            
        default:
            break;
    }
}

/// 显示或隐藏阴影
- (void)changeShadowViewVisible:(BOOL)visible {
    [self.currentNavigationBar changeShadowViewVisible:visible];
}

// 修改statusBar的方法，不需要用到currentVC
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
@end
