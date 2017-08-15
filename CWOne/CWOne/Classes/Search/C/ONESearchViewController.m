//
//  ONESearchViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/14.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONESearchViewController.h"
#import "UIImage+CWColorAndStretch.h"
#import "ONESearchTool.h"

@interface ONESearchViewController () <UISearchBarDelegate>

@property (weak, nonatomic) UISearchBar *searchBar;

@end

@implementation ONESearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpNavigationBar];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - 初始化
- (void)setUpNavigationBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, 44)];
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"在这里写下你想寻找的";
    searchBar.showsCancelButton = YES;
    searchBar.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = searchBar;
    
    self.searchBar = searchBar;
}
#pragma mark - 事件响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}
- (IBAction)imgAndArticleButtonClick:(UIButton *)sender {
}
- (IBAction)questionButtonClick:(UIButton *)sender {
}
- (IBAction)essayButtonClick:(UIButton *)sender {
}
- (IBAction)serialButtonClick:(id)sender {
}
- (IBAction)movieButtonClick:(UIButton *)sender {
}
- (IBAction)musicButtonClick:(UIButton *)sender {
}
- (IBAction)radioButtonClick:(UIButton *)sender {
}


#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    [self.searchBar resignFirstResponder];
    // 重新modal搜索结果控制器
    [self dismissViewControllerAnimated:NO completion:nil];
    [[ONESearchTool sharedInstance] presentSearchResultViewControllerWithSearchText:searchText];
}
@end
