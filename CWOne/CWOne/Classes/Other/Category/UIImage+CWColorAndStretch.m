//
//  UIImage+CWColorAndStretch.h
//  CWColorAndStretch
//
//  Created by Coulson_Wang on 2017/7/27.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "UIImage+CWColorAndStretch.h"

@implementation UIImage (CWColorAndStretch)

+ (instancetype)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    [color setFill];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (instancetype)imageWithStretch {
    CGFloat top = self.size.height * 0.5;
    CGFloat left = self.size.width * 0.5;
    CGFloat bottom = self.size.height - top - 1;
    CGFloat right = self.size.width - left - 1;

    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
}

+ (instancetype)imageStretchWithName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithStretch];
}

@end
