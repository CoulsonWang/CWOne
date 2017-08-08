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
#import <Masonry.h>

#define kAnimateDuration 0.4

#define kLengthOfPerNum 4.0
#define kBaseWidth 40.0

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
    likeCountLabel.font = [UIFont systemFontOfSize:10.0];
    likeCountLabel.textAlignment = NSTextAlignmentLeft;
    likeCountLabel.textColor = [UIColor colorWithWhite:169/255.0 alpha:1.0];
    likeCountLabel.animateDuration = 0.35;
    likeCountLabel.sizeToFitOn = YES;
    [self addSubview:likeCountLabel];
    [likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_centerX).offset(10);
    }];
    self.likeCountLabel = likeCountLabel;
}

- (void)setViewModel:(ONEHomeViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.likeButton.selected = viewModel.homeItem.isLike;
    
    self.praisenum = viewModel.homeItem.like_count;
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",viewModel.homeItem.like_count];
    
    self.isLikeWhenLoad = viewModel.homeItem.isLike;
    
}

- (void)setPraisenum:(NSInteger)praisenum {
    _praisenum = praisenum;
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",praisenum];
    
}

- (IBAction)likeButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    // 播放动画，更新点赞数字
    CWCalendarLabelScrollDirection direction = sender.isSelected ? CWCalendarLabelScrollToTop : CWCalendarLabelScrollToBottom;
    
    NSInteger newCount;
    if (self.isLikeWhenLoad) {
        newCount = (direction == CWCalendarLabelScrollToTop) ? self.praisenum : self.praisenum - 1;
    } else {
        newCount = (direction == CWCalendarLabelScrollToTop) ? self.praisenum + 1: self.praisenum;
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
