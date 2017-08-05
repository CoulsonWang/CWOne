//
//  ONEHomeNavigationController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeNavigationController.h"
#import "UIImage+CWColorAndStretch.h"
#import "ONEHomeNavigationBarTitleView.h"
#import "ONEHomeWeatherItem.h"
#import "ONEMainTabBarController.h"
#import <objc/message.h>

@interface ONEHomeNavigationController ()

@property (weak, nonatomic) ONEHomeNavigationBarTitleView *titleView;

- (ONEHomeWeatherItem *)weatherItem;

@end

@implementation ONEHomeNavigationController

- (ONEHomeWeatherItem *)weatherItem {
    ONEMainTabBarController *tabBarVC = (ONEMainTabBarController *)self.parentViewController;
    return tabBarVC.weatherItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:254/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    
    ONEHomeNavigationBarTitleView *titleView = [ONEHomeNavigationBarTitleView homeNavTitleView];
    titleView.frame = CGRectMake(0, -20, CWScreenW, kNavigationBarHeight);
    titleView.weatherItem = self.weatherItem;
    [self.navigationBar addSubview:titleView];
    self.titleView = titleView;
}


#pragma mark - 对外公有方法
- (void)updateTitleViewWithOffset:(CGFloat)offset {
    
    // 修改状态栏的透明度
    [self changeAlphaOfStatusBar:(offset/ONEScrollOffsetLimit)];

    // 让titleView更新
    [self.titleView updateSubFrameAndAlphaWithOffset:offset];
}

- (void)confirmTitlViewWithOffset:(CGFloat)offset {
    
    if (offset >= ONEScrollOffsetLimit * 0.5) {
        [self changeAlphaOfStatusBar:1];
        [self.titleView updateSubFrameAndAlphaWithOffset:ONEScrollOffsetLimit];
        [self.titleView enableTheTitleButton:YES];
    } else {
        [self changeAlphaOfStatusBar:0];
        [self.titleView updateSubFrameAndAlphaWithOffset:0];
        [self.titleView enableTheTitleButton:NO];
    }
}

- (void)updateTitleViewBackToTodayButtonVisible:(BOOL)isHidden {
    [self.titleView updateBackButtonVisible:isHidden];
}

- (void)updateTitleViewDateStringWithDateString:(NSString *)dateString {
    [self.titleView updateDateStringWithDateString:dateString];
}

- (void)hideCustomTitleView {
    self.titleView.hidden = YES;
}

#pragma mark - 私有方法
- (void)changeAlphaOfStatusBar:(CGFloat)alpha {
    UIApplication *app = [UIApplication sharedApplication];
    // 通过KVC拿到statusBar
    UIView *statusBar = [app valueForKeyPath:@"statusBar"];
    statusBar.alpha = alpha;
}



@end
