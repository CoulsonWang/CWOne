//
//  UIColor+Hex.h
//  十六进制颜色
//
//  Created by Coulson_Wang on 2017/6/23.
//  Copyright © 2017年 YYWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

// 默认alpha位1
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
