//
//  ONEDetailTableHeaderView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/8.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDetailTableHeaderView.h"
#import <UIImageView+WebCache.h>
#import "ONEEssayItem.h"
#import "ONEUserItem.h"

#define kWebViewMinusHeight 150.0
#define kInfoHeaderHeight 400.0

@interface ONEDetailTableHeaderView () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *feedCoverView;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *albumInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *musicButton;

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
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    
    self.playButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    self.playButton.layer.cornerRadius = self.playButton.width * 0.5;
    self.playButton.layer.masksToBounds = YES;
}

- (void)webViewLoadHtmlDataWithHtmlString:(NSString *)htmlString {
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)setEssayItem:(ONEEssayItem *)essayItem {
    _essayItem = essayItem;
    
    if (self.type == ONEHomeItemTypeMusic || self.type == ONEHomeItemTypeMovie) {
        NSURL *feedCoverURL = [[NSURL alloc] initWithString:essayItem.feedsCoverURLstring];
        [self.feedCoverView sd_setImageWithURL:feedCoverURL];
        
        NSURL *coverURL = [NSURL URLWithString:essayItem.cover];
        [self.coverView sd_setImageWithURL:coverURL];
        
        self.albumInfoLabel.text = [NSString stringWithFormat:@"· %@ · %@ | %@",essayItem.album,essayItem.author.user_name,essayItem.title];
        
        self.titleLabel.text = essayItem.story_title;
        
        self.authorLabel.text = [NSString stringWithFormat:@"文 / %@",essayItem.story_author.user_name];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    
    CGFloat minusHeight = (self.type == ONEHomeItemTypeMusic || self.type == ONEHomeItemTypeMovie) ? 0 : kWebViewMinusHeight;
    CGFloat plusHeight = (self.type == ONEHomeItemTypeMusic || self.type == ONEHomeItemTypeMovie) ? kInfoHeaderHeight : 0;
    [self.delegate detailTableHeaderView:self WebViewDidFinishLoadWithHeight:webViewHeight - minusHeight + plusHeight];
}
- (IBAction)musicButtonClick:(UIButton *)sender {
}

@end
