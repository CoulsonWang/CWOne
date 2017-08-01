//
//  ONEHomeNavigationBarTitleView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeNavigationBarTitleView.h"

@interface ONEHomeNavigationBarTitleView ()

@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation ONEHomeNavigationBarTitleView

+ (instancetype)homeNavTitleView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)titleButtonClick:(UIButton *)sender {
}

@end
