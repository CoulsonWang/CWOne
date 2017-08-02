//
//  ONEHomeRadioCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/2.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeRadioCell.h"
#import "ONEHomeViewModel.h"
#import "ONEHomeItem.h"
#import "ONEUserItem.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "ONELikeView.h"

@interface ONEHomeRadioCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIView *playButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *authorIconView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) ONELikeView *likeView;

@end

@implementation ONEHomeRadioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.authorIconView.layer.cornerRadius = self.authorIconView.width * 0.5;
    self.authorIconView.layer.masksToBounds = YES;
    
    // 添加点赞控件
    ONELikeView *likeView = [ONELikeView likeView];
    [self.contentView addSubview:likeView];
    [likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareButton.mas_left).with.offset(-4);
        make.centerY.equalTo(self.shareButton);
        make.height.equalTo(@28);
        make.width.equalTo(@60);
    }];
    self.likeView = likeView;
}

- (void)setViewModel:(ONEHomeViewModel *)viewModel {
    [super setViewModel:viewModel];
    
    NSURL *imgUrl = [NSURL URLWithString:viewModel.homeItem.img_url];
    [self.coverView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"center_diary_placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            self.coverView.image = [UIImage imageNamed:@"networkingErrorPlaceholderIcon"];
        }
    }];
    
    NSURL *authorIconUrl = [NSURL URLWithString:viewModel.homeItem.authorItem.web_url];
    [self.authorIconView sd_setImageWithURL:authorIconUrl placeholderImage:[UIImage imageNamed:@"UpdateInfoPlaceholdImage"] completed:nil];
    
    
    self.authorNameLabel.text = viewModel.homeItem.authorItem.user_name;
    self.titleLabel.text = viewModel.homeItem.title;
    self.likeView.viewModel = viewModel;
}

- (IBAction)playButtonClick:(UIButton *)sender {
}

@end
