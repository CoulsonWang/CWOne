//
//  ONEHomeCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeCell.h"
#import "ONEHomeViewModel.h"
#import "ONEHomeItem.h"
#import <UIImageView+WebCache.h>
#import "ONELikeView.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import "UILabel+CWLineSpacing.h"
#import "ONERadioTool.h"
#import "CALayer+CWAnimation.h"
#import "ONEShareTool.h"

#define kSideMargin 25.0
#define kRatio 0.6

@interface ONEHomeCell ()
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image_View;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) ONELikeView *likeView;
// 影视cell用到的标签
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
// 音乐cell用到的标签
@property (weak, nonatomic) IBOutlet UIImageView *musicBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *musicCoverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *audioPlatformImageView;
@property (weak, nonatomic) IBOutlet UIButton *musicPlayButton;
@property (weak, nonatomic) IBOutlet UILabel *musicInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *musicTagImageView;

// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeftMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewRightMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelTopConstraint;

// 临时属性
@property (strong, nonatomic) CABasicAnimation *animation;

@end

@implementation ONEHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageViewLeftMarginConstraint.constant = kSideMargin;
    self.imageViewRightMarginConstraint.constant = kSideMargin;
    self.imageViewHeightConstraint.constant = (CWScreenW - 2 * kSideMargin) * kRatio;
    [self.contentView layoutIfNeeded];
    
    // 添加点赞控件
    ONELikeView *likeView = [ONELikeView likeView];
    [self.contentView addSubview:likeView];
    [likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareButton.mas_left).with.offset(-10);
        make.centerY.equalTo(self.shareButton);
        make.height.equalTo(@28);
        make.width.equalTo(@60);
    }];
    self.likeView = likeView;
    
    // 音乐封面变为圆形
    self.musicCoverImageView.layer.cornerRadius = self.imageViewHeightConstraint.constant * 0.5;
    self.musicCoverImageView.layer.masksToBounds = YES;
    
    // 播放按钮变圆形
    self.musicPlayButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.musicPlayButton.layer.cornerRadius = self.musicPlayButton.width * 0.5;
    self.musicPlayButton.layer.masksToBounds = YES;
    
}

- (void)setViewModel:(ONEHomeViewModel *)viewModel {
    [super setViewModel:viewModel];
    
    // 通用属性
    self.categoryLabel.text = viewModel.categoryTitle;
    self.titleLabel.text = viewModel.homeItem.title;
    self.authorLabel.text = viewModel.authorString;
    self.subTitleLabel.text = viewModel.moviewSubTitle;
    [self.summaryLabel setText:viewModel.homeItem.forward lineSpacing:8.0];
    self.timeLabel.text = viewModel.timeStr;
    self.likeView.viewModel = viewModel;
    
    NSURL *imgUrl = [NSURL URLWithString:viewModel.homeItem.img_url];
    UIImage *placeHolder = [UIImage imageNamed:@"center_diary_placeholder"];
    self.contentLabelTopConstraint.constant = 10.0;
    self.contentLabelBottomConstraint.constant = 35.0;
    
    // 影视相关属性
    BOOL isMoview = (viewModel.homeItem.type == ONEHomeItemTypeMovie);
    self.centerImageView.hidden = !isMoview;
    self.subTitleLabel.hidden = !isMoview;
    if (isMoview) {
        self.image_View.image = [UIImage imageNamed:@"video_feed_background"];
        self.contentLabelBottomConstraint.constant = 55.0;
        [self.centerImageView sd_setImageWithURL:imgUrl placeholderImage:placeHolder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                self.image_View.image = [UIImage imageNamed:@"networkingErrorPlaceholderIcon"];
            }
        }];
    }
    
    // 音乐相关属性
    BOOL isMusic = (viewModel.homeItem.type == ONEHomeItemTypeMusic);
    self.image_View.hidden = isMusic;
    self.musicBackgroundView.hidden = !isMusic;
    self.musicInfoLabel.hidden = !isMusic;
    self.musicCoverImageView.hidden = !isMusic;
    self.musicPlayButton.hidden = !isMusic;
    self.audioPlatformImageView.hidden = !isMusic;
    self.musicTagImageView.hidden = !isMusic;
    if (isMusic) {
        self.musicInfoLabel.text = viewModel.musicInfoStr;
        [self.musicCoverImageView sd_setImageWithURL:imgUrl placeholderImage:placeHolder completed:nil];
        self.audioPlatformImageView.image = viewModel.musicPlatformImage;
        self.contentLabelTopConstraint.constant = 50.0;
    }
    
    
    
    if (!isMoview && !isMusic) {
        [self.image_View sd_setImageWithURL:imgUrl placeholderImage:placeHolder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                self.image_View.image = [UIImage imageNamed:@"networkingErrorPlaceholderIcon"];
            }
        }];
    }
    
    [self.contentView layoutIfNeeded];
}



#pragma mark - 事件响应
- (IBAction)musicPlayButtonClick:(UIButton *)sender {
    
    if (!sender.isSelected) {
        // 播放音乐
        NSString *musicUrlStr = self.viewModel.musicUrl;
        if ([musicUrlStr isEqualToString:@"xiami"]) {
            // 提示无法播放
            [SVProgressHUD showErrorWithStatus:@"抱歉,因授权原因,无法播放虾米提供的音乐"];
            [SVProgressHUD dismissWithDelay:2.5];
        } else {
            __weak typeof(self) weakSelf = self;
            [[ONERadioTool sharedInstance] playMusicWithUrlString:musicUrlStr completion:^{
                weakSelf.musicPlayButton.selected = NO;
                [weakSelf removeAnimationOnMusicCoverView];
            }];
            sender.selected = !sender.isSelected;
            // 开始旋转动画
            [self resumeAnimationOnMusicCoverView];
        }
    } else {
        sender.selected = !sender.isSelected;
        // 暂停音乐
        [[ONERadioTool sharedInstance] pauseCurrentMusic];
        // 停止旋转动画
        [self pauseAnimationOnMusicCoverView];
    }
}

- (IBAction)shareButtonClick:(UIButton *)sender {
    [[ONEShareTool sharedInstance] showShareViewWithShareUrl:self.viewModel.homeItem.share_url];
}

#pragma mark - 私有方法
- (void)addAnimationForMusicCoverView {
    [self.musicCoverImageView.layer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = 0;
    animation.toValue = @(M_PI * 2);
    animation.duration = 30.0;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    
    [self.musicCoverImageView.layer addAnimation:animation forKey:@"rotation"];
}

- (void)removeAnimationOnMusicCoverView {
    [self.musicCoverImageView.layer removeAllAnimations];
    self.animation = nil;
}

- (void)pauseAnimationOnMusicCoverView {
    [self.musicCoverImageView.layer pauseAnimate];
}

- (void)resumeAnimationOnMusicCoverView {
    if (!self.animation) {
        [self addAnimationForMusicCoverView];
    } else {
        [self.musicCoverImageView.layer resumeAnimate];
    }
}

@end
