//
//  ONEShareView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/12.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEShareView.h"
#import "ONENavigationBarTool.h"

#define kAnimationDuration 0.3
#define kButtonVerticalDistance 120.0
#define kBackgroundAlpha 0.975

@interface ONEShareView ()

@property (weak, nonatomic) UIButton *wechatMomentButton;
@property (weak, nonatomic) UIButton *wechatFriendButton;
@property (weak, nonatomic) UIButton *sinaWeiboButton;
@property (weak, nonatomic) UIButton *QQButton;
@property (weak, nonatomic) UIButton *copylinkButton;

@end

@implementation ONEShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:kBackgroundAlpha];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareView)]];
    
    UIButton *wechatMomentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatMomentButton setImage:[UIImage imageNamed:@"ShareWechatMomentImage"] forState:UIControlStateNormal];
    [wechatMomentButton sizeToFit];
    wechatMomentButton.centerX = CWScreenW * 0.5;
    wechatMomentButton.centerY = CWScreenH * 0.5;
    [self addSubview:wechatMomentButton];
    self.wechatMomentButton = wechatMomentButton;
    
    UIButton *wechatFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatFriendButton setImage:[UIImage imageNamed:@"ShareWechatFriendImage"] forState:UIControlStateNormal];
    [wechatFriendButton sizeToFit];
    wechatFriendButton.centerX = CWScreenW * 0.5;
    wechatFriendButton.centerY = CWScreenH * 0.5;
    [self addSubview:wechatFriendButton];
    self.wechatFriendButton = wechatFriendButton;
    
    UIButton *sinaWeiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaWeiboButton setImage:[UIImage imageNamed:@"ShareSinaWeiboImage"] forState:UIControlStateNormal];
    [sinaWeiboButton sizeToFit];
    sinaWeiboButton.centerX = CWScreenW * 0.5;
    sinaWeiboButton.centerY = CWScreenH * 0.5;
    [self addSubview:sinaWeiboButton];
    self.sinaWeiboButton = sinaWeiboButton;
    
    UIButton *QQButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [QQButton setImage:[UIImage imageNamed:@"ShareQQImage"] forState:UIControlStateNormal];
    [QQButton sizeToFit];
    QQButton.centerX = CWScreenW * 0.5;
    QQButton.centerY = CWScreenH * 0.5;
    [self addSubview:QQButton];
    self.QQButton = QQButton;
    
    UIButton *copylinkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [copylinkButton setImage:[UIImage imageNamed:@"ShareCopyLinkImage"] forState:UIControlStateNormal];
    [copylinkButton sizeToFit];
    [copylinkButton addTarget:self action:@selector(copyShareLinkToPasteBoard) forControlEvents:UIControlEventTouchUpInside];
    copylinkButton.centerX = CWScreenW * 0.5;
    copylinkButton.centerY = CWScreenH * 0.5;
    [self addSubview:copylinkButton];
    self.copylinkButton = copylinkButton;
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(CWScreenW - 40, 20, 20, 20)];
    [closeButton setImage:[UIImage imageNamed:@"close_gray"] forState:UIControlStateNormal];
    [closeButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareView)]];
    [self addSubview:closeButton];
}

- (void)showShareAnimaton {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.wechatMomentButton.y -= 2 * kButtonVerticalDistance;
        self.wechatFriendButton.y -= kButtonVerticalDistance;
        self.QQButton.y += kButtonVerticalDistance;
        self.copylinkButton.y += 2 * kButtonVerticalDistance;
        [[ONENavigationBarTool sharedInstance] changeStatusBarAlpha: 1 - kBackgroundAlpha];
    }];
}

- (void)hideShareView {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.wechatMomentButton.centerY = CWScreenH * 0.5;
        self.wechatFriendButton.centerY = CWScreenH * 0.5;
        self.QQButton.centerY = CWScreenH * 0.5;
        self.copylinkButton.centerY = CWScreenH * 0.5;
        self.alpha = 0;
        [[ONENavigationBarTool sharedInstance] changeStatusBarAlpha: 1];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)copyShareLinkToPasteBoard {
    // 拷贝链接到剪切板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.shareUrl;
    
    // 移除视图
    [self hideShareView];
    
    // 显示“已复制”提示
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(didCopyShareLink:)]) {
            [self.delegate didCopyShareLink:self];
        }
    });
    
}

@end
