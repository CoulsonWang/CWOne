//
//  ONESearchAllListViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/15.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONESearchAllListViewController.h"
#import "ONEHomeFeedBottomPickerView.h"
#import "ONENetworkTool.h"
#import "ONEDateTool.h"
#import "UIImage+Render.h"
#import "NSString+CWTranslate.h"

#define kDatePickerHeight 39.0

@interface ONESearchAllListViewController ()

@property (weak, nonatomic) UIWebView *webView;
@property (weak, nonatomic) ONEHomeFeedBottomPickerView *datePickerView;

@end

@implementation ONESearchAllListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUpNavigationBar];
    
    [self setUpWebView];
    
    [self setUpDatePickerView];
    
    [self loadData];
}

- (void)setUpNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"back_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    if (self.categoryIndex == 0) {
        self.title = @"图文";
    } else {
        self.title = [NSString getCategoryStringWithCategoryInteger:self.categoryIndex];
    }
}

- (void)setUpDatePickerView {
    ONEHomeFeedBottomPickerView *datePickerView = [[ONEHomeFeedBottomPickerView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, kDatePickerHeight)];
    datePickerView.dateString = [[ONEDateTool sharedInstance] currentDateString];
    [self.view addSubview:datePickerView];
    self.datePickerView = datePickerView;
}

- (void)setUpWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, self.view.height)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.contentInset = UIEdgeInsetsMake(kDatePickerHeight, 0, 0, 0);
    [self.view addSubview:webView];
    self.webView = webView;
}

- (void)loadData {
    [[ONENetworkTool sharedInstance] requestSearchListDataWithCategoryIndex:self.categoryIndex success:^(NSString *html_content) {
        [self.webView loadHTMLString:html_content baseURL:nil];
    } failure:nil];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
