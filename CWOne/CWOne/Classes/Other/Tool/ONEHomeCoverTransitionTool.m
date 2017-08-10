//
//  ONECustomTransitionTool.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/10.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeCoverTransitionTool.h"

#define kHorizontalImageheight 240
#define kVerticalImageHeight 300
#define kHorizontalImageTopMargin 125
#define kVerticalImageTopMargin 100
#define kHorizontalImageSideMargin 25
#define kVolumeLabelVerticalMargin 48
#define kSubtitleLabelVerticalMargin 34
#define kLableVerticalMargin 3

static ONEHomeCoverTransitionTool *_instance;

@interface ONEHomeCoverTransitionTool () <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic, getter=isPresented) BOOL presented;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *volumeLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;

@end

@implementation ONEHomeCoverTransitionTool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - 懒加载
- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.presentImage];
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)volumeLabel {
    if (!_volumeLabel) {
        UILabel *volumeLabel = [[UILabel alloc] init];
        volumeLabel.text = self.volumeString;
        volumeLabel.font = [UIFont systemFontOfSize:12];
        volumeLabel.textColor = [UIColor whiteColor];
        [volumeLabel sizeToFit];
        volumeLabel.x = self.imageView.x;
        volumeLabel.y = self.imageView.y - kVolumeLabelVerticalMargin;
        volumeLabel.alpha = 0;
        _volumeLabel = volumeLabel;
    }
    return _volumeLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        UILabel *subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.text = self.subTitleString;
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.textColor = [UIColor whiteColor];
        [subtitleLabel sizeToFit];
        subtitleLabel.x = self.imageView.x;
        subtitleLabel.y = CGRectGetMaxY(self.imageView.frame) + kSubtitleLabelVerticalMargin;
        subtitleLabel.alpha = 0;
        _subtitleLabel = subtitleLabel;
    }
    return _subtitleLabel;
}

- (CGRect)calculateDestinationFrame {
    if (self.orientation == ONECoverImageOrientationHorizontal) {
        CGRect destFrame = CGRectMake(kHorizontalImageSideMargin, kHorizontalImageTopMargin, CWScreenW - 2*kHorizontalImageSideMargin, kHorizontalImageheight);
        return destFrame;
    } else {
        CGFloat width = self.presentImage.size.width * kVerticalImageHeight / self.presentImage.size.height;
        return CGRectMake((CWScreenW - width) * 0.5, kVerticalImageTopMargin, width, kVerticalImageHeight);
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.presented = YES;
    return self;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.presented = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPresented) {
        // 弹出动画
        UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
        presentedView.hidden = YES;
        [transitionContext.containerView addSubview:presentedView];
        
        
        self.imageView.frame = self.originFrame;
        [transitionContext.containerView addSubview:self.imageView];
        [transitionContext.containerView addSubview:self.volumeLabel];
        [transitionContext.containerView addSubview:self.subtitleLabel];
        
        transitionContext.containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.imageView.frame = [self calculateDestinationFrame];
            
            CGRect volumeFrame = self.volumeLabel.frame;
            self.volumeLabel.frame = CGRectMake(kHorizontalImageSideMargin, kVerticalImageTopMargin - volumeFrame.size.height - kLableVerticalMargin, volumeFrame.size.width, volumeFrame.size.height);
            self.volumeLabel.alpha = 1;
            
            CGRect subtitleFrame = self.subtitleLabel.frame;
            self.subtitleLabel.frame = CGRectMake(kHorizontalImageSideMargin, kVerticalImageTopMargin + kVerticalImageHeight + kLableVerticalMargin, subtitleFrame.size.width, subtitleFrame.size.height);
            self.subtitleLabel.alpha = 1;
        } completion:^(BOOL finished) {
            presentedView.hidden = NO;
            [transitionContext completeTransition:YES];
        }];
    } else {
        // 消失动画
        UIView *dismissView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        dismissView.hidden = YES;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.imageView.frame = self.originFrame;
            CGRect volumeFrame = self.volumeLabel.frame;
            self.volumeLabel.frame = CGRectMake(self.imageView.x, self.imageView.y - kVolumeLabelVerticalMargin, volumeFrame.size.width, volumeFrame.size.height);
            self.volumeLabel.alpha = 0;
            
            CGRect subtitleFrame = self.subtitleLabel.frame;
            self.subtitleLabel.frame = CGRectMake(self.imageView.x, CGRectGetMaxY(self.imageView.frame) + kSubtitleLabelVerticalMargin, subtitleFrame.size.width, subtitleFrame.size.height);
            self.subtitleLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [self.imageView removeFromSuperview];
            self.imageView = nil;
            [self.volumeLabel removeFromSuperview];
            self.volumeLabel = nil;
            [self.subtitleLabel removeFromSuperview];
            self.subtitleLabel = nil;
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
