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

#define kSideMargin 25.0
#define kRatio 0.6

@interface ONEHomeCell ()
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image_View;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) ONELikeView *likeView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeftMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewRightMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *movieSubTitleHeightConstraint;

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
        make.right.equalTo(self.shareButton.mas_left).with.offset(-4);
        make.centerY.equalTo(self.shareButton);
        make.height.equalTo(@28);
        make.width.equalTo(@60);
    }];
    self.likeView = likeView;
    
}

- (void)setViewModel:(ONEHomeViewModel *)viewModel {
    [super setViewModel:viewModel];
    
    BOOL isMoview = (viewModel.homeItem.type == ONEHomeItemTypeMovie);
    
    self.centerImageView.hidden = !isMoview;
    self.subTitleLabel.hidden = !isMoview;
    self.movieSubTitleHeightConstraint.constant = isMoview ? 20 : 0;
    [self.contentView layoutIfNeeded];
    
    self.categoryLabel.text = viewModel.categoryTitle;
    self.titleLabel.text = viewModel.homeItem.title;
    self.authorLabel.text = viewModel.authorString;
    
    NSURL *imgUrl = [NSURL URLWithString:viewModel.homeItem.img_url];
    UIImage *placeHolder = [UIImage imageNamed:@"center_diary_placeholder"];
    if (isMoview) {
        self.image_View.image = [UIImage imageNamed:@"video_feed_background"];
        [self.centerImageView sd_setImageWithURL:imgUrl placeholderImage:placeHolder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                self.image_View.image = [UIImage imageNamed:@"networkingErrorPlaceholderIcon"];
            }
        }];
    } else {
        [self.image_View sd_setImageWithURL:imgUrl placeholderImage:placeHolder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                self.image_View.image = [UIImage imageNamed:@"networkingErrorPlaceholderIcon"];
            }
        }];
    }
    
    
    self.subTitleLabel.text = viewModel.moviewSubTitle;
    self.summaryLabel.text = viewModel.homeItem.forward;
    self.timeLabel.text = viewModel.timeStr;
    self.likeView.viewModel = viewModel;
    
}



#pragma mark - 事件响应

- (IBAction)shareButtonClick:(UIButton *)sender {
}

#pragma mark - 私有方法


@end
