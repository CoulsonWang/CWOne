//
//  UIImage+Render.m
//  快速生成不渲染的图片
//
//  Created by Coulson_Wang on 2017/6/25.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "UIImage+Render.h"

@implementation UIImage (Render)

+ (instancetype)imageWithOriginalRenderMode:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
