//
//  ONESearchAllListViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/15.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONESearchAllListViewController.h"
#import "ONEHomeFeedBottomPickerView.h"

#define kDatePickerHeight 39.0

@interface ONESearchAllListViewController ()

@property (weak, nonatomic) UIWebView *webView;
@property (weak, nonatomic) ONEHomeFeedBottomPickerView *datePickerView;

@end

@implementation ONESearchAllListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpWebView];
    
    [self setUpDatePickerView];
}

- (void)setUpNavigationBar {
    
}

- (void)setUpDatePickerView {
    ONEHomeFeedBottomPickerView *datePickerView = [[ONEHomeFeedBottomPickerView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, kDatePickerHeight)];
    [self.view addSubview:datePickerView];
    self.datePickerView = datePickerView;
}

- (void)setUpWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, self.view.height)];
    
}

- (void)loadData {
    
}

@end
