//
//  ONEHomeItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeItem.h"
#import "ONEUserItem.h"

@implementation ONEHomeItem

+ (instancetype)homeItemWithDict:(NSDictionary *)dict {
    ONEHomeItem *item = [[ONEHomeItem alloc] init];
    
    // 赋值原始数据
    [item setValuesForKeysWithDictionary:dict];
    
    // 处理类型
    switch (item.category.integerValue) {
        case 0:
            item.type = ONEHomeItemTypeSmallNote;
            break;
        case 1:
            item.type = ONEHomeItemTypeEssay;
            break;
        case 2:
            item.type = ONEHomeItemTypeSerial;
            break;
        case 3:
            item.type = ONEHomeItemTypeQuestion;
            break;
        case 4:
            item.type = ONEHomeItemTypeMusic;
            break;
        case 5:
            item.type = ONEHomeItemTypeMovie;
            break;
        case 8:
            item.type = ONEHomeItemTypeRadio;
            break;
        default:
            item.type = ONEHomeItemTypeUnknown;
            break;
    }
    
    // 处理作者数据
    NSDictionary *authorDict = dict[@"author"];
    [item setValue:[ONEUserItem userItemWithDict:authorDict] forKeyPath:@"authorItem"];
    
    // 处理显示标题数据
    NSArray *tagList = dict[@"tag_list"];
    NSString *title = tagList.firstObject[@"title"];
    [item setValue:title forKeyPath:@"tag_title"];
    
    // 处理回答者名称
    NSDictionary *answererDict = dict[@"answerer"];
    [item setValue:[ONEUserItem userItemWithDict:answererDict] forKeyPath:@"answererItem"];
    
    //typeName
    item.typeName = [self getCategoryTitleWithType:item.type];
    
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

#pragma mark - 工具方法
+ (NSString *)getCategoryTitleWithType:(ONEHomeItemType)type {
    switch (type) {
        case ONEHomeItemTypeSmallNote:
            return @"小记";
        case ONEHomeItemTypeEssay:
            return @"阅读";
        case ONEHomeItemTypeSerial:
            return @"连载";
        case ONEHomeItemTypeQuestion:
            return @"问答";
        case ONEHomeItemTypeMusic:
            return @"音乐";
        case ONEHomeItemTypeMovie:
            return @"影视";
        case ONEHomeItemTypeRadio:
            return @"电台";
            
        default:
            return nil;
    }
}

@end
