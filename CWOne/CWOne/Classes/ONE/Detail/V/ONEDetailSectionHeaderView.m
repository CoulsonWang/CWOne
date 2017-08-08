//
//  ONEDetailSectionHeaderView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/8.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDetailSectionHeaderView.h"

@interface ONEDetailSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ONEDetailSectionHeaderView

+ (instancetype)sectionHeaderViewWithTitleString:(NSString *)titleString {
    ONEDetailSectionHeaderView *sectionHeaderView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    sectionHeaderView.frame = CGRectMake(0, 0, CWScreenW, 60);
    sectionHeaderView.title = titleString;
    return sectionHeaderView;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
