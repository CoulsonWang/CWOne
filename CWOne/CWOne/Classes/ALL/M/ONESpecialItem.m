//
//  ONESpecialItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/15.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONESpecialItem.h"

@implementation ONESpecialItem

+ (instancetype)specialItemWithDict:(NSDictionary *)dict {
    ONESpecialItem *specialItem = [[ONESpecialItem alloc] init];
    [specialItem setValuesForKeysWithDictionary:dict];
    return specialItem;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
    
}

@end
