//
//  UIImage+Render.h
//  快速生成不渲染的图片
//
//  Created by Coulson_Wang on 2017/6/25.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Render)

+ (instancetype)imageWithOriginalRenderMode:(NSString *)imageName;

@end
