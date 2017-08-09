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
#define kInfoHeaderHeight 380.0

@interface ONEDetailTableHeaderView () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

// 音乐的控件
@property (weak, nonatomic) IBOutlet UIView *musicInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *feedCoverView;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *albumInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *musicButton;

// 影视的控件
@property (weak, nonatomic) IBOutlet UIView *movieInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *movieCoverView;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *picNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieAuthorLabel;
@property (weak, nonatomic) IBOutlet UIButton *movieButton;


@property (assign, nonatomic) ONEHomeItemType type;

// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewTopToMusicInfoViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewTopToMovieInfoViewTopConstraint;

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

- (void)setType:(ONEHomeItemType)type {
    _type = type;
    if (type == ONEHomeItemTypeMusic) {
        self.movieInfoView.hidden = YES;
        [self removeConstraint:self.webViewTopToMovieInfoViewTopConstraint];
    } else if (type == ONEHomeItemTypeMovie) {
        self.musicInfoView.hidden = YES;
        [self removeConstraint:self.webViewTopToMusicInfoViewTopConstraint];
    } else {
        self.musicInfoView.hidden = YES;
        self.movieInfoView.hidden = YES;
        
        [self removeConstraint:self.webViewTopToMusicInfoViewTopConstraint];
        [self removeConstraint:self.webViewTopToMovieInfoViewTopConstraint];
        
        self.webViewLeftConstraint.constant = 0;
        self.webViewRightConstraint.constant = 0;
    }
}

- (void)setEssayItem:(ONEEssayItem *)essayItem {
    _essayItem = essayItem;
    
    if (self.type == ONEHomeItemTypeMusic) {
        NSURL *feedCoverURL = [[NSURL alloc] initWithString:essayItem.feedsCoverURLstring];
        [self.feedCoverView sd_setImageWithURL:feedCoverURL];
        NSURL *coverURL = [NSURL URLWithString:essayItem.cover];
        [self.coverView sd_setImageWithURL:coverURL];
        self.albumInfoLabel.text = [NSString stringWithFormat:@"· %@ · %@ | %@",essayItem.album,essayItem.author.user_name,essayItem.title];
        self.titleLabel.text = essayItem.story_title;
        self.authorLabel.text = [NSString stringWithFormat:@"文 / %@",essayItem.story_author.user_name];
    } else if (self.type == ONEHomeItemTypeMovie) {
        NSURL *movieCoverURL = [NSURL URLWithString:essayItem.detailcover];
        [self.movieCoverView sd_setImageWithURL:movieCoverURL];
        self.movieNameLabel.text = [NSString stringWithFormat:@"《%@》",essayItem.movieTitle];
        self.picNumLabel.text = [NSString stringWithFormat:@"1/%ld",essayItem.photo.count + 1];
        self.movieTitleLabel.text = essayItem.contentTitle;
        self.movieAuthorLabel.text = [NSString stringWithFormat:@"文 / %@",essayItem.movieContentAuthor.user_name];
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
