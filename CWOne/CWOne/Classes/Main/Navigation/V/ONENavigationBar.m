//
//  ONENavigationBar.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONENavigationBar.h"
#import "ONEMainTabBarController.h"
#import "ONEHomeNavigationBarTitleView.h"
#import "UIImage+CWColorAndStretch.h"

@interface ONENavigationBar ()

@property (weak, nonatomic) UIImageView *navBarBackgroundView;

@property (strong, nonatomic) ONEHomeNavigationBarTitleView *titleView;

@property (assign, nonatomic) CGFloat tempStatusBarAlpha;

@end

@implementation ONENavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpBackgroundView];
        [self setUpHomeTitleView];
    }
    return self;
}

- (void)setUpBackgroundView {
    // 设置navBar背景色
    UIImage *backgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:254/255.0 alpha:1.0] size:CGSizeMake(CWScreenW, kNavigationBarHeight)];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, CWScreenW, kNavigationBarHeight)];
    backgroundImageView.image = backgroundImage;
    [self insertSubview:backgroundImageView atIndex:0];
    self.navBarBackgroundView = backgroundImageView;
}

- (void)setUpHomeTitleView {
    ONEHomeNavigationBarTitleView *titleView = [ONEHomeNavigationBarTitleView homeNavTitleView];
    titleView.frame = CGRectMake(0, -20, CWScreenW, kNavigationBarHeight);
    ONEMainTabBarController *tabBarVC = (ONEMainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    titleView.weatherItem = tabBarVC.weatherItem;
    [self addSubview:titleView];
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
    [self saveTempAlpha];
    [self changeAlphaOfStatusBar:1.0];
}

- (void)showCustomTitleView {
    self.titleView.hidden = NO;
    [self changeAlphaOfStatusBar:self.tempStatusBarAlpha];
}

#pragma mark - 私有方法
- (void)changeAlphaOfStatusBar:(CGFloat)alpha {
    UIApplication *app = [UIApplication sharedApplication];
    // 通过KVC拿到statusBar
    UIView *statusBar = [app valueForKeyPath:@"statusBar"];
    statusBar.alpha = alpha;
}

- (void)saveTempAlpha {
    UIApplication *app = [UIApplication sharedApplication];
    // 通过KVC拿到statusBar
    UIView *statusBar = [app valueForKeyPath:@"statusBar"];
    self.tempStatusBarAlpha = statusBar.alpha;
}


@end
