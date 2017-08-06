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

@interface ONEDetailBottomToolView ()
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) ONELikeView *likeView;

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
        make.right.equalTo(self.commentButton.mas_left).with.offset(-4);
        make.centerY.equalTo(self.commentButton);
        make.height.equalTo(@28);
        make.width.equalTo(@60);
    }];
    self.likeView = likeView;
}

- (IBAction)writeCommentButtonClick:(UIButton *)sender {
}
- (IBAction)shareButtonClick:(UIButton *)sender {
}
- (IBAction)commentButtonClick:(UIButton *)sender {
}

@end
