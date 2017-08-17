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
#import "ONELoginTool.h"
#import "ONEPersistentTool.h"

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
@property (weak, nonatomic) IBOutlet UILabel *lastHotCommentLabel;
@property (weak, nonatomic) IBOutlet UIView *leftSeperatorView;
@property (weak, nonatomic) IBOutlet UIView *rightSeperatorView;

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
    
    // 加载数据库中点赞情况
    CommentItem *comment = [[ONEPersistentTool sharedInstance] fetchCommentItemWithTypeName:self.typeName commentID:commentItem.commentID];
    if (comment) {
        self.like = comment.isLike;
        self.likeButton.selected = self.isLike;
    }
}

- (void)setLastHotComment:(BOOL)lastHotComment {
    _lastHotComment = lastHotComment;
    
    self.normalSeperatorView.hidden = lastHotComment;
    self.lastHotCommentSeperatorView.hidden = !lastHotComment;
    self.bottomSpaceConstraint.constant = lastHotComment ? kLargeBottomConstraint : kSmallBottomConstraint;
}

- (void)setFontColor:(UIColor *)fontColor {
    _fontColor = fontColor;
    if (fontColor != nil) {
        self.userNameLabel.textColor = fontColor;
        self.postTimeLabel.textColor = fontColor;
        self.contentLabel.textColor = fontColor;
        self.normalSeperatorView.hidden = YES;
        self.lastHotCommentLabel.textColor = fontColor;
        self.leftSeperatorView.backgroundColor = fontColor;
        self.rightSeperatorView.backgroundColor = fontColor;
    }
}
- (IBAction)replyButtonClick:(UIButton *)sender {
    if ([[ONELoginTool sharedInstance] isLogin]) {
        // 已登录，处理评论逻辑
    } else {
        // 未登录，显示登录界面
        [[ONELoginTool sharedInstance] showLoginView];
    }
}

- (IBAction)likeButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    self.like = sender.isSelected;
    
    if (sender.isSelected) {
        // 修改点赞数字文本
        NSString *count = [NSString stringWithFormat:@"%ld",[self.likeButton titleForState:UIControlStateNormal].integerValue + 1];
        [self.likeButton setTitle:count forState:UIControlStateNormal];
        // 修改本地数据库
        [[ONEPersistentTool sharedInstance] updateCommentItemWithType:self.typeName commentID:self.commentItem.commentID isLike:YES];
        // 发送网络请求，通知服务器点了\取消了赞
        [[NSNotificationCenter defaultCenter] postNotificationName:ONECommentPraiseNotification object:nil userInfo:@{ ONECommentIdKey : self.commentItem.commentID}];
    } else {
        NSString *count = [NSString stringWithFormat:@"%ld",[self.likeButton titleForState:UIControlStateNormal].integerValue - 1];
        [self.likeButton setTitle:count forState:UIControlStateNormal];
        
        [[ONEPersistentTool sharedInstance] updateCommentItemWithType:self.typeName commentID:self.commentItem.commentID isLike:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ONECommentUnpraiseNotification object:nil userInfo:@{ ONECommentIdKey : self.commentItem.commentID }];
    }
    
}



@end
