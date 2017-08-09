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
#define kMovieInfoHeaderHeight 490.0
#define kMusicInfoHeaderHeight 516.0
#define kCoverViewOriginHeight 225.0

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

// 底部信息控件
@property (weak, nonatomic) IBOutlet UIView *bottomInfoView;
@property (weak, nonatomic) IBOutlet UILabel *charge_edtLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorSummaryLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

@property (assign, nonatomic) ONEHomeItemType type;

// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewTopToMusicInfoViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewTopToMovieInfoViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewBottomToAuthorInfoViewSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *musicCoverViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *movieCoverViewConstraint;

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
    
    self.authorIconImageView.layer.cornerRadius = self.authorIconImageView.width * 0.5;
    self.authorIconImageView.layer.masksToBounds = YES;
    
    self.attentionButton.layer.borderWidth = 1;
    self.attentionButton.layer.borderColor = [UIColor colorWithWhite:170/255.0 alpha:1.0].CGColor;
    self.attentionButton.layer.cornerRadius = 2;
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
        self.bottomInfoView.hidden = YES;
        
        [self removeConstraint:self.webViewTopToMusicInfoViewTopConstraint];
        [self removeConstraint:self.webViewTopToMovieInfoViewTopConstraint];
        [self removeConstraint:self.webViewBottomToAuthorInfoViewSpaceConstraint];
        
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
        // 底部作者信息属性
        self.charge_edtLabel.text = [NSString stringWithFormat:@"%@ %@",essayItem.charge_edt,essayItem.editor_email];
        NSURL *authorIconURL = [NSURL URLWithString:essayItem.story_author.web_url];
        [self.authorIconImageView sd_setImageWithURL:authorIconURL];
        self.authorNameLabel.text = essayItem.story_author.user_name;
        self.authorSummaryLabel.text = essayItem.story_author.summary;
    } else if (self.type == ONEHomeItemTypeMovie) {
        NSURL *movieCoverURL = [NSURL URLWithString:essayItem.detailcover];
        [self.movieCoverView sd_setImageWithURL:movieCoverURL];
        self.movieNameLabel.text = [NSString stringWithFormat:@"《%@》",essayItem.movieTitle];
        self.picNumLabel.text = [NSString stringWithFormat:@"1/%ld",essayItem.photo.count + 1];
        self.movieTitleLabel.text = essayItem.contentTitle;
        self.movieAuthorLabel.text = [NSString stringWithFormat:@"文 / %@",essayItem.movieContentAuthor.user_name];
        // 底部作者信息属性
        self.charge_edtLabel.text = [NSString stringWithFormat:@"%@ %@",essayItem.charge_edt,essayItem.editor_email];
        NSURL *authorIconURL = [NSURL URLWithString:essayItem.movieContentAuthor.web_url];
        [self.authorIconImageView sd_setImageWithURL:authorIconURL];
        self.authorNameLabel.text = essayItem.movieContentAuthor.user_name;
        self.authorSummaryLabel.text = essayItem.movieContentAuthor.summary;
    }
}

#pragma mark - 对外公有方法
- (void)webViewLoadHtmlDataWithHtmlString:(NSString *)htmlString {
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    
    CGFloat minusHeight = (self.type == ONEHomeItemTypeMusic || self.type == ONEHomeItemTypeMovie) ? 0 : kWebViewMinusHeight;
    CGFloat plusHeight;
    switch (self.type) {
        case ONEHomeItemTypeMusic:
            plusHeight = kMusicInfoHeaderHeight;
            break;
        case ONEHomeItemTypeMovie:
            plusHeight = kMovieInfoHeaderHeight;
            break;
        default:
            plusHeight = 0;
            break;
    }
    [self.delegate detailTableHeaderView:self WebViewDidFinishLoadWithHeight:webViewHeight - minusHeight + plusHeight];
}
- (IBAction)musicButtonClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:ONEDetailMusicInfoButtonClickNotification object:nil userInfo:@{ONEEssayItemKey: self.essayItem}];
}
- (IBAction)movieButtonClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:ONEDetailMovieInfoButtonClickNotification object:nil userInfo:@{ONEEssayItemKey: self.essayItem}];
}

@end
