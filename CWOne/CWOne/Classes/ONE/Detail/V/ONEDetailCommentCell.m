//
//  ONEDetailCommentCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDetailCommentCell.h"
#import "ONECommentItem.h"
#import <UIImageView+WebCache.h>
#import "ONEUserItem.h"
#import "ONEDateTool.h"
#import "UILabel+CWLineSpacing.h"
#import "ONENetworkTool.h"

#define kLargeBottomConstraint 30.0
#define kSmallBottomConstraint 15.0

@interface ONEDetailCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *normalSeperatorView;
@property (weak, nonatomic) IBOutlet UIView *lastHotCommentSeperatorView;

/// 点赞按钮距离底部的距离，决定底部的空间
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;


@property (assign, nonatomic, getter=isLike) BOOL like;

@property (assign, nonatomic, getter=isLastHotComment) BOOL lastHotComment;

@end

@implementation ONEDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 初始化设置
    self.iconView.layer.cornerRadius = self.iconView.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    
    self.contentLabel.font = [UIFont fontWithName:ONEThemeFontName size:14.0];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCommentItem:(ONECommentItem *)commentItem {
    _commentItem = commentItem;
    
    NSURL *iconURL = [NSURL URLWithString:commentItem.userItem.web_url];
    [self.iconView sd_setImageWithURL:iconURL];
    
    self.userNameLabel.text = commentItem.userItem.user_name;
    
    self.postTimeLabel.text = [[ONEDateTool sharedInstance] getCommentDateStringWithOriginalDateString:commentItem.input_date];
    
    [self.contentLabel setText:commentItem.content lineSpacing:6.0];
    
    NSString *praiseCount = [NSString stringWithFormat:@"%ld",commentItem.praisenum];
    [self.likeButton setTitle:praiseCount forState:UIControlStateNormal];
    
    self.lastHotComment = commentItem.isLastHotComment;
}

- (void)setLastHotComment:(BOOL)lastHotComment {
    _lastHotComment = lastHotComment;
    
    self.normalSeperatorView.hidden = lastHotComment;
    self.lastHotCommentSeperatorView.hidden = !lastHotComment;
    self.bottomSpaceConstraint.constant = lastHotComment ? kLargeBottomConstraint : kSmallBottomConstraint;
}
- (IBAction)replyButtonClick:(UIButton *)sender {
}

- (IBAction)likeButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    self.like = sender.isSelected;
    
    if (sender.isSelected) {
        NSString *count = [NSString stringWithFormat:@"%ld",[self.likeButton titleForState:UIControlStateNormal].integerValue + 1];
        [self.likeButton setTitle:count forState:UIControlStateNormal];
    } else {
        NSString *count = [NSString stringWithFormat:@"%ld",[self.likeButton titleForState:UIControlStateNormal].integerValue - 1];
        [self.likeButton setTitle:count forState:UIControlStateNormal];
    }
    // 发送网络请求，通知服务器点了\取消了赞
    if (sender.isSelected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ONECommentPraiseNotification object:nil userInfo:@{ ONECommentIdKey : self.commentItem.commentID}];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ONECommentUnpraiseNotification object:nil userInfo:@{ ONECommentIdKey : self.commentItem.commentID }];
    }
    
}



@end
