//
//  ONERelatedItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/7.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONERelatedItem.h"
#import "ONEUserItem.h"

@implementation ONERelatedItem

+ (instancetype)relatedItemWithDict:(NSDictionary *)dict {
    ONERelatedItem *relatedItem = [[ONERelatedItem alloc] init];
    
    [relatedItem setValuesForKeysWithDictionary:dict];
    
    NSArray *author_list = dict[@"author_list"];
    NSDictionary *author_dict = author_list.firstObject;
    relatedItem.author = [ONEUserItem userItemWithDict:author_dict];
    
    return relatedItem;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

@end
