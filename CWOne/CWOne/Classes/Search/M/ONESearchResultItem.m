//
//  ONESearchResultItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/14.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONESearchResultItem.h"

@implementation ONESearchResultItem

+ (instancetype)searchResultItemWihtDict:(NSDictionary *)dict {
    ONESearchResultItem *item = [[ONESearchResultItem alloc] init];
    
    [item setValuesForKeysWithDictionary:dict];
    
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

@end
