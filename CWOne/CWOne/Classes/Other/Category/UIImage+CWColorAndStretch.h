//
//  UIImage+CWColorAndStretch.h
//  CWColorAndStretch
//
//  Created by Coulson_Wang on 2017/7/27.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CWColorAndStretch)

// 根据颜色快速创建一张1个像素的图片
+ (instancetype)imageWithColor:(UIColor *)color;

// 根据颜色快速创建一张指定大小的图片
+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size;

// 将原图片修改为一张可拉伸的图片
- (instancetype)imageWithStretch;

// 快速创建一张可拉伸的图片
+ (instancetype)imageStretchWithName:(NSString *)imageName;

@end
