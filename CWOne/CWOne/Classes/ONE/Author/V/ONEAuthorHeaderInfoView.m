//
//  ONEAuthorHeaderInfoView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/17.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAuthorHeaderInfoView.h"
#import <UIImageView+WebCache.h>
#import "ONEUserItem.h"
#import "ONELoginTool.h"

#define kShadowImageHeight 10.0

@interface ONEAuthorHeaderInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDescripLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;

@end

@implementation ONEAuthorHeaderInfoView



+ (instancetype)authorHeaderInfoView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userIconImageView.layer.cornerRadius = self.userIconImageView.width * 0.5;
    self.userIconImageView.layer.masksToBounds = YES;
    
    self.followButton.layer.borderWidth = 1;
    self.followButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.followButton.layer.cornerRadius = 2;
    
    // 添加顶部阴影图片
    UIImageView *topShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigationBarShadowImage"]];
    topShadowImageView.frame = CGRectMake(0, -kShadowImageHeight, CWScreenW, kShadowImageHeight);
    topShadowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    [self addSubview:topShadowImageView];
}

- (void)setAuthor:(ONEUserItem *)author {
    _author = author;
    
    NSURL *iconURL = [NSURL URLWithString:author.web_url];
    [self.userIconImageView sd_setImageWithURL:iconURL placeholderImage:[UIImage imageNamed:@"userDefault"]];
    
    self.userNameLabel.text = author.user_name;
    
    self.userSummaryLabel.text = author.summary;
    
    self.userDescripLabel.text = author.desc;
    
    self.fansCountLabel.text = [NSString stringWithFormat:@"%@关注",author.fans_total];
    
    self.headerViewHeight = CGRectGetMaxY(self.seperatorView.frame);
}

- (IBAction)followButtonClick:(UIButton *)sender {
    if ([[ONELoginTool sharedInstance] isLogin]) {
        // 已登录，处理关注逻辑
    } else {
        // 未登录，显示登录界面
        [[ONELoginTool sharedInstance] showLoginView];
    }
}

@end
