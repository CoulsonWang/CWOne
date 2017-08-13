//
//  ONEHomeController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeTableViewController.h"
#import "ONENetworkTool.h"
#import "ONEHomeItem.h"
#import "ONEHomeBaseCell.h"
#import "ONEHomeViewModel.h"
#import "ONENavigationBarTool.h"
#import "ONEMainTabBarController.h"
#import <MJRefresh.h>
#import "ONEHomeCell.h"
#import "ONEHomeRadioCell.h"
#import "ONEHomeHeaderView.h"
#import "ONEHomeMenuItem.h"
#import "ONEDetailViewController.h"

#define kTabBarHideAnimationDuration 0.25

static NSString *const OneHomeCellID = @"OneHomeCellID";
static NSString *const OneHomeRadioCellID = @"OneHomeRadioCellID";

@interface ONEHomeTableViewController ()

@property (strong, nonatomic) NSArray<ONEHomeItem *> *homeItems;

@property (strong, nonatomic) ONEHomeMenuItem *menuItem;

@property (weak, nonatomic) ONEHomeHeaderView *headerView;

@end

@implementation ONEHomeTableViewController

- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;
    [self reloadDataWithCompletion:nil];
    self.tableView.contentOffset = CGPointMake(0, -kNavigationBarHeight);
}
#pragma mark - 对外公有方法
- (void)setDateStr:(NSString *)dateStr withCompletion:(void (^)())completion {
    _dateStr = dateStr;
    
    [self reloadDataWithCompletion:completion];
    self.tableView.contentOffset = CGPointMake(0, -kNavigationBarHeight);
}

#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpOnce];
    
    [self reloadDataWithCompletion:nil];
    
    [self setUpNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 设置UI控件属性
- (void)setUpOnce {
    // 初始化TableView
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeCell class]) bundle:nil] forCellReuseIdentifier:OneHomeCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeRadioCell class]) bundle:nil] forCellReuseIdentifier:OneHomeRadioCellID];
    
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ONEBackgroundColor;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, kTabBarHeight, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置下拉刷新控件
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf reloadDataWithCompletion:nil];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.backgroundColor = ONEBackgroundColor;
    self.tableView.mj_header = header;
    
    // 设置尾部footer
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.height = 200;
    [footerButton setImage:[UIImage imageNamed:@"feedsBottomPlaceHolder"] forState:UIControlStateNormal];
    [footerButton addTarget:self action:@selector(footerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerButton;

}

- (void)setUpHeaderView {
    // 设置顶部view
    ONEHomeHeaderView *headerView = [ONEHomeHeaderView homeHeaderViewWithHeaderViewModel:[ONEHomeViewModel viewModelWithItem:self.homeItems.firstObject] menuItem:self.menuItem];
    __weak typeof(self) weakSelf = self;
    headerView.reload = ^{
        [weakSelf.tableView reloadData];
    };
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
}

- (void)setUpNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHomeDetailVC:) name:ONEHomeShowDetailViaCatalogueNotification object:nil];
}

#pragma mark - 私有工具方法
// 刷新数据
- (void)reloadDataWithCompletion:(void(^)())completion{
    if (self.dateStr == nil) {
        return;
    }
    // 如果是今天，不需要再从网络获取，直接获取缓存好的数据
    if ([self.dateStr isEqualToString:kCurrentDateString]) {
        ONEMainTabBarController *tabBarVc = (ONEMainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        self.homeItems = tabBarVc.homeItems;
        self.menuItem = tabBarVc.menuItem;
        self.headerView.viewModel = [ONEHomeViewModel viewModelWithItem:tabBarVc.homeItems.firstObject];
        self.headerView.menuItem = tabBarVc.menuItem;
        if (completion) {
            completion();
        }
        [self refreshTableView];
        return;
    }
    
    [[ONENetworkTool sharedInstance] requestHomeDataWithDate:self.dateStr success:^(NSDictionary *dataDict) {
        NSDictionary *menuDict = dataDict[@"menu"];
        ONEHomeMenuItem *menuItem = [ONEHomeMenuItem menuItemWithDict:menuDict];
        
        NSArray<NSDictionary *> *contentList = dataDict[@"content_list"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in contentList) {
            ONEHomeItem *item = [ONEHomeItem homeItemWithDict:dict];
            [tempArray addObject:item];
        }
        self.homeItems = tempArray;
        self.menuItem = menuItem;
        self.headerView.viewModel = [ONEHomeViewModel viewModelWithItem:tempArray.firstObject];
        self.headerView.menuItem = menuItem;
        if (completion) {
            completion();
        }
        [self refreshTableView];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@",error);
    }];
}

- (void)refreshTableView {
    [self.tableView.mj_header endRefreshing];
    [self setUpHeaderView];
    [self.tableView reloadData];
}

#pragma mark - 事件响应
- (void)footerButtonClick {
    // 切换到上一天
    if ([self.delegate respondsToSelector:@selector(homeTableViewFooterButtonClick:)]) {
        [self.delegate homeTableViewFooterButtonClick:self];
    }
}

- (void)showHomeDetailVC:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    ONEHomeMenuItem *menuItem = userInfo[ONEMenuItemKey];
    if (menuItem != self.menuItem) { return; }
    NSInteger index = [userInfo[ONEIndexKey] integerValue];
    ONEDetailViewController *detailVC = [[ONEDetailViewController alloc] init];
    ONEHomeItem *item = self.homeItems[index + 1];
    detailVC.homeItem = item;
    
    [self.navigationController showViewController:detailVC sender:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeItems.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // 取到模型
    ONEHomeItem *item = self.homeItems[indexPath.row + 1];
    
    NSString *reuseIdentifier;
    // 根据模型类型创建对应的cell
    switch (item.type) {
        case ONEHomeItemTypeRadio:
        {
            reuseIdentifier = OneHomeRadioCellID;
        }
            break;
        default:
        {
            reuseIdentifier = OneHomeCellID;
        }
            break;
    }
    ONEHomeBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.viewModel = [ONEHomeViewModel viewModelWithItem:item];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ONEDetailViewController *detailVC = [[ONEDetailViewController alloc] init];
    
    ONEHomeItem *item = self.homeItems[indexPath.row + 1];
    detailVC.homeItem = item;
    
    [self.navigationController showViewController:detailVC sender:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateTitleViewWithOffsetY:scrollView.contentOffset.y confirm:NO];
    
    // 修改TabBar的alpha
    [UIView animateWithDuration:kTabBarHideAnimationDuration animations:^{
        self.tabBarController.tabBar.alpha = (scrollView.contentOffset.y <= -kNavigationBarHeight) ? 0 : 1;
    }];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self updateTitleViewWithOffsetY:scrollView.contentOffset.y confirm:YES];
}

// 通知NavigationController更新视图
- (void)updateTitleViewWithOffsetY:(CGFloat)offsetY confirm:(BOOL)isConfirm;{
    
    if (isConfirm) {
        [[ONENavigationBarTool sharedInstance] confirmTitlViewWithOffset:offsetY];
    } else {
        [[ONENavigationBarTool sharedInstance] updateTitleViewWithOffset:offsetY];
    }
    
}

@end
