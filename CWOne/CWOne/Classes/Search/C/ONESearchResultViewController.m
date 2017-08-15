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
#import "ONENetworkTool.h"
#import "ONEDetailViewController.h"
#import "ONEHomeItem.h"
#import <MJRefresh.h>
#import "ONENavigationBarTool.h"

#define kTitleScrollViewHeight 38.0
#define kCellHeight 60
#define kUnderlineHeight 2.5
#define kTitleButtonLabelFont [UIFont systemFontOfSize:14]

#define kTitleArray @[@"图文",@"阅读",@"音乐",@"影视",@"深夜电台",@"作者/音乐人"]

static NSString *const searchResultCellId = @"searchResultCellId";

@interface ONESearchResultViewController () <UISearchBarDelegate, UITableViewDataSource ,UITableViewDelegate>

@property (weak, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) UIScrollView *titleScrollView;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIView *titleUnderlineView;
@property (weak, nonatomic) UIActivityIndicatorView *indicator;
@property (weak, nonatomic) UIImageView *noDataInfoImageView;

@property (strong, nonatomic) NSMutableArray<ONESearchResultItem *> *resultList;

@property (assign, nonatomic) UIButton *selectedButton;

@property (assign, nonatomic) NSInteger lastPage;

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

- (UIImageView *)noDataInfoImageView {
    if (!_noDataInfoImageView) {
        UIImageView *noDataInfoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_searchresult_placeholder"]];
        noDataInfoView.center = CGPointMake(self.view.width * 0.5, self.view.height * 0.5);
        [self.view addSubview:noDataInfoView];
        _noDataInfoImageView = noDataInfoView;
    }
    return _noDataInfoImageView;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = CGPointMake(self.view.width * 0.5, self.view.height * 0.5 - 50);
        indicator.hidesWhenStopped = YES;
        [self.view addSubview:indicator];
        _indicator = indicator;
    }
    return _indicator;
}
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastPage = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpNavigationBar];
    
    [self setUpTableView];
    
    [self setUpTitleScrollView];
    
    [self search];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ONENavigationBarTool sharedInstance] updateCurrentViewController:self];
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
    
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, kTitleScrollViewHeight)];
    titleScrollView.showsVerticalScrollIndicator = NO;
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.backgroundColor = [UIColor colorWithR:252 G:253 B:254];
    
    // 添加所有按钮
    for (NSInteger index = 0; index < kTitleArray.count; index ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        [button setTitle:kTitleArray[index] forState:UIControlStateNormal];
        button.titleLabel.font = kTitleButtonLabelFont;
        [button setTitleColor:[UIColor colorWithWhite:120/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *title = kTitleArray[index];
        CGFloat buttonWidth = title.length * 14 + 30;
        CGFloat buttonX = (index == 0) ? 0 : CGRectGetMaxX(titleScrollView.subviews[index-1].frame);
        button.frame = CGRectMake(buttonX, 0, buttonWidth, kTitleScrollViewHeight);
        [titleScrollView addSubview:button];
        if (index == 0) {
            button.selected = YES;
            self.selectedButton = button;
        }
    }
    // 添加下划线控件
    UIView *underlineView = [[UIView alloc] initWithFrame:CGRectMake(0, kTitleScrollViewHeight - kUnderlineHeight, 0, kUnderlineHeight)];
    underlineView.width = [self calculateUnderlineViewWidthWithTag:0];;
    underlineView.centerX = titleScrollView.subviews.firstObject.centerX;
    underlineView.backgroundColor = [UIColor blackColor];
    [titleScrollView addSubview:underlineView];
    self.titleUnderlineView = underlineView;
    
    
    titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(titleScrollView.subviews.lastObject.frame), 0);
    [self.view addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
}

- (void)setUpTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH - kNavigationBarHeight) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.contentInset = UIEdgeInsetsMake(kTitleScrollViewHeight, 0, 0, 0);
    tableView.rowHeight = kCellHeight;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(searchMore)];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONESearchResultCell class]) bundle:nil] forCellReuseIdentifier:searchResultCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


#pragma mark - 事件响应
- (void)titleButtonClick:(UIButton *)button {
    // 修改按钮选中
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    // 移动下划线，修改下划线尺寸
    [UIView animateWithDuration:0.3 animations:^{
        self.titleUnderlineView.width = [self calculateUnderlineViewWidthWithTag:button.tag];
        self.titleUnderlineView.centerX = button.centerX;
    }];
    
    // 更新界面
    [self search];
}
#pragma mark - 私有方法
- (void)search {
    [self showIndicator];
    [[ONENetworkTool sharedInstance] requestSearchResultDataWithTypeName:[self getRequestTypeName] searchText:self.searchBar.text page:0 success:^(NSArray *dataArray) {
        if (dataArray.count == 0) {
            [self.indicator stopAnimating];
            self.noDataInfoImageView.hidden = NO;
        } else {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dataDict in dataArray) {
                ONESearchResultItem *searchResultItem = [ONESearchResultItem searchResultItemWihtDict:dataDict];
                [tempArray addObject:searchResultItem];
            }
            self.resultList = tempArray;
            [self.tableView reloadData];
            [self.indicator stopAnimating];
            self.tableView.hidden = NO;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)searchMore {
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    [[ONENetworkTool sharedInstance] requestSearchResultDataWithTypeName:[self getRequestTypeName] searchText:self.searchBar.text page:self.lastPage + 1 success:^(NSArray *dataArray) {
        if (dataArray.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            NSMutableArray *array = [self.resultList mutableCopy];
            for (NSDictionary *dataDict in dataArray) {
                ONESearchResultItem *searchResultItem = [ONESearchResultItem searchResultItemWihtDict:dataDict];
                [array addObject:searchResultItem];
            }
            self.resultList = array;
            [self.tableView reloadData];
            [self.indicator stopAnimating];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:nil];
}

- (void)showIndicator {
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    self.noDataInfoImageView.hidden = YES;
    self.tableView.hidden = YES;
}

- (NSString *)getRequestTypeName {
    NSInteger index = self.selectedButton.tag;
    switch (index) {
        case 0:
            return @"hp";
        case 1:
            return @"reading";
        case 2:
            return @"music";
        case 3:
            return @"movie";
        case 4:
            return @"radio";
        case 5:
            return @"author";
        default:
            return nil;
    }
}

- (CGFloat)calculateUnderlineViewWidthWithTag:(NSInteger)tag {
    NSString *titleStr = kTitleArray[tag];
    CGFloat width = [titleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kTitleButtonLabelFont} context:nil].size.width;
    return width;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self search];
    [self.searchBar resignFirstResponder];
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
#pragma mark - UIScorllViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ONEDetailViewController *detailVC = [[ONEDetailViewController alloc] init];
    
    ONESearchResultItem *resultItem = self.resultList[indexPath.row];
    ONEHomeItem *item = [ONEHomeItem homeItemWithSearchResultItem:resultItem];
    detailVC.homeItem = item;
    
    [self.navigationController showViewController:detailVC sender:nil];
}

@end
