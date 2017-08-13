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
#import "NSString+CWTranslate.h"
#import "ONEEssayItem.h"

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
    ONELikeView *likeView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    likeView.isSummary = YES;
    return likeView;
}

+ (instancetype)likeViewWithLargeImage {
    ONELikeView *likeView = [ONELikeView likeView];
    [likeView changeButtonImageToLargeOne];
    likeView.isSummary = NO;
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
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",viewModel.homeItem.like_count];
    
}

- (void)setEssayItem:(ONEEssayItem *)essayItem {
    _essayItem = essayItem;
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld",essayItem.praisenum];
}

- (IBAction)likeButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    // 播放动画，更新点赞数字
    CWCalendarLabelScrollDirection direction = sender.isSelected ? CWCalendarLabelScrollToTop : CWCalendarLabelScrollToBottom;
    
    NSInteger newCount;
    if (self.isLikeWhenLoad) {
        if (self.isSummary) {
            newCount = (direction == CWCalendarLabelScrollToTop) ? self.viewModel.homeItem.like_count : self.viewModel.homeItem.like_count - 1;
        } else {
            newCount = (direction == CWCalendarLabelScrollToTop) ? self.essayItem.praisenum : self.essayItem.praisenum - 1;
        }
    } else {
        if (self.isSummary) {
            newCount = (direction == CWCalendarLabelScrollToTop) ? self.viewModel.homeItem.like_count + 1: self.viewModel.homeItem.like_count;
        } else {
            newCount = (direction == CWCalendarLabelScrollToTop) ? self.essayItem.praisenum + 1: self.essayItem.praisenum;
        }
    }
    NSString *newCountStr = [NSString stringWithFormat:@"%ld",newCount];
    [self.likeCountLabel showNextText:newCountStr withDirection:direction];
    
    if (sender.isSelected) {
        // 发送一个POST请求通知服务器已点赞
        NSString *typeName;
        NSString *itemId;
        if (self.isSummary) {
            typeName = [NSString getTypeStrWithType:self.viewModel.homeItem.type];
            itemId = self.viewModel.homeItem.item_id;
        } else {
            typeName = [NSString getTypeStrWithCategoryInteger:self.essayItem.category];
            itemId = self.essayItem.item_id;
        }
        [[ONENetworkTool sharedInstance] postPraisedWithItemId:itemId typeName:typeName success:nil failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
        // 修改本地数据库中的数据
    } else {
        // 修改本地数据库中的数据
    }
}

@end
