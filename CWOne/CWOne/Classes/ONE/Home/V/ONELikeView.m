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

#define kAnimateDuration 0.4

#define kLikeCountLabelWidth 25.0
#define kLikeCountLabelHeight 11.0


@interface ONELikeView ()
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) CWCalendarLabel *likeCountLabel;

@property (assign, nonatomic) BOOL isLikeWhenLoad;

@end

@implementation ONELikeView

+ (instancetype)likeView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

+ (instancetype)likeViewWithLargeImage {
    ONELikeView *likeView = [ONELikeView likeView];
    [likeView changeButtonImageToLargeOne];
    return likeView;
}

- (void)changeButtonImageToLargeOne {
    [self.likeButton setImage:[UIImage imageNamed:@"like_gray"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"liked_red"] forState:UIControlStateSelected];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 添加点赞数label
    CWCalendarLabel *likeCountLabel = [[CWCalendarLabel alloc] init];
    likeCountLabel.frame = CGRectMake(self.width - kLikeCountLabelWidth, 0, kLikeCountLabelWidth, kLikeCountLabelHeight);
    likeCountLabel.font = [UIFont systemFontOfSize:8.0];
    likeCountLabel.textColor = [UIColor colorWithWhite:169/255.0 alpha:1.0];
    likeCountLabel.animateDuration = 0.35;
    [self addSubview:likeCountLabel];
    self.likeCountLabel = likeCountLabel;
}

- (void)setViewModel:(ONEHomeViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.likeButton.selected = viewModel.homeItem.isLike;
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",viewModel.homeItem.like_count];
    
    self.isLikeWhenLoad = viewModel.homeItem.isLike;
    
}


- (IBAction)likeButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    // 更新模型
    self.viewModel.homeItem.like = sender.isSelected;
    
    // 播放动画，更新点赞数字
    CWCalendarLabelScrollDirection direction = sender.isSelected ? CWCalendarLabelScrollToTop : CWCalendarLabelScrollToBottom;
    
    NSInteger newCount;
    if (self.isLikeWhenLoad) {
        newCount = (direction == CWCalendarLabelScrollToTop) ? self.viewModel.homeItem.like_count : self.viewModel.homeItem.like_count - 1;
    } else {
        newCount = (direction == CWCalendarLabelScrollToTop) ? self.viewModel.homeItem.like_count + 1 : self.viewModel.homeItem.like_count;
    }
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
