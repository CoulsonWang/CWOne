//
//  ONEHomeItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeItem.h"
#import "ONEUserItem.h"
#import "NSString+CWTranslate.h"

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
    
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}



@end
