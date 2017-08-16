//
//  ONEAllCategoryNavigationView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAllCategoryNavigationView.h"

@implementation ONEAllCategoryNavigationView

+ (instancetype)categoryNavigationView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= ONEAllSeperatorViewHeight;
    [super setFrame:frame];
}

- (IBAction)hpButtonClick:(UIButton *)sender {
}

- (IBAction)questionButtonClick:(UIButton *)sender {
}
- (IBAction)essayButtonClick:(UIButton *)sender {
}
- (IBAction)serialButtonClick:(UIButton *)sender {
}
- (IBAction)movieButtonClick:(UIButton *)sender {
}
- (IBAction)musicButtonClick:(UIButton *)sender {
}
- (IBAction)radioButtonClick:(UIButton *)sender {
}

@end
