//
//  ONEDetailTableHeaderView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/8.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDetailTableHeaderView.h"

#define kWebViewMinusHeight 150.0

@interface ONEDetailTableHeaderView () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (assign, nonatomic) ONEHomeItemType type;

@end

@implementation ONEDetailTableHeaderView

+ (instancetype)detailTableHeaderViewWithType:(ONEHomeItemType)type {
    ONEDetailTableHeaderView *detailTableHeaderView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    detailTableHeaderView.type = type;
    detailTableHeaderView.frame = CGRectMake(0, 0, CWScreenW, CWScreenH);
    return detailTableHeaderView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
}

- (void)webViewLoadHtmlDataWithHtmlString:(NSString *)htmlString {
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    
    [self.delegate detailTableHeaderView:self WebViewDidFinishLoadWithHeight:webViewHeight - kWebViewMinusHeight];
}

@end
