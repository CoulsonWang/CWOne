//
//  ONEDetailViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/5.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDetailViewController.h"
#import "ONEDetailTableViewController.h"
#import "ONEHomeNavigationController.h"
#import "UIImage+Render.h"
#import "ONEDetailBottomToolView.h"
#import "ONEHomeItem.h"
#import "ONENavigationBarTool.h"

#define kBottomToolViewHeight kTabBarHeight

@interface ONEDetailViewController ()

@property (weak, nonatomic) ONEDetailBottomToolView *toolView;

@end

@implementation ONEDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 先显示一个加载视图。数据加载完成后，再显示tableview
    
    
    // 设置NavBar
    [self setUpNavigationBar];
    
    // 添加子控制器
    ONEDetailTableViewController *detailTableVC = [[ONEDetailTableViewController alloc] init];
    detailTableVC.itemId = self.homeItem.item_id;
    [self addChildViewController:detailTableVC];
    
    // 添加tableView
    detailTableVC.view.frame = self.view.bounds;
    [self.view addSubview:detailTableVC.view];
    
    // 添加自定义的底部工具条
    ONEDetailBottomToolView *toolView = [ONEDetailBottomToolView detailBottomToolView];
    toolView.frame = CGRectMake(0, CWScreenH - kBottomToolViewHeight, CWScreenW, kBottomToolViewHeight);
    [self.view addSubview:toolView];
    self.toolView = toolView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[ONENavigationBarTool sharedInstance] moveBackgroundImageToBack];
}

#pragma mark - 设置UI
- (void)setUpNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"back_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarBackButtonClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"collect_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarCollectButtonClick)];
    
    // 设置控制器标题
}

#pragma mark - 事件响应
- (void)navigationBarBackButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBarCollectButtonClick {
    NSLog(@"收藏");
}
@end
