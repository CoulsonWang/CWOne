//
//  UIButton+CWColor.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/17.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "UIButton+CWColor.h"

@implementation UIButton (CWColor)

- (void)changeImageColor:(UIColor *)tintColor {
    self.tintColor = tintColor;
    UIImage *renderImage = [self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setImage:renderImage forState:UIControlStateNormal];
}

@end
