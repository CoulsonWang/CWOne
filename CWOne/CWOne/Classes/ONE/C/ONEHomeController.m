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
#import "ONEHomeCell.h"
#import "ONEHomeViewModel.h"
#import "ONEMainTabBarController.h"
#import <MJRefresh.h>

static NSString *const cellID = @"OneHomeCellID";

@interface ONEHomeController ()

@property (strong, nonatomic) NSArray *homeItems;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
}

#pragma mark - 设置UI控件属性
- (void)setUpTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeCell class]) bundle:nil] forCellReuseIdentifier:cellID];
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
}

#pragma mark - 私有工具方法
- (void)reloadHomeData {
    [[ONENetworkTool sharedInstance] requestHomeDataWithDate:nil success:^(NSDictionary *dataDict) {
        NSArray<NSDictionary *> *contentList = dataDict[@"content_list"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in contentList) {
            ONEHomeItem *item = [ONEHomeItem homeItemWithDict:dict];
            [tempArray addObject:item];
        }
        self.homeItems = tempArray;
        [self.tableView reloadData];
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
    return self.homeItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ONEHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    ONEHomeViewModel *viewModel = [ONEHomeViewModel viewModelWithItem:self.homeItems[indexPath.row]];
    cell.viewModel = viewModel;
    
    return cell;
    
}

@end
