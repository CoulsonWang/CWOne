//
//  ONEAuthorItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAuthorItem.h"

@implementation ONEAuthorItem

+ (instancetype)authorItemWithDict:(NSDictionary *)dict {
    ONEAuthorItem *item = [[ONEAuthorItem alloc] init];
    [item setValuesForKeysWithDictionary:dict];
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

@end
