//
//  ONEHomeViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/4.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeViewController.h"
#import "ONEHomeTableViewController.h"

@interface ONEHomeViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) ONEHomeTableViewController *leftVC;
@property (weak, nonatomic) ONEHomeTableViewController *middleVC;
@property (weak, nonatomic) ONEHomeTableViewController *rightVC;

@property (weak, nonatomic) UITableView *leftTableView;
@property (weak, nonatomic) UITableView *middleTableView;
@property (weak, nonatomic) UITableView *rightTableView;

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
        self.leftVC = leftTableVC;
        [self addChildViewController:leftTableVC];
        _leftVC = leftTableVC;
    }
    return _leftVC;
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        UITableView *leftTableView = self.leftVC.tableView;
        [self.scrollView addSubview:leftTableView];
        _leftTableView = leftTableView;
    }
    return _leftTableView;
}

- (ONEHomeTableViewController *)middleVC {
    if (!_middleVC) {
        ONEHomeTableViewController *middleTableVC = [[ONEHomeTableViewController alloc] init];
        self.middleVC = middleTableVC;
        [self addChildViewController:middleTableVC];
        _middleVC = middleTableVC;
    }
    return _middleVC;
}
- (UITableView *)middleTableView {
    if (!_middleTableView) {
        UITableView *middleTableView = self.middleVC.tableView;
        [self.scrollView addSubview:middleTableView];
        _middleTableView = middleTableView;
    }
    return _middleTableView;
}
- (ONEHomeTableViewController *)rightVC {
    if (!_rightVC) {
        ONEHomeTableViewController *rightTableVC = [[ONEHomeTableViewController alloc] init];
        self.rightVC = rightTableVC;
        [self addChildViewController:rightTableVC];
        _rightVC = rightTableVC;
    }
    return _rightVC;
}
- (UITableView *)rightTableView {
    if (!_rightTableView) {
        UITableView *rightTableView = self.rightVC.tableView;
        [self.scrollView addSubview:rightTableView];
        _rightTableView = rightTableView;
    }
    return _rightTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpScrollView];
    
    self.middleTableView.frame = CGRectMake(0, 0, CWScreenW, CWScreenH);
    
    self.rightTableView.frame = CGRectMake(CWScreenW, 0, CWScreenW, CWScreenH);
    self.rightVC.date = @"2017-08-03";
    
}



#pragma mark - 初始化控件
- (void)setUpScrollView {
    UIScrollView *scrollV = self.scrollView;
    scrollV.contentSize = CGSizeMake(CWScreenW * 3, 0);
    scrollV.backgroundColor = [UIColor colorWithR:239 G:239 B:243];
    scrollV.pagingEnabled = YES;
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.contentOffset = CGPointMake(0, 0);
    
    scrollV.delegate = self;
}



@end
