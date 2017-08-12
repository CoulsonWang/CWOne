//
//  ONELoginTool.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/12.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONELoginTool.h"
#import "ONELoginViewController.h"

static ONELoginTool *_instance;

@implementation ONELoginTool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (BOOL)isLogin {
    // 通过用户偏好设置取当前登录的账号信息，如果不存在，返回NO
    return NO;
}

- (void)showLoginView {
    ONELoginViewController *loginVC = [[ONELoginViewController alloc] init];
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    // 取出正在展示的子控制器
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    
    [rootVC presentViewController:loginVC animated:YES completion:nil];
}

@end
