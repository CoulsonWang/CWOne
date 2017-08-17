//
//  ONEDetailBottomToolView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDetailBottomToolView.h"
#import "ONELikeView.h"
#import <Masonry.h>
#import "ONELoginTool.h"
#import "ONEShareTool.h"
#import "ONEEssayItem.h"
#import "UIButton+CWColor.h"

@interface ONEDetailBottomToolView ()
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) ONELikeView *likeView;
@property (weak, nonatomic) IBOutlet UIButton *writeCommentButton;

@end

@implementation ONEDetailBottomToolView

/// 快速构造方法
+ (instancetype)detailBottomToolView {
    ONEDetailBottomToolView *toolView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    return toolView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 添加点赞控件
    // 添加点赞控件
    ONELikeView *likeView = [ONELikeView likeViewWithLargeImage];
    
    [self addSubview:likeView];
    [likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentButton.mas_left).with.offset(-8);
        make.centerY.equalTo(self.commentButton);
        make.height.equalTo(@34);
        make.width.equalTo(@80);
    }];
    self.likeView = likeView;
}

- (void)setEssayItem:(ONEEssayItem *)essayItem {
    _essayItem = essayItem;
    
    self.likeView.essayItem = essayItem;
    [self.commentButton setTitle:[NSString stringWithFormat:@"%ld",essayItem.commentnum] forState:UIControlStateNormal];
}
- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    [self.shareButton changeImageColor:tintColor];
    [self.commentButton changeImageColor:tintColor];
    [self.commentButton setTitleColor:tintColor forState:UIControlStateNormal];
    [self.likeView changeTintColor:tintColor];
}

- (IBAction)writeCommentButtonClick:(UIButton *)sender {
    if ([[ONELoginTool sharedInstance] isLogin]) {
        // 已登录，处理收藏逻辑
    } else {
        // 未登录，显示登录界面
        [[ONELoginTool sharedInstance] showLoginView];
    }
}
- (IBAction)shareButtonClick:(UIButton *)sender {
    [[ONEShareTool sharedInstance] showShareViewWithShareUrl:self.essayItem.web_url];
}
- (IBAction)commentButtonClick:(UIButton *)sender {
    // 滚动tableView
    [[NSNotificationCenter defaultCenter] postNotificationName:ONEDetailToolViewCommentButtonClickNotification object:nil];
}

@end
