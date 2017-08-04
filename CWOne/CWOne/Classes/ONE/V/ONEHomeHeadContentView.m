//
//  ONEHomeSmallNoteCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/2.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeHeadContentView.h"
#import "ONELikeView.h"
#import <Masonry.h>
#import <SDWebImageManager.h>
#import "ONEHomeViewModel.h"
#import "ONEHomeItem.h"
#import "ONEMainTabBarController.h"
#import "UILabel+CWLineSpacing.h"

@interface ONEHomeHeadContentView ()

@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIView *seperateView;

@property (weak, nonatomic) ONELikeView *likeView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverViewHeightConstraint;

@end

@implementation ONEHomeHeadContentView

+ (instancetype)headContentView {
    ONEHomeHeadContentView *headContentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    headContentView.width = CWScreenW;
    return headContentView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 添加点赞控件
    ONELikeView *likeView = [ONELikeView likeView];
    [self addSubview:likeView];
    [likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.collectButton.mas_left).with.offset(-4);
        make.centerY.equalTo(self.collectButton);
        make.height.equalTo(@28);
        make.width.equalTo(@60);
    }];
    self.likeView = likeView;
}

- (void)setViewModel:(ONEHomeViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.subTitleLabel.text = viewModel.subTitle;
    [self.contentLabel setText:viewModel.homeItem.forward lineSpacing:8.0];
    self.imageInfoLabel.text = viewModel.homeItem.words_info;
    self.likeView.viewModel = viewModel;
    [self setCoverViewImage:viewModel.homeItem.img_url];
    
    self.headContentViewHeight = CGRectGetMaxY(self.seperateView.frame);
}

#pragma mark - 私有方法
- (void)setCoverViewImage:(NSString *)imageUrl {
    // 先通过SDWebImage在缓存中查找是否有缓存图片，如果有则不再下载，若没有，则同步下载，更新约束
    UIImage *cacheImg = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:imageUrl];
    UIImage *image;
    if (cacheImg != nil) {
        image = cacheImg;
    } else {
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        image = [UIImage imageWithData:imgData];
    }
    CGFloat height = image.size.height /image.size.width * CWScreenW;
    self.coverViewHeightConstraint.constant = height;
    [self layoutIfNeeded];
    self.coverView.image = image;
}

- (IBAction)smallNoteButtonClick:(UIButton *)sender {
}

- (IBAction)shareButtonClick:(UIButton *)sender {
}
- (IBAction)collectButtonClick:(UIButton *)sender {
}

@end
