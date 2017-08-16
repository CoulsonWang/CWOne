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

- (IBAction)buttonClick:(UIButton *)sender {
    NSInteger categoryIndex = sender.tag;
    
    [self.delegate categoryNavigationView:self didClickButtonWithCategoryIndex:categoryIndex];
}

@end
