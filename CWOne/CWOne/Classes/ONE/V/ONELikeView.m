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

#define kLabelWidth 22.0
#define kLabelHeight 11.0
#define kAnimateDuration 0.4

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
        [self setCurrentCountLabel:self.nextNumberLabel animate:NO];
    } else {
        self.lastNumberLabel.text = [NSString stringWithFormat:@"%ld",viewModel.homeItem.like_count];
        self.nextNumberLabel.text = [NSString stringWithFormat:@"%ld",viewModel.homeItem.like_count+1];
        [self setCurrentCountLabel:self.lastNumberLabel animate:NO];
    }
}

- (void)setCurrentCountLabel:(UILabel *)currentCountLabel animate:(BOOL)animate{
    _currentCountLabel = currentCountLabel;
    
    NSTimeInterval interval = animate ? kAnimateDuration : 0;
    [UIView animateWithDuration:interval animations:^{
        if (currentCountLabel == self.lastNumberLabel) {
            self.lastNumberLabel.frame = CGRectMake(self.width - kLabelWidth, 0, kLabelWidth, kLabelHeight);
            self.nextNumberLabel.frame = CGRectMake(self.width - kLabelWidth, kLabelHeight, kLabelWidth, kLabelHeight);
            self.nextNumberLabel.alpha = 0;
            self.lastNumberLabel.alpha = 1;
        } else {
            self.nextNumberLabel.frame = CGRectMake(self.width - kLabelWidth, 0, kLabelWidth, kLabelHeight);
            self.lastNumberLabel.frame = CGRectMake(self.width - kLabelWidth, -kLabelHeight, kLabelWidth, kLabelHeight);
            self.lastNumberLabel.alpha = 0;
            self.nextNumberLabel.alpha = 1;
        }
    }];
    
    
}

- (IBAction)likeButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    // 更新模型
    self.viewModel.homeItem.like = sender.isSelected;
    
    // 播放动画，更新点赞数字
    UILabel *current = (sender.isSelected) ? self.nextNumberLabel : self.lastNumberLabel;
    [self setCurrentCountLabel:current animate:YES];
    
    // 发送一个POST请求通知服务器已点赞
    [[ONENetworkTool sharedInstance] postPraisedWithItemId:self.viewModel.homeItem.item_id success:^{
        //
    } failure:^(NSError *error) {
        //
    }];
}

@end
