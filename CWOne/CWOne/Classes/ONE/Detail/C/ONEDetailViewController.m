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
#import "ONENetworkTool.h"
#import <FLAnimatedImage.h>

#define kBottomToolViewHeight kTabBarHeight

@interface ONEDetailViewController () <ONEDetailTableViewControllerDelegate>

@property (weak, nonatomic) ONEDetailBottomToolView *toolView;

@property (strong, nonatomic, readonly) NSString *typeName;

@property (weak, nonatomic) FLAnimatedImageView *loadingImageView;

@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UIScrollView *scrollView;

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置NavBar
    [self setUpNavigationBar];
    
    // 监听通知
    [self setUpNotifications];
    
    // 添加ScrollView
    [self setUpScrollView];
    
    // 初始化tableView
    [self setUpTableView];
    
    // 添加加载视图
    [self setUpLoadingAnimateView];
    
    // 添加自定义的底部工具条
    [self setUpBottomToolView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[ONENavigationBarTool sharedInstance] moveBackgroundImageToBack];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ONENavigationBarTool sharedInstance] resumeNavigationBar];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)typeName {
    switch (self.homeItem.type) {
        case ONEHomeItemTypeEssay:
            return @"essay";
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark - 设置UI
- (void)setUpNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"back_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarBackButtonClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"collect_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarCollectButtonClick)];
    
    // 设置控制器标题
    self.title = self.homeItem.typeName;
}

- (void)setUpNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseComment:) name:ONECommentPraiseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unPraiseComment:) name:ONECommentUnpraiseNotification object:nil];
}

- (void)setUpScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, CWScreenW, CWScreenH);
    CGFloat contentSizeWidth;
    switch (self.homeItem.type) {
        case ONEHomeItemTypeEssay:
            contentSizeWidth = 0;
            break;
        case ONEHomeItemTypeSerial:
            contentSizeWidth = self.homeItem.serial_list.count * CWScreenW;
            break;
        default:
            contentSizeWidth = 0;
            break;
    }
    scrollView.contentSize = CGSizeMake(contentSizeWidth, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setUpTableView {
    // 添加子控制器
    ONEDetailTableViewController *detailTableVC = [[ONEDetailTableViewController alloc] init];
    detailTableVC.delegate = self;
    detailTableVC.type = self.homeItem.type;
    detailTableVC.itemId = self.homeItem.item_id;
    [self addChildViewController:detailTableVC];
    
    // 添加tableView
    detailTableVC.view.frame = self.view.bounds;
    [self.scrollView addSubview:detailTableVC.view];
    self.tableView = detailTableVC.tableView;
}

- (void)setUpBottomToolView {
    ONEDetailBottomToolView *toolView = [ONEDetailBottomToolView detailBottomToolView];
    toolView.frame = CGRectMake(0, CWScreenH - kBottomToolViewHeight, CWScreenW, kBottomToolViewHeight);
    [self.view addSubview:toolView];
    self.toolView = toolView;
}

- (void)setUpLoadingAnimateView {
    // 先显示一个加载视图。数据加载完成后，再显示tableview
    self.tableView.hidden = YES;
    NSURL *imgUrl = [[NSBundle mainBundle] URLForResource:@"loading_book@3x" withExtension:@"gif"];
    FLAnimatedImage *animatedImg = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:imgUrl]];
    FLAnimatedImageView *gifView = [[FLAnimatedImageView alloc] init];
    gifView.animatedImage = animatedImg;
    gifView.frame = CGRectMake(0, 0, 50, 50);
    gifView.center = CGPointMake(self.view.width * 0.5, self.view.height * 0.5 - 60);
    [self.scrollView addSubview:gifView];
    self.loadingImageView = gifView;
}

#pragma mark - 事件响应
- (void)navigationBarBackButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBarCollectButtonClick {
    NSLog(@"收藏");
}

- (void)praiseComment:(NSNotification *)notification {
    NSString *commentId = notification.userInfo[ONECommentIdKey];
    [[ONENetworkTool sharedInstance] postPraisedCommentWithType:self.typeName itemId:self.homeItem.item_id commentId:commentId success:nil failure:^(NSError *error) {
        NSLog(@"点赞失败");
    }];
}

- (void)unPraiseComment:(NSNotification *)notification {
    NSString *commentId = notification.userInfo[ONECommentIdKey];
    [[ONENetworkTool sharedInstance] postUnpraisedCommentWithType:self.typeName item_id:self.homeItem.item_id commentId:commentId success:nil failure:^(NSError *error) {
        NSLog(@"取消点赞失败");
    }];
}

#pragma mark - ONEDetailTableViewControllerDelegate
- (void)detailTableVC:(ONEDetailTableViewController *)detailTableVC updateToolViewPraiseCount:(NSInteger)praiseNum andCommentCount:(NSInteger)commentNum {
    self.toolView.praisenum = praiseNum;
    self.toolView.commentnum = commentNum;
}

- (void)detailTableVCDidFinishLoadData:(ONEDetailTableViewController *)detailTableVC {
    self.tableView.hidden = NO;
    self.loadingImageView.hidden = YES;
}

- (void)detailTableVC:(ONEDetailTableViewController *)detailTableVC UpdateTitle:(NSString *)titleString {
    if (titleString) {
        self.title = titleString;
    } else {
        self.title = self.homeItem.typeName;
    }
}

@end
