//
//  ONESearchResultViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/14.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONESearchResultViewController.h"
#import "UIImage+CWColorAndStretch.h"
#import "ONESearchResultCell.h"
#import "ONESearchResultItem.h"

#define kTitleScrollViewHeight 35.0

static NSString *const searchResultCellId = @"searchResultCellId";

@interface ONESearchResultViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (weak, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) UIScrollView *titleScrollView;
@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<ONESearchResultItem *> *resultList;

@end

@implementation ONESearchResultViewController

#pragma mark - 懒加载
- (NSMutableArray *)resultList {
    if (!_resultList) {
        NSMutableArray *resultList = [NSMutableArray array];
        _resultList = resultList;
    }
    return _resultList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpNavigationBar];
    
    [self setUpTableView];
    
    [self setUpTitleScrollView];
    
    [self search];
    
}

#pragma mark - 初始化
- (void)setUpNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, 44)];
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.text = self.searchText;
    searchBar.showsCancelButton = YES;
    searchBar.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = searchBar;
    
    self.searchBar = searchBar;
}
- (void)setUpTitleScrollView {
    NSArray<NSString *> *titles = @[@"图文",@"阅读",@"音乐",@"影视",@"深夜电台",@"作者/音乐人"];
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, kTitleScrollViewHeight)];
    titleScrollView.showsVerticalScrollIndicator = NO;
    titleScrollView.showsHorizontalScrollIndicator = NO;
    
    for (NSInteger index = 0; index < titles.count; index ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        [button setTitle:titles[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor colorWithWhite:120/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonWidth = titles[index].length * 14 + 30;
        CGFloat buttonX = (index == 0) ? 0 : CGRectGetMaxX(titleScrollView.subviews[index-1].frame);
        button.frame = CGRectMake(buttonX, 0, buttonWidth, kTitleScrollViewHeight);
        [titleScrollView addSubview:button];
        if (index == 0) {
            button.selected = YES;
        }
    }
    
    titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(titleScrollView.subviews.lastObject.frame), 0);
    [self.view addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
}

- (void)setUpTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH - kNavigationBarHeight) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONESearchResultCell class]) bundle:nil] forCellReuseIdentifier:searchResultCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)search {
    
}
#pragma mark - 事件响应
- (void)titleButtonClick:(UIButton *)button {
    // 修改按钮选中
    
    // 移动下划线，修改下划线尺寸
    
    // 更新界面
}
#pragma mark - 私有方法
- (void)reSearch {
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ONESearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultCellId forIndexPath:indexPath];
    
    ONESearchResultItem *searchResultItem = self.resultList[indexPath.row];
    cell.searchResultItem = searchResultItem;
    
    return cell;
}

@end
