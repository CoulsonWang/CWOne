//
//  ONEHomeItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeItem.h"
#import "ONEAuthorItem.h"

@implementation ONEHomeItem

+ (instancetype)homeItemWithDict:(NSDictionary *)dict {
    ONEHomeItem *item = [[ONEHomeItem alloc] init];
    
    // 赋值原始数据
    [item setValuesForKeysWithDictionary:dict];
    
    // 处理作者数据
    NSDictionary *authorDict = dict[@"author"];
    [item setValue:[ONEAuthorItem authorItemWithDict:authorDict] forKeyPath:@"authorItem"];
    
    // 处理显示标题数据
    NSArray *tagList = dict[@"tag_list"];
    NSString *title = tagList.firstObject[@"title"];
    [item setValue:title forKeyPath:@"tag_title"];
    
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

@end
