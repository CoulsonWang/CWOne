//
//  ONEPhotoPickerViewLabel.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/12.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEPhotoPickerViewButton.h"

#define kTitleLableHeightRate 0.3;

@implementation ONEPhotoPickerViewButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    ONEPhotoPickerViewButton *button = [super buttonWithType:buttonType];
    
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat titleLabelHeight = self.height * kTitleLableHeightRate;
    self.titleLabel.frame = CGRectMake(0, 0, self.width, titleLabelHeight);
    
    self.imageView.frame = CGRectMake(0, titleLabelHeight, self.width, self.height - titleLabelHeight);
}

@end
