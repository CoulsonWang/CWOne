//
//  ONEHomeWeatherItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/2.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeWeatherItem.h"

@implementation ONEHomeWeatherItem

+ (instancetype)weatherItemWithDict:(NSDictionary *)dict {
    ONEHomeWeatherItem *item = [[ONEHomeWeatherItem alloc] init];
    [item setValuesForKeysWithDictionary:dict];
    
    [item setValue:dict[@"icons"][@"day"] forKeyPath:@"icon_day"];
    [item setValue:dict[@"icons"][@"night"] forKeyPath:@"icon_night"];
    
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

@end
