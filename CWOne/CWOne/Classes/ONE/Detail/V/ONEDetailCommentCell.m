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

@interface ONEDetailCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

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
}
- (IBAction)replyButtonClick:(UIButton *)sender {
}

- (IBAction)likeButtonClick:(UIButton *)sender {
}



@end
