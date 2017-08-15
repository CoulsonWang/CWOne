//
//  ONEHomeItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeItem.h"
#import "ONESearchResultItem.h"
#import "ONEUserItem.h"
#import "NSString+CWTranslate.h"
#import "ONEHomeWeatherItem.h"

@implementation ONEHomeItem

+ (instancetype)homeItemWithDict:(NSDictionary *)dict {
    ONEHomeItem *item = [[ONEHomeItem alloc] init];
    
    // 赋值原始数据
    [item setValuesForKeysWithDictionary:dict];
    
    // 处理类型
    item.type = [item.category getType];
    
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
    item.typeName = [NSString getCategoryStringWithCategoryInteger:item.category.integerValue];
    
    // 处理天气
    item.weather = [ONEHomeWeatherItem weatherItemWithDict:dict[@"weather"]];
    
    
    return item;
}

+ (instancetype)homeItemWithSearchResultItem:(ONESearchResultItem *)searchResultItem {
    ONEHomeItem *homeItem = [[ONEHomeItem alloc] init];
    
    homeItem.title = searchResultItem.title;
    homeItem.category = [NSString stringWithFormat:@"%ld",searchResultItem.category];
    homeItem.item_id = [NSString stringWithFormat:@"%ld",searchResultItem.content_id];
    homeItem.serial_list = searchResultItem.serial_list;
    
    homeItem.type = [homeItem.category getType];
    homeItem.typeName = [NSString getCategoryStringWithCategoryInteger:homeItem.category.integerValue];
    
    return homeItem;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}



@end
