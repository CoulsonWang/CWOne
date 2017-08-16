//
//  ONEHomeFeedTitleButton.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONESearchAllListTitleButton.h"

#define kTitleLableWidthRate 0.8

@implementation ONESearchAllListTitleButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    ONESearchAllListTitleButton *button = [super buttonWithType:buttonType];
    
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat titleLabelWidth = self.width * kTitleLableWidthRate;
    self.titleLabel.frame = CGRectMake(0, 0, titleLabelWidth, self.height);
    
    self.imageView.frame = CGRectMake(titleLabelWidth, 0, self.imageView.width, self.imageView.height);
    self.imageView.centerY = self.height * 0.5;
}

@end
