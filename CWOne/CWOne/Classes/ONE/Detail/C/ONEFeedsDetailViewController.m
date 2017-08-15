//
//  ONEFeedsDetailViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/15.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEFeedsDetailViewController.h"
#import "ONENetworkTool.h"
#import "ONEHomeItem.h"
#import "ONEHomeViewModel.h"
#import "ONEHomeWeatherItem.h"
#import "ONEHomeHeadContentView.h"
#import "UIImage+Render.h"
#import "ONEShareTool.h"
#import "ONEHomeNavigationBarTitleTextView.h"

@interface ONEFeedsDetailViewController ()

@property (strong, nonatomic) ONEHomeViewModel *viewModel;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) ONEHomeHeadContentView *contentView;

@end

@implementation ONEFeedsDetailViewController
#pragma mark - 懒加载
- (ONEHomeHeadContentView *)contentView {
    if (!_contentView) {
        ONEHomeHeadContentView *contentView = [ONEHomeHeadContentView headContentView];
        contentView.frame = CGRectMake(0, 0, CWScreenW, contentView.headContentViewHeight);
        [contentView hideSeperatorView];
        [self.scrollView addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (void)setViewModel:(ONEHomeViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.contentView.viewModel = viewModel;
    self.contentView.height = self.contentView.headContentViewHeight;
    CGFloat contentSizeHeight = (self.contentView.headContentViewHeight > CWScreenH) ? self.contentView.headContentViewHeight : CWScreenH;
    self.scrollView.contentSize = CGSizeMake(0, contentSizeHeight + 20);
    
    ONEHomeNavigationBarTitleTextView *textView = [[ONEHomeNavigationBarTitleTextView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW * 0.5, 44)];
    textView.dateString = viewModel.homeItem.weather.date;
    self.navigationItem.titleView = textView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpScrollView];
    
    [self setUpNavigationBar];
    
    [self loadData];
}

- (void)setUpScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setUpNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"back_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"share_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClick)];
    
}

#pragma mark - 私有方法
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonClick {
    [[ONEShareTool sharedInstance] showShareViewWithShareUrl:self.viewModel.homeItem.share_url];
}

- (void)loadData {
    [[ONENetworkTool sharedInstance] requestFeedsDetailDataWithItemId:self.item_id success:^(NSDictionary *dataDict) {
        ONEHomeItem *homeItem = [ONEHomeItem homeItemWithDict:dataDict];
        ONEHomeViewModel *viewModel = [ONEHomeViewModel viewModelWithItem:homeItem];
        self.viewModel = viewModel;
    } failure:nil];
}

@end
