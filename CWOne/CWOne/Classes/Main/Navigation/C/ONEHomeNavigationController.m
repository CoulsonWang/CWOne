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

@interface ONEHomeNavigationController ()

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
    titleView.frame = CGRectMake(0, -20, CWScreenW, 64);
    titleView.weatherItem = self.weatherItem;
    [self.navigationBar addSubview:titleView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
