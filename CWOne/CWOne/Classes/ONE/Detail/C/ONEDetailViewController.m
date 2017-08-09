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
#import "NSString+CWTranslate.h"
#import "ONEDetailMovieInfoController.h"
#import "ONEDetailMusicInfoController.h"
#import <NYTPhotosViewController.h>
#import "ONERadioTool.h"

#define kBottomToolViewHeight kTabBarHeight
#define kLoadingImageHeight 50.0
#define kLoadingImageOffset 60.0

@interface ONEDetailViewController () <ONEDetailTableViewControllerDelegate, UIScrollViewDelegate, NYTPhotosViewControllerDelegate>

@property (weak, nonatomic) ONEDetailTableViewController *detailTableVC;

@property (weak, nonatomic) ONEDetailBottomToolView *toolView;

@property (strong, nonatomic, readonly) NSString *typeName;

@property (weak, nonatomic) FLAnimatedImageView *loadingImageView;

@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger serialIndex;

@end

@implementation ONEDetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.serialIndex = -1;
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ONENavigationBarTool sharedInstance] resumeNavigationBar];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)typeName {
    return [NSString getTypeStrWithType:self.homeItem.type];
}

#pragma mark - 设置UI
- (void)setUpNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_default"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarBackButtonClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"collect_gray"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarCollectButtonClick)];
    
    // 设置控制器标题
    self.title = self.homeItem.typeName;
}

- (void)setUpNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseComment:) name:ONECommentPraiseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unPraiseComment:) name:ONECommentUnpraiseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMusicDetail:) name:ONEDetailMusicInfoButtonClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMovieDetail:) name:ONEDetailMovieInfoButtonClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPhotoViewer:) name:ONEPhotoViewerShowNotification object:nil];
}

- (void)setUpScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, CWScreenW, CWScreenH);
    scrollView.contentSize = CGSizeMake(0, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setUpTableView {
    // 添加子控制器
    ONEDetailTableViewController *detailTableVC = [[ONEDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailTableVC.delegate = self;
    detailTableVC.type = self.homeItem.type;
    detailTableVC.itemId = self.homeItem.item_id;
    [self addChildViewController:detailTableVC];
    self.detailTableVC = detailTableVC;
    // 添加tableView
    detailTableVC.view.frame = self.view.bounds;
    [self.scrollView addSubview:detailTableVC.view];
    self.tableView = detailTableVC.tableView;
    
    [self tableViewLoadDataAndShowLoadingImage];
}

- (void)setUpBottomToolView {
    ONEDetailBottomToolView *toolView = [ONEDetailBottomToolView detailBottomToolView];
    toolView.frame = CGRectMake(0, CWScreenH - kBottomToolViewHeight, CWScreenW, kBottomToolViewHeight);
    [self.view addSubview:toolView];
    self.toolView = toolView;
}

- (void)setUpLoadingAnimateView {
    NSURL *imgUrl = [[NSBundle mainBundle] URLForResource:@"loading_book@3x" withExtension:@"gif"];
    FLAnimatedImage *animatedImg = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:imgUrl]];
    FLAnimatedImageView *gifView = [[FLAnimatedImageView alloc] init];
    gifView.animatedImage = animatedImg;
    gifView.frame = CGRectMake((CWScreenW - kLoadingImageHeight) * 0.5, (CWScreenH - kLoadingImageHeight) * 0.5 - 60, kLoadingImageHeight, kLoadingImageHeight);
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

- (void)showMusicDetail:(NSNotification *)notification {
    ONEDetailMusicInfoController *musicInfoVC = [[ONEDetailMusicInfoController alloc] init];
    musicInfoVC.essayItem = notification.userInfo[ONEEssayItemKey];
    [self presentViewController:musicInfoVC animated:YES completion:nil];
}

- (void)showMovieDetail:(NSNotification *)notification {
    ONEDetailMovieInfoController *movieInfoVC = [[ONEDetailMovieInfoController alloc] init];
    movieInfoVC.essayItem = notification.userInfo[ONEEssayItemKey];
    [self presentViewController:movieInfoVC animated:YES completion:nil];
}

- (void)showPhotoViewer:(NSNotification *)notification {
    NSArray *photoArray = notification.userInfo[ONEPhotoArrayKey];
    NYTPhotosViewController *photoViewerController = [[NYTPhotosViewController alloc] initWithPhotos:photoArray];
    photoViewerController.delegate = self;
    [self presentViewController:photoViewerController animated:YES completion:nil];
    [[ONENavigationBarTool sharedInstance] hideStatusBarWithAnimated:YES];
}

#pragma mark - 私有工具方法
// 取得当前文章在连载数组中的索引
- (NSInteger)getIndexOfSerial {
    for (int i = 0; i < self.homeItem.serial_list.count; i++) {
        NSString *itemId = self.homeItem.serial_list[i];
        if ([itemId isEqualToString:self.homeItem.item_id]) {
            return i;
        }
    }
    return -1;
}

- (void)updateSerial {
    // 隐藏tableView，显示loadingView
    self.loadingImageView.x = (CWScreenW - kLoadingImageHeight) * 0.5 + self.serialIndex * CWScreenW;
    [self tableViewLoadDataAndShowLoadingImage];
    
    // 加载上\下一章
    self.detailTableVC.itemId = self.homeItem.serial_list[self.serialIndex];
    self.tableView.x = CWScreenW * self.serialIndex;
    self.tableView.contentOffset = CGPointMake(0, -kNavigationBarHeight);
}

- (void)tableViewLoadDataAndShowLoadingImage {
    // 先显示一个加载视图。数据加载完成后，再显示tableview
    self.tableView.hidden = YES;
    self.loadingImageView.hidden = NO;
}

- (void)playRadio {
    if (self.homeItem.type == ONEHomeItemTypeRadio) {
//        [[ONERadioTool sharedInstance] playMusicWithUrlString:self.homeItem.audio_url completion:nil];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.serialIndex == -1) { return; }
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX > (self.serialIndex * CWScreenW + CWScreenW * 0.5)) {
        // 加载下一章
        self.serialIndex += 1;
        [self updateSerial];
    } else if (offsetX < (self.serialIndex * CWScreenW - CWScreenW * 0.5)) {
        self.serialIndex -= 1;
        [self updateSerial];
    }
}

#pragma mark - ONEDetailTableViewControllerDelegate
- (void)detailTableVC:(ONEDetailTableViewController *)detailTableVC updateToolViewPraiseCount:(NSInteger)praiseNum andCommentCount:(NSInteger)commentNum {
    self.toolView.praisenum = praiseNum;
    self.toolView.commentnum = commentNum;
}

- (void)detailTableVCDidFinishLoadData:(ONEDetailTableViewController *)detailTableVC {
    self.tableView.hidden = NO;
    self.loadingImageView.hidden = YES;
    
    [self playRadio];
    
    if (self.serialIndex == -1) {
        // 设置scrollView的contentSize，修改tableView的frame
        self.scrollView.contentSize = CGSizeMake(self.homeItem.serial_list.count * CWScreenW, 0);
        self.serialIndex = [self getIndexOfSerial];
        if (self.serialIndex == -1) { return; }
        CGFloat offsetX = self.serialIndex * CWScreenW;
        self.tableView.x = offsetX;
        self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    }
}

- (void)detailTableVC:(ONEDetailTableViewController *)detailTableVC UpdateTitle:(NSString *)titleString {
    if (titleString) {
        self.title = titleString;
    } else {
        self.title = self.homeItem.typeName;
    }
}

#pragma mark - NYTPhotosViewControllerDelegate
- (void)photosViewControllerDidDismiss:(NYTPhotosViewController *)photosViewController {
    [[ONENavigationBarTool sharedInstance] resumeStatusBarWithAnimated:YES];
}

@end
