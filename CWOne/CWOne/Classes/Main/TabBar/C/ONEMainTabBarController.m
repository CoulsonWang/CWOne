//
//  ONEMainTabBarController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEMainTabBarController.h"
#import "UIImage+CWColorAndStretch.h"

#define kUITabBarHeight 49.0

@interface ONEMainTabBarController ()

@end

@implementation ONEMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTabBar];
}


- (void)setUpTabBar {
    
    // 设置tabBar背景色
    UIImage *backgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:254/255.0 alpha:1.0] size:CGSizeMake(CWScreenW, kUITabBarHeight)];
    [self.tabBar insertSubview:[[UIImageView alloc] initWithImage:backgroundImage] atIndex:0];
    
    
    //调整tabBar中图片的位置
    for (UIViewController *vc in self.viewControllers) {
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
    }
}


@end
