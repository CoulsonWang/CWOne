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
#import <SDWebImageManager.h>
#import "ONEPhoto.h"
#import <SVProgressHUD.h>
#import "ONERadioTool.h"
#import "ONELoginTool.h"

#define kWebViewMinusHeight 150.0
#define kMovieInfoHeaderHeight 500.0
#define kMusicInfoHeaderHeight 516.0
#define kTopicHeaderPlusHeight 40.0
#define kCoverViewOriginHeight 225.0
#define kMusicAnimationDuration 0.5

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
@property (weak, nonatomic) IBOutlet UIImageView *musicPlatformIconView;

// 影视的控件
@property (weak, nonatomic) IBOutlet UIView *movieInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *movieCoverView;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *picNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieAuthorLabel;
@property (weak, nonatomic) IBOutlet UIButton *movieButton;

@property (strong, nonatomic) NSMutableArray<ONEPhoto *> *photoArray;

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *albumImageViewCenterYConstraint;

@end

@implementation ONEDetailTableHeaderView

+ (instancetype)detailTableHeaderViewWithType:(ONEHomeItemType)type {
    ONEDetailTableHeaderView *detailTableHeaderView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    detailTableHeaderView.type = type;
    detailTableHeaderView.frame = CGRectMake(0, 0, CWScreenW, CWScreenH);
    return detailTableHeaderView;
}

- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        NSMutableArray *photoArray = [NSMutableArray array];
        _photoArray = photoArray;
    }
    return _photoArray;
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
    
    self.movieCoverView.userInteractionEnabled = YES;
    [self.movieCoverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkMoviePhotos)]];
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
        self.authorLabel.text = [NSString stringWithFormat:@"文 / %@",essayItem.author.user_name];
        self.musicPlatformIconView.image = essayItem.platform.integerValue == 1 ? [UIImage imageNamed:@"ONEXiamiMusicCopyright"] : [UIImage imageNamed:@"ONEMusicCopyright"];
    } else if (self.type == ONEHomeItemTypeMovie) {
        NSURL *movieCoverURL = [NSURL URLWithString:essayItem.detailcover];
        [self.movieCoverView sd_setImageWithURL:movieCoverURL];
        self.movieNameLabel.text = [NSString stringWithFormat:@"《%@》",essayItem.movieTitle];
        self.picNumLabel.text = [NSString stringWithFormat:@"1/%ld",essayItem.photo.count + 1];
        self.movieTitleLabel.text = essayItem.contentTitle;
        self.movieAuthorLabel.text = [NSString stringWithFormat:@"文 / %@",essayItem.author.user_name];
    }
    // 底部作者信息属性
    self.charge_edtLabel.text = [NSString stringWithFormat:@"%@ %@",essayItem.charge_edt,essayItem.editor_email];
    NSURL *authorIconURL = [NSURL URLWithString:essayItem.author.web_url];
    [self.authorIconImageView sd_setImageWithURL:authorIconURL];
    self.authorNameLabel.text = essayItem.author.user_name;
    self.authorSummaryLabel.text = essayItem.author.summary;
}

- (void)checkMoviePhotos {
    [[NSNotificationCenter defaultCenter] postNotificationName:ONEPhotoViewerShowNotification object:nil userInfo:@{ONEPhotoArrayKey : self.photoArray}];
}
                                        
#pragma mark - 对外公有方法
- (void)webViewLoadHtmlDataWithHtmlString:(NSString *)htmlString {
    [self.webView loadHTMLString:htmlString baseURL:nil];
}
#pragma mark - 私有方法
// 缓存图片
- (void)cachePhotosWithCompletion:(void (^)())completion {
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.essayItem.detailcover] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        ONEPhoto *photo = [ONEPhoto createPhotoObjectWihtImage:image];
        [self.photoArray addObject:photo];
        dispatch_group_t group = dispatch_group_create();
        for (NSString *photoUrl in self.essayItem.photo) {
            dispatch_group_enter(group);
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:photoUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                ONEPhoto *photo = [ONEPhoto createPhotoObjectWihtImage:image];
                [self.photoArray addObject:photo];
                dispatch_group_leave(group);
            }];
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            completion();
        });
    }];
}

- (void)showAlbumImageWithAnimated:(BOOL)animated {
    
    NSTimeInterval duration = animated ? kMusicAnimationDuration : 0;
    [UIView animateWithDuration:duration animations:^{
        self.albumImageViewCenterYConstraint.constant = 20;
        [self.musicInfoView layoutIfNeeded];
    }];
}

- (void)hideAlbumImageWithAnimated:(BOOL)animated {
    NSTimeInterval duration = animated ? kMusicAnimationDuration : 0;
    [UIView animateWithDuration:duration animations:^{
        self.albumImageViewCenterYConstraint.constant = 0;
        [self.musicInfoView layoutIfNeeded];
    }];
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
        case ONEHomeItemTypeTopic:
            plusHeight = kTopicHeaderPlusHeight;
            break;
        default:
            plusHeight = 0;
            break;
    }
    if (self.type == ONEHomeItemTypeMovie) {
        [self cachePhotosWithCompletion:^{
            [self.delegate detailTableHeaderView:self WebViewDidFinishLoadWithHeight:webViewHeight - minusHeight + plusHeight];
        }];
    } else {
        [self.delegate detailTableHeaderView:self WebViewDidFinishLoadWithHeight:webViewHeight - minusHeight + plusHeight];
    }
    
}

#pragma mark - 事件响应
- (IBAction)musicButtonClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:ONEDetailMusicInfoButtonClickNotification object:nil userInfo:@{ONEEssayItemKey: self.essayItem}];
}
- (IBAction)movieButtonClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:ONEDetailMovieInfoButtonClickNotification object:nil userInfo:@{ONEEssayItemKey: self.essayItem}];
}
- (IBAction)playMusicButtonClick:(UIButton *)sender {
    if (!sender.isSelected) {
        // 播放音乐
        if (self.essayItem.platform.integerValue == 1) {
            // 提示无法播放
            [SVProgressHUD showErrorWithStatus:@"抱歉,因授权原因,无法播放虾米提供的音乐"];
            [SVProgressHUD dismissWithDelay:2.5];
        } else {
            NSString *musicURLStr = self.essayItem.music_id;
            __weak typeof(self) weakSelf = self;
            [[ONERadioTool sharedInstance] playMusicWithUrlString:musicURLStr completion:^{
                weakSelf.playButton.selected = NO;
                [weakSelf hideAlbumImageWithAnimated:YES];
            }];
            sender.selected = !sender.isSelected;
            [self showAlbumImageWithAnimated:YES];
        }
    } else {
        sender.selected = !sender.isSelected;
        [[ONERadioTool sharedInstance] pauseCurrentMusic];
        [self hideAlbumImageWithAnimated:YES];
    }
}
- (IBAction)followButtonClick:(UIButton *)sender {
    if ([[ONELoginTool sharedInstance] isLogin]) {
        // 已登录，处理关注逻辑
    } else {
        // 未登录，显示登录界面
        [[ONELoginTool sharedInstance] showLoginView];
    }
}
- (IBAction)authorButtonClick:(UIButton *)sender {
    // 展示作者界面
    [self.delegate detailTableHeaderViewDidClickAuthorButton:self];
}

@end
