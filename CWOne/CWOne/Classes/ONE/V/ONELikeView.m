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
#import "CWCalendarLabel.h"

#define kLabelWidth 22.0
#define kLabelHeight 11.0
#define kAnimateDuration 0.4

@interface ONELikeView ()
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet CWCalendarLabel *likeCountLabel;


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
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",viewModel.homeItem.like_count];

}


- (IBAction)likeButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    // 更新模型
    self.viewModel.homeItem.like = sender.isSelected;
    
    // 播放动画，更新点赞数字
    CWCalendarLabelScrollDirection direction = sender.isSelected ? CWCalendarLabelScrollToTop : CWCalendarLabelScrollToBottom;
    NSInteger newCount = (direction == CWCalendarLabelScrollToTop) ? self.likeCountLabel.text.integerValue + 1 : self.likeCountLabel.text.integerValue - 1;
    NSString *newCountStr = [NSString stringWithFormat:@"%ld",newCount];
    [self.likeCountLabel showNextText:newCountStr withDirection:direction];
    
    // 发送一个POST请求通知服务器已点赞
    [[ONENetworkTool sharedInstance] postPraisedWithItemId:self.viewModel.homeItem.item_id success:^{
        //
    } failure:^(NSError *error) {
        //
    }];
}

@end
