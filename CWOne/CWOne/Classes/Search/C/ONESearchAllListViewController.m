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
#import "ONEHomeFeedDatePickerView.h"
#import "NSString+ONEComponents.h"
#import "ONESearchAllListTitleButton.h"
#import "ONECategoryChooserView.h"

#define kDatePickerHeight 39.0
#define kRowHeight 63.5
#define kSectionHeaderHeight 32.0

@interface ONESearchAllListViewController () <ONEHomeFeedBottomPickerViewDelegate, ONEHomeFeedDatePickerViewDelegate, UIScrollViewDelegate, ONECategoryChooserViewDelegate>

@property (weak, nonatomic) UIWebView *webView;
@property (weak, nonatomic) ONEHomeFeedBottomPickerView *datePickerView;
@property (weak, nonatomic) ONEHomeFeedDatePickerView *pickerView;
@property (weak, nonatomic) ONESearchAllListTitleButton *titleButton;
@property (weak, nonatomic) ONECategoryChooserView *chooserView;
@end

@implementation ONESearchAllListViewController

#pragma mark - 懒加载
- (ONEHomeFeedDatePickerView *)pickerView {
    if (!_pickerView) {
        ONEHomeFeedDatePickerView *pickerView = [ONEHomeFeedDatePickerView datePickerViewWithPosition:ONEDatePickerViewPositionTop frame:CGRectMake(0, 0, CWScreenW, CWScreenH - kNavigationBarHeight)];
        pickerView.delegate = self;
        [self.view addSubview:pickerView];
        _pickerView = pickerView;
    }
    return _pickerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self setUpNavigationBar];
    
    [self setUpWebView];
    
    [self setUpDatePickerView];
    
    [self loadData];
}
- (ONECategoryChooserView *)chooserView {
    if (!_chooserView) {
        ONECategoryChooserView *chooserView = [[ONECategoryChooserView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH - kNavigationBarHeight)];
        chooserView.delegate = self;
        [self.view addSubview:chooserView];
        _chooserView = chooserView;
    }
    return _chooserView;
}

#pragma mark - 初始化
- (void)setUpNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"back_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    
    ONESearchAllListTitleButton *button = [ONESearchAllListTitleButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(showCategoryChooserViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *titleStr;
    if (self.categoryIndex == 0) {
        titleStr = @"图文";
    } else {
        titleStr = [NSString getCategoryStringWithCategoryInteger:self.categoryIndex];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:titleStr forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 60, 44);
    self.navigationItem.titleView = button;
    self.titleButton = button;
}

- (void)setUpDatePickerView {
    ONEHomeFeedBottomPickerView *datePickerView = [[ONEHomeFeedBottomPickerView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, kDatePickerHeight)];
    datePickerView.dateString = [[ONEDateTool sharedInstance] currentDateString];
    datePickerView.delegate = self;
    [self.view addSubview:datePickerView];
    self.datePickerView = datePickerView;
}

- (void)setUpWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, self.view.height)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.contentInset = UIEdgeInsetsMake(kDatePickerHeight, 0, 0, 0);
    webView.scrollView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
}

- (void)loadData {
    [[ONENetworkTool sharedInstance] requestSearchListDataWithCategoryIndex:self.categoryIndex success:^(NSString *html_content) {
        [self.webView loadHTMLString:html_content baseURL:nil];
    } failure:nil];
}

#pragma mark - 事件响应
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showCategoryChooserViewButtonClick:(ONESearchAllListTitleButton *)button {
    button.selected = !button.isSelected;
    if (button.isSelected) {
        [self.chooserView showChooserView];
        [UIView animateWithDuration:0.3 animations:^{
            self.titleButton.imageView.transform = CGAffineTransformMakeRotation(radian(-179.0));
        }];
    } else {
        [self.chooserView hideChooserView];
        [UIView animateWithDuration:0.3 animations:^{
            self.titleButton.imageView.transform = CGAffineTransformIdentity;
        }];
    }
    
    
}

#pragma mark - ONEHomeFeedBottomPickerViewDelegate
- (void)feedDatePickViewDidClick:(ONEHomeFeedBottomPickerView *)pickView {
    // 显示日期选择器
    [self.pickerView appearWithDateString:self.datePickerView.dateString];
}
#pragma mark - ONEHomeFeedDatePickerViewDelegate
- (void)feedDataPicker:(ONEHomeFeedDatePickerView *)feedDatePickerView didConfirmSelectedWithDateString:(NSString *)dateString {
    // 更新webView的位置
    NSDate *newDate = [[NSString stringWithFormat:@"%@-01",dateString] getDate];
    NSTimeInterval timeInterval = [newDate timeIntervalSinceDate:[NSDate date]];
    NSInteger dayInterval = timeInterval/(24 * 3600);
    
    CGFloat offsetY = dayInterval * (kRowHeight + kSectionHeaderHeight/30);
    [self.webView.scrollView setContentOffset:CGPointMake(0, -offsetY) animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    NSInteger row = offsetY/(kRowHeight+ kSectionHeaderHeight/30);
    
    NSDate *destDate = [[NSDate date] dateByAddingTimeInterval:(-row * 24 * 3600)];
    NSString *newDateString = [NSString getDateStringWithDate:destDate];
    NSString *lastStr = [[ONEDateTool sharedInstance] getFeedsRequestDateStringWithOriginalDateString:self.datePickerView.dateString];
    NSString *newStr = [[ONEDateTool sharedInstance] getFeedsRequestDateStringWithOriginalDateString:newDateString];
    if (newStr != nil && ![newStr isEqualToString:lastStr]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.datePickerView.dateString = newDateString;
        });
    }
}
#pragma mark - ONECategoryChooserViewDelegate
- (void)categoryChooserViewDidCancleChoose:(ONECategoryChooserView *)categoryChooserView {
    self.titleButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.titleButton.imageView.transform = CGAffineTransformIdentity;
    }];
}
- (void)categoryChooserView:(ONECategoryChooserView *)categoryChooserView didChooseAtIndex:(NSInteger)index {
    self.categoryIndex = index;
    [self showCategoryChooserViewButtonClick:self.titleButton];
    [self loadData];
}

@end
