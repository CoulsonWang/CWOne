//
//  ONEHomeItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeItem.h"

@implementation ONEHomeItem

+ (instancetype)homeItemWithDict:(NSDictionary *)dict {
    ONEHomeItem *item = [[ONEHomeItem alloc] init];
    [item setValuesForKeysWithDictionary:dict];
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

@end
