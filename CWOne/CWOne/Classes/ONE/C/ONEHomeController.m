//
//  ONEHomeController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeController.h"
#import "ONENetworkTool.h"
#import "ONEHomeItem.h"
#import "ONEHomeBaseCell.h"
#import "ONEHomeViewModel.h"
#import "ONEMainTabBarController.h"
#import "ONEHomeNavigationController.h"
#import <MJRefresh.h>
#import "ONEHomeCell.h"
#import "ONEHomeRadioCell.h"
#import "ONEHomeHeaderView.h"
#import "ONEHomeMenuItem.h"

static NSString *const OneHomeCellID = @"OneHomeCellID";
static NSString *const OneHomeRadioCellID = @"OneHomeRadioCellID";

@interface ONEHomeController ()

@property (strong, nonatomic) NSArray *homeItems;

@property (strong, nonatomic) ONEHomeMenuItem *menuItem;

@property (weak, nonatomic) ONEHomeHeaderView *headerView;

@end

@implementation ONEHomeController

#pragma mark - 懒加载
- (NSArray *)homeItems {
    if (!_homeItems) {
        ONEMainTabBarController *tabBarVC = (ONEMainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        _homeItems = tabBarVC.homeItems;
    }
    return _homeItems;
}

- (ONEHomeMenuItem *)menuItem {
    if (!_menuItem) {
        ONEMainTabBarController *tabBarVC = (ONEMainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        _menuItem = tabBarVC.menuItem;
    }
    return _menuItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
}

#pragma mark - 设置UI控件属性
- (void)setUpTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeCell class]) bundle:nil] forCellReuseIdentifier:OneHomeCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeRadioCell class]) bundle:nil] forCellReuseIdentifier:OneHomeRadioCellID];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ONEBackgroundColor;
    
    // 设置下拉刷新控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadHomeData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.backgroundColor = ONEBackgroundColor;
    self.tableView.mj_header = header;
    
    // 设置尾部footer
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.height = 200;
    [footerButton setImage:[UIImage imageNamed:@"feedsBottomPlaceHolder"] forState:UIControlStateNormal];
    [footerButton addTarget:self action:@selector(footerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = footerButton;
    
    // 设置顶部view
    ONEHomeHeaderView *headerView = [ONEHomeHeaderView homeHeaderViewWithHeaderViewModel:[ONEHomeViewModel viewModelWithItem:self.homeItems.firstObject] menuItem:self.menuItem];
    __weak typeof(self) weakSelf = self;
    headerView.reload = ^{
        [weakSelf.tableView reloadData];
    };
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
}

#pragma mark - 私有工具方法
- (void)reloadHomeData {
    [[ONENetworkTool sharedInstance] requestHomeDataWithDate:nil success:^(NSDictionary *dataDict) {
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
        // 刷新tableView数据
        [self.tableView reloadData];
        // 刷新headerView数据
        self.headerView.menuItem = menuItem;
        self.headerView.viewModel = [ONEHomeViewModel viewModelWithItem:tempArray.firstObject];
        
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@",error);
    }];
}

#pragma mark - 事件响应
- (void)footerButtonClick {
    // 切换到上一天
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    // 通知NavigationController更新视图
    ONEHomeNavigationController *navVC = (ONEHomeNavigationController *)self.parentViewController;
    [navVC updateTitleViewWithOffset:offsetY];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    ONEHomeNavigationController *navVC = (ONEHomeNavigationController *)self.parentViewController;
    [navVC confirmTitlViewWithOffset:offsetY];
}

@end
