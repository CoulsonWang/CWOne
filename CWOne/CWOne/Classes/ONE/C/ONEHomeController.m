//
//  ONEHomeController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeController.h"
#import "ONEHomeNavigationBarTitleView.h"
#import "ONENetworkTool.h"
#import "ONEHomeItem.h"
#import "ONEHomeCell.h"
#import "ONEHomeViewModel.h"

static NSString *const cellID = @"OneHomeCellID";

@interface ONEHomeController ()

@property (strong, nonatomic) NSArray *homeItems;

@end

@implementation ONEHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBarItem];
    
    [self loadData];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - 设置UI控件属性
- (void)setUpNavigationBarItem {
    self.navigationItem.titleView = [ONEHomeNavigationBarTitleView homeNavTitleView];
    
    UIButton *searchButton = [[UIButton alloc] init];
    [searchButton setImage:[UIImage imageNamed:@"search_gray"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"search_dark"] forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(searchButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [searchButton sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

#pragma mark - 私有工具方法
- (void)loadData {
    [[ONENetworkTool sharedInstance] requestHomeDataWithDate:nil success:^(NSDictionary *dataDict) {
        
        NSArray<NSDictionary *> *contentList = dataDict[@"content_list"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in contentList) {
            ONEHomeItem *item = [ONEHomeItem homeItemWithDict:dict];
            [tempArray addObject:item];
        }
        self.homeItems = tempArray;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 事件响应
- (void)searchButtonDidClick {
    NSLog(@"点击了右侧搜索按钮");
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
