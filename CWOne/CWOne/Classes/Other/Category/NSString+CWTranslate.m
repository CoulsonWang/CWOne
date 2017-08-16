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

// 中文

+ (instancetype)getCategoryStringWithCategoryInteger:(NSInteger)category {
    switch (category) {
        case 0:
            return @"小记";
        case 1:
            return @"阅读";
        case 2:
            return @"连载";
        case 3:
            return @"问答";
        case 4:
            return @"音乐";
        case 5:
            return @"影视";
        case 6:
            return @"广告";
        case 8:
            return @"电台";
        default:
            return nil;
    }
}


// 英文

+ (NSString *)getTypeStrWithCategoryInteger:(NSInteger)category {
    switch (category) {
        case 0:
            return @"";
        case 1:
            return @"essay";
        case 2:
            return @"serial";
        case 3:
            return @"question";
        case 4:
            return @"music";
        case 5:
            return @"movie";
        case 6:
            return @"advertisement";
        case 8:
            return @"radio";
        default:
            return nil;
    }
}

+ (NSString *)getTypeStrWithType:(ONEHomeItemType)type {
    NSInteger category = [NSString getCategoryWithType:type].integerValue;
    return [self getTypeStrWithCategoryInteger:category];
}

// 相互转化

- (ONEHomeItemType)getType {
    switch (self.integerValue) {
        case 0:
            return ONEHomeItemTypeSmallNote;
        case 1:
            return ONEHomeItemTypeEssay;
        case 2:
            return ONEHomeItemTypeSerial;
        case 3:
            return ONEHomeItemTypeQuestion;
        case 4:
            return ONEHomeItemTypeMusic;
        case 5:
            return ONEHomeItemTypeMovie;
        case 6:
            return ONEHomeItemTypeAdvertisement;
        case 8:
            return ONEHomeItemTypeRadio;
        default:
            return ONEHomeItemTypeUnknown;
    }
}

+ (instancetype)getCategoryWithType:(ONEHomeItemType)type {
    NSInteger categoryNum = -1;
    switch (type) {
        case ONEHomeItemTypeSmallNote:
            categoryNum = 0;
            break;
        case ONEHomeItemTypeEssay:
            categoryNum = 1;
            break;
        case ONEHomeItemTypeSerial:
            categoryNum = 2;
            break;
        case ONEHomeItemTypeQuestion:
            categoryNum = 3;
            break;
        case ONEHomeItemTypeMusic:
            categoryNum = 4;
            break;
        case ONEHomeItemTypeMovie:
            categoryNum = 5;
            break;
        case ONEHomeItemTypeAdvertisement:
            categoryNum = 6;
            break;
        case ONEHomeItemTypeRadio:
            categoryNum = 8;
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%ld",categoryNum];
}


@end
