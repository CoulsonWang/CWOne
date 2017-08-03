//
//  ONERadioItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONERadioItem.h"

@implementation ONERadioItem

+ (instancetype)radioItemWithDict:(NSDictionary *)dict {
    ONERadioItem *item = [[ONERadioItem alloc] init];
    [item setValuesForKeysWithDictionary:dict];
    
    item.active = item.start_interval < 0 && item.end_interval > 0;
    
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

@end
