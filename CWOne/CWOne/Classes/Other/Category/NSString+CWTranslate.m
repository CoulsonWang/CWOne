//
//  NSString+CWTranslate.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "NSString+CWTranslate.h"

@implementation NSString (CWTranslate)

+ (instancetype)chineseNumberWithNumber:(NSUInteger)number {
    switch (number) {
        case 0:
            return @"〇";
            break;
        case 1:
            return @"一";
            break;
        case 2:
            return @"二";
            break;
        case 3:
            return @"三";
            break;
        case 4:
            return @"四";
            break;
        case 5:
            return @"五";
            break;
        case 6:
            return @"六";
            break;
        case 7:
            return @"七";
            break;
        case 8:
            return @"八";
            break;
        case 9:
            return @"九";
            break;
        default:
            return nil;
    }
}

@end
