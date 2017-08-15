//
//  ONESearchTool.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/14.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONESearchTool.h"
#import "ONESearchViewController.h"
#import "ONESearchResultViewController.h"
#import "ONEHomeNavigationController.h"

static ONESearchTool *_instance;
@implementation ONESearchTool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)presentSearchViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    ONESearchViewController *searchVC = [[ONESearchViewController alloc] init];
    
    ONEHomeNavigationController *navVC = [[ONEHomeNavigationController alloc] initWithRootViewController:searchVC];
    
    [rootVC presentViewController:navVC animated:YES completion:nil];
}

- (void)presentSearchResultViewControllerWithSearchText:(NSString *)searchText {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    ONESearchResultViewController *resultVC = [[ONESearchResultViewController alloc] init];
    resultVC.searchText = searchText;
    ONEHomeNavigationController *navVC = [[ONEHomeNavigationController alloc] initWithRootViewController:resultVC];
    
    [rootVC presentViewController:navVC animated:YES completion:nil];
}

@end
