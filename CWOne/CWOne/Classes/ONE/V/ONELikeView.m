//
//  ONELikeView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/2.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONELikeView.h"
#import "ONENetworkTool.h"
#import "ONEHomeViewModel.h"
#import "ONEHomeItem.h"

@interface ONELikeView ()
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *lastNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextNumberLabel;

@property (weak, nonatomic) UILabel *currentCountLabel;

@end

@implementation ONELikeView

+ (instancetype)likeView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setViewModel:(ONEHomeViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.likeButton.selected = viewModel.homeItem.isLike;
    if (viewModel.homeItem.isLike) {
        self.lastNumberLabel.text = [NSString stringWithFormat:@"%ld",viewModel.homeItem.like_count-1];
        self.nextNumberLabel.text = [NSString stringWithFormat:@"%ld",viewModel.homeItem.like_count];
        self.currentCountLabel = self.nextNumberLabel;
    } else {
        self.lastNumberLabel.text = [NSString stringWithFormat:@"%ld",viewModel.homeItem.like_count];
        self.nextNumberLabel.text = [NSString stringWithFormat:@"%ld",viewModel.homeItem.like_count+1];
        self.currentCountLabel = self.lastNumberLabel;
    }
}

- (IBAction)likeButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    self.viewModel.homeItem.like = sender.selected;
    
    // 播放动画，更新点赞数字
    
    
    // 发送一个POST请求通知服务器已点赞
    [[ONENetworkTool sharedInstance] postPraisedWithItemId:self.viewModel.homeItem.item_id success:^{
        //
    } failure:^(NSError *error) {
        //
    }];
}

@end
