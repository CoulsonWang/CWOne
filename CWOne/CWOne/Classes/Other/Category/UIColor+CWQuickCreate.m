//
//  UIColor+CWQuickCreate.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "UIColor+CWQuickCreate.h"

@implementation UIColor (CWQuickCreate)

+ (instancetype)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
    return color;
}

+ (instancetype)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b {
    return [self colorWithR:r G:g B:b alpha:1.0];
}

@end
