//
//  ONEUserHeaderView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/17.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEUserHeaderView.h"
#import "ONEUserInfoItem.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface ONEUserHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *diaryCoverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *musicListCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;

@property (weak, nonatomic) UIImageView *backgroundImageView;

@end

@implementation ONEUserHeaderView

+ (instancetype)userHeaderView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userIconImageView.layer.cornerRadius = self.userIconImageView.width * 0.5;
    self.userIconImageView.layer.masksToBounds = YES;
    self.userIconImageView.layer.borderWidth = 1;
    self.userIconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.musicListCoverImageView.image = [UIImage imageNamed:@"music_cover_small"];
    
    // 添加背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personalBackgroundImage"]];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    [self insertSubview:backgroundImageView atIndex:0];
    self.backgroundImageView = backgroundImageView;
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@(self.height));
    }];
}

- (void)setUserInfoItem:(ONEUserInfoItem *)userInfoItem {
    _userInfoItem = userInfoItem;
    
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:userInfoItem.web_url] placeholderImage:[UIImage imageNamed:@"userDefault"]];
    
    self.userLabel.text = userInfoItem.user_name;
}

- (void)updateBackgroundViewHeightWithOffsetY:(CGFloat)offsetY {
    CGFloat newHeight = self.height - offsetY;
    [self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(newHeight));
    }];
    [self layoutIfNeeded];
}

@end
