//
//  ONEHomeController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeController.h"
#import "ONEHomeNavigationBarTitleView.h"

@interface ONEHomeController ()

@end

@implementation ONEHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBarItem];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setUpNavigationBarItem {
    self.navigationItem.titleView = [ONEHomeNavigationBarTitleView homeNavTitleView];
    
    UIButton *searchButton = [[UIButton alloc] init];
    [searchButton setImage:[UIImage imageNamed:@"search_gray"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"search_dark"] forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(searchButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [searchButton sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
}


#pragma mark - 事件响应
- (void)searchButtonDidClick {
    NSLog(@"点击了右侧搜索按钮");
}

@end
