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
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 设置UI控件属性


#pragma mark - 私有工具方法


#pragma mark - 事件响应


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
