//
//  ONEAuthorInfoController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/13.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAuthorInfoController.h"
#import "ONENavigationBarTool.h"
#import "ONENetworkTool.h"
#import "ONEUserItem.h"
#import "ONEHomeItem.h"
#import "ONEHomeCell.h"
#import "ONEHomeRadioCell.h"
#import "ONEHomeViewModel.h"
#import <MJRefresh.h>
#import "ONEAuthorHeaderInfoView.h"

static NSString *const OneHomeCellID = @"OneHomeCellID";
static NSString *const OneHomeRadioCellID = @"OneHomeRadioCellID";

#define kTitleHiddenSpace 100.0

@interface ONEAuthorInfoController ()

@property (strong, nonatomic) NSArray<ONEHomeItem *> *worksList;

@property (assign, nonatomic) NSInteger pageNumber;

@property (strong, nonatomic) ONEAuthorHeaderInfoView *headerView;

@end

@implementation ONEAuthorInfoController

#pragma mark - 懒加载
- (ONEAuthorHeaderInfoView *)headerView {
    if (!_headerView) {
        ONEAuthorHeaderInfoView *headerView = [ONEAuthorHeaderInfoView authorHeaderInfoView];
        headerView.author = self.author;
        _headerView = headerView;
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    
    [self setUpTableView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[ONENavigationBarTool sharedInstance] resumeNavigationBar];
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ONENavigationBarTool sharedInstance] changeShadowViewVisible:NO];
}

- (void)setUpTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeCell class]) bundle:nil] forCellReuseIdentifier:OneHomeCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeRadioCell class]) bundle:nil] forCellReuseIdentifier:OneHomeRadioCellID];
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ONEBackgroundColor;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreWorksData)];
    
    self.tableView.estimatedSectionHeaderHeight = 300;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)setUpNavigationBar {
    [[ONENavigationBarTool sharedInstance] changeShadowViewVisible:YES];
    
    self.title = self.author.user_name;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_default"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarBackButtonClick)];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)loadData {
    // 加载作者作品信息
    [[ONENetworkTool sharedInstance] requestAuthorWorksListDataWithAuthorId:self.author.user_id pageNumber:0 success:^(NSArray *dataArray) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *workDict in dataArray) {
            ONEHomeItem *homeItem = [ONEHomeItem homeItemWithDict:workDict];
            [tempArray addObject:homeItem];
        }
        self.worksList = tempArray;
        [self.tableView reloadData];
        self.pageNumber += 1;
    } failure:nil];
}

- (void)loadMoreWorksData {
    NSString *pageNumber = [NSString stringWithFormat:@"%ld",self.pageNumber];
    [[ONENetworkTool sharedInstance] requestAuthorWorksListDataWithAuthorId:self.author.user_id pageNumber:pageNumber success:^(NSArray *dataArray) {
        if (dataArray.count != 0) {
            NSMutableArray *tempArray = [self.worksList mutableCopy];
            for (NSDictionary *workDict in dataArray) {
                ONEHomeItem *homeItem = [ONEHomeItem homeItemWithDict:workDict];
                [tempArray addObject:homeItem];
            }
            self.worksList = tempArray;
            [self.tableView reloadData];
            self.pageNumber += 1;
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:nil];
}

#pragma mark - 事件响应
- (void)navigationBarBackButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.worksList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ONEHomeItem *item = self.worksList[indexPath.row];
    
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
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= kTitleHiddenSpace) {
        self.title = self.author.user_name;
    } else {
        self.title = nil;
    }
    
    CGFloat alpha = offsetY/kTitleHiddenSpace;
    [[ONENavigationBarTool sharedInstance] changeAlphaOfBackgroundAndShadow:alpha];
}
@end
