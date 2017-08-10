//
//  ONEHomeViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/4.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeViewController.h"
#import "ONEHomeTableViewController.h"
#import "ONEDateTool.h"
#import "ONENavigationBarTool.h"
#import "ONEHomeCoverTransitionTool.h"
#import "ONEHomeCoverImagePresentationController.h"
#import "ONEHomeDiaryViewController.h"
#import <FLAnimatedImage.h>
#import "ONEHomeFeedsViewController.h"

#define kChangePageAnimateDuration 0.3
#define kBackToTodatAnimateDuration 0.4
#define kLoadingImageHeight 50

typedef enum : NSUInteger {
    ONESrollDiretionLeft,
    ONESrollDiretionRight,
} ONESrollDiretion;

@interface ONEHomeViewController () <UIScrollViewDelegate, ONEHomeTableViewControllerDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) FLAnimatedImageView *loadingImageView;

@property (weak, nonatomic) ONEHomeTableViewController *leftVC;
@property (weak, nonatomic) ONEHomeTableViewController *middleVC;
@property (weak, nonatomic) ONEHomeTableViewController *rightVC;

@property (weak, nonatomic) UITableView *leftTableView;
@property (weak, nonatomic) UITableView *middleTableView;
@property (weak, nonatomic) UITableView *rightTableView;

@property (weak, nonatomic) ONEHomeTableViewController *currentVC;
@property (assign, nonatomic) NSInteger lastIndex;

@property (weak, nonatomic) ONEHomeFeedsViewController *feedsVC;
@property (weak, nonatomic) UIView *feedsView;
@end

@implementation ONEHomeViewController
#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH)];
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (ONEHomeTableViewController *)leftVC {
    if (!_leftVC) {
        ONEHomeTableViewController *leftTableVC = [[ONEHomeTableViewController alloc] init];
        leftTableVC.delegate = self;
        self.leftVC = leftTableVC;
        [self addChildViewController:leftTableVC];
        _leftVC = leftTableVC;
    }
    return _leftVC;
}
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        UITableView *leftTableView = self.leftVC.tableView;
        leftTableView.frame = CGRectMake(0, 0, CWScreenW, CWScreenH);
        [self.scrollView addSubview:leftTableView];
        _leftTableView = leftTableView;
    }
    return _leftTableView;
}
- (ONEHomeTableViewController *)middleVC {
    if (!_middleVC) {
        ONEHomeTableViewController *middleTableVC = [[ONEHomeTableViewController alloc] init];
        middleTableVC.delegate = self;
        self.middleVC = middleTableVC;
        [self addChildViewController:middleTableVC];
        _middleVC = middleTableVC;
    }
    return _middleVC;
}
- (UITableView *)middleTableView {
    if (!_middleTableView) {
        UITableView *middleTableView = self.middleVC.tableView;
        middleTableView.frame = CGRectMake(0, 0, CWScreenW, CWScreenH);
        [self.scrollView addSubview:middleTableView];
        _middleTableView = middleTableView;
    }
    return _middleTableView;
}
- (ONEHomeTableViewController *)rightVC {
    if (!_rightVC) {
        ONEHomeTableViewController *rightTableVC = [[ONEHomeTableViewController alloc] init];
        rightTableVC.delegate = self;
        self.rightVC = rightTableVC;
        [self addChildViewController:rightTableVC];
        _rightVC = rightTableVC;
    }
    return _rightVC;
}
- (UITableView *)rightTableView {
    if (!_rightTableView) {
        UITableView *rightTableView = self.rightVC.tableView;
        rightTableView.frame = CGRectMake(0, 0, CWScreenW, CWScreenH);
        [self.scrollView addSubview:rightTableView];
        _rightTableView = rightTableView;
    }
    return _rightTableView;
}

- (ONEHomeFeedsViewController *)feedsVC {
    if (!_feedsVC) {
        ONEHomeFeedsViewController *feedsVC = [[ONEHomeFeedsViewController alloc] init];
        [self addChildViewController:feedsVC];
        _feedsVC = feedsVC;
    }
    return _feedsVC;
}

- (UIView *)feedsView {
    if (!_feedsView) {
        UIView *feedsView = self.feedsVC.view;
        feedsView.frame = CGRectMake(0, -CWScreenH, CWScreenW, CWScreenH);
        [self.view addSubview:feedsView];
        _feedsView = feedsView;
    }
    return _feedsView;
}

#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpScrollView];
    
    [self setUpTableViews];
    
    [self setUpLoadingAnimateView];
    
    [self setUpNotification];
    
    // 初始参数
    self.lastIndex = 0;
    self.currentVC = self.middleVC;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[ONENavigationBarTool sharedInstance] showCustomTitleView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[ONENavigationBarTool sharedInstance] hideCustomTitleView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化控件
- (void)setUpScrollView {
    UIScrollView *scrollV = self.scrollView;
    scrollV.contentSize = CGSizeMake(MAXFLOAT, 0);
    scrollV.backgroundColor = [UIColor colorWithR:239 G:239 B:243];
    scrollV.pagingEnabled = YES;
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.contentOffset = CGPointMake(0, 0);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    scrollV.delegate = self;
}

- (void)setUpTableViews {
    self.leftTableView.x = CWScreenW * 2;
    
    self.middleTableView.x = 0;
    self.middleVC.dateStr = kCurrentDateString;
    
    self.rightTableView.x = CWScreenW;
    self.rightVC.dateStr = [[ONEDateTool sharedInstance] yesterdayDateStr];
}

- (void)setUpLoadingAnimateView {
    NSURL *imgUrl = [[NSBundle mainBundle] URLForResource:@"loading_gray@2x" withExtension:@"gif"];
    FLAnimatedImage *animatedImg = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:imgUrl]];
    FLAnimatedImageView *gifView = [[FLAnimatedImageView alloc] init];
    gifView.animatedImage = animatedImg;
    gifView.frame = CGRectMake((CWScreenW - kLoadingImageHeight) * 0.5, (CWScreenH - kLoadingImageHeight) * 0.5 - 60, kLoadingImageHeight, kLoadingImageHeight);
    gifView.hidden = YES;
    [self.scrollView addSubview:gifView];
    self.loadingImageView = gifView;
}

- (void)setUpNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleViewBackToTodayButtonClick) name:ONETitleViewBackToTodayButtonClickNotifcation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentCoverImageViewWithCustomModal:) name:ONEHomeCoverImageDidClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentDiaryViewController:) name:ONEHomeDiaryButtonDidClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentFeedsViewController:) name:ONETitleViewFeedsUnFoldNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissFeedsViewController) name:ONETitleViewFeedsFoldNotification object:nil];
}

#pragma mark - 事件响应
- (void)titleViewBackToTodayButtonClick {
    [UIView animateWithDuration:kBackToTodatAnimateDuration animations:^{
        self.scrollView.contentOffset = CGPointZero;
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

- (void)presentCoverImageViewWithCustomModal:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    ONEHomeCoverTransitionTool *transitionTool = [ONEHomeCoverTransitionTool sharedInstance];
    transitionTool.presentImage = userInfo[ONECoverPresentationImageKey];
    transitionTool.orientation = ([userInfo[ONECoverPresentationImageOrientationKey] integerValue] == 0) ? ONECoverImageOrientationHorizontal : ONECoverImageOrientationVertical;
    transitionTool.subTitleString = userInfo[ONECoverPresentationSubTitleKey];
    transitionTool.volumeString = userInfo[ONECoverPresentationSerialStringKey];
    transitionTool.originFrame = [userInfo[ONECoverPresentationOriginFrameKey] CGRectValue];
    
    ONEHomeCoverImagePresentationController *coverPresentVC = [[ONEHomeCoverImagePresentationController alloc] init];
    coverPresentVC.modalPresentationStyle = UIModalPresentationCustom;
    coverPresentVC.transitioningDelegate = transitionTool;
    
    [self presentViewController:coverPresentVC animated:YES completion:nil];
}

- (void)presentDiaryViewController:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    ONEHomeDiaryViewController *diaryVC = [[ONEHomeDiaryViewController alloc] init];
    diaryVC.coverImage = userInfo[ONECoverPresentationImageKey];
    diaryVC.orientation = userInfo[ONECoverPresentationImageOrientationKey];
    diaryVC.subTitleString = userInfo[ONECoverPresentationSubTitleKey];
    diaryVC.authorInfoString = userInfo[ONEDiaryPresentationAuthorInfoKey];
    diaryVC.contentString = userInfo[ONEDiaryPresentationContentKey];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:diaryVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - 处理标题的展开或收起
- (void)presentFeedsViewController:(NSNotification *)notification {
    self.tabBarController.tabBar.hidden = YES;
    self.feedsVC.dateString = notification.userInfo[ONEDateStringKey];
    [UIView animateWithDuration:0.3 animations:^{
        self.feedsView.y = 0;
    }];
}

- (void)dismissFeedsViewController {
    self.tabBarController.tabBar.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.feedsView.y = -CWScreenH;
    }];
}

#pragma mark - 私有工具方法
// 确定哪个控制器需要移动
- (ONEHomeTableViewController *)getTheControllerNeedToMoveWithDirection:(ONESrollDiretion)direction {
    if (self.currentVC == self.middleVC) {
        if (direction == ONESrollDiretionLeft) {
            return self.rightVC;
        } else {
            return self.leftVC;
        }
    } else if (self.currentVC == self.leftVC) {
        if (direction == ONESrollDiretionLeft) {
            return self.middleVC;
        } else {
            return self.rightVC;
        }
    } else {
        if (direction == ONESrollDiretionLeft) {
            return self.leftVC;
        } else {
            return self.middleVC;
        }
    }
}
// 更新当前的控制器
- (void)updateCurrentVCWithDirection:(ONESrollDiretion)direction {
    if (self.currentVC == self.middleVC) {
        if (direction == ONESrollDiretionLeft) {
            self.currentVC = self.leftVC;
        } else {
            self.currentVC = self.rightVC;
        }
    } else if (self.currentVC == self.leftVC) {
        if (direction == ONESrollDiretionLeft) {
            self.currentVC = self.rightVC;
        } else {
            self.currentVC = self.middleVC;
        }
    } else {
        if (direction == ONESrollDiretionLeft) {
            self.currentVC = self.middleVC;
        } else {
            self.currentVC = self.leftVC;
        }
    }
}

// 移动一页
- (void)singleMoveWithDirection:(ONESrollDiretion)direction toIndex:(NSInteger)index{
    ONEHomeTableViewController *moveVC = [self getTheControllerNeedToMoveWithDirection:direction];
    NSInteger newIndex = (direction == ONESrollDiretionRight) ? index + 1 : index - 1;
    moveVC.dateStr = [[ONEDateTool sharedInstance] getDateStringFromCurrentDateWihtDateInterval:newIndex];
    moveVC.tableView.x = newIndex * CWScreenW;
    self.lastIndex = index;
    [self updateCurrentVCWithDirection:direction];
}

// 更新navigationBar的状态
- (void)refreshTitleViewWithOffset:(CGFloat)offset {
    [[ONENavigationBarTool sharedInstance] confirmTitlViewWithOffset:offset];
}
// 更新navigationBar上返回按钮的可视性
- (void)updateNavBarBackButtonVisible:(BOOL)isHidden {
    [[ONENavigationBarTool sharedInstance] updateTitleViewBackToTodayButtonVisible:isHidden];
}

// 更新navigationBar上的日期文本
- (void)updateNavBarDateTextWithDateString:(NSString *)dateString {
    [[ONENavigationBarTool sharedInstance] updateTitleViewDateStringWithDateString:dateString];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / CWScreenW;
    
    // 仅移动了一页时的处理
    if (index == _lastIndex + 1) {
        [self singleMoveWithDirection:ONESrollDiretionRight toIndex:index];
    } else if (index == _lastIndex - 1) {
        if (index != 0) {
            [self singleMoveWithDirection:ONESrollDiretionLeft toIndex:index];
        } else {
            self.lastIndex = index;
            [self updateCurrentVCWithDirection:ONESrollDiretionLeft];
        }
    } else if (index == _lastIndex) {
        return;
    } else {
        // 移动了大于一页时的处理,更新三个tableView的位置和数据
        self.loadingImageView.x = (CWScreenW - kLoadingImageHeight) * 0.5 + CWScreenW * index;
        self.loadingImageView.hidden = NO;
        [self.middleVC setDateStr:[[ONEDateTool sharedInstance] getDateStringFromCurrentDateWihtDateInterval:index] withCompletion:^{
            self.loadingImageView.hidden = YES;
            self.middleTableView.x = index * CWScreenW;
        }];
        [self.rightVC setDateStr:[[ONEDateTool sharedInstance] getDateStringFromCurrentDateWihtDateInterval:index + 1] withCompletion:^{
            self.rightTableView.x = (index + 1) * CWScreenW;
        }];
        if (index != 0) {
            [self.leftVC setDateStr:[[ONEDateTool sharedInstance] getDateStringFromCurrentDateWihtDateInterval:index - 1] withCompletion:^{
                self.leftTableView.x = (index - 1) * CWScreenW;
            }];
        }
        self.lastIndex = index;
        self.currentVC = self.middleVC;
    }
    [self refreshTitleViewWithOffset:self.currentVC.tableView.contentOffset.y];
    
    BOOL backButtonIsHidden = (index <= 1);
    [self updateNavBarBackButtonVisible:backButtonIsHidden];
    [self updateNavBarDateTextWithDateString:[[ONEDateTool sharedInstance] getDateStringFromCurrentDateWihtDateInterval:index]];
}

#pragma mark - ONEHomeTableViewControllerDelegate
- (void)homeTableViewFooterButtonClick:(ONEHomeTableViewController *)homeTableViewController {
    CGFloat currentOffsetX = self.scrollView.contentOffset.x;
    [UIView animateWithDuration:kChangePageAnimateDuration animations:^{
        self.scrollView.contentOffset = CGPointMake(currentOffsetX + CWScreenW, 0);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
    
}

@end
