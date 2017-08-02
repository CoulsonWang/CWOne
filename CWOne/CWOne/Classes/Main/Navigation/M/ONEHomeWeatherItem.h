//
//  ONEHomeWeatherItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/2.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEHomeWeatherItem : NSObject

+ (instancetype)weatherItemWithDict:(NSDictionary *)dict;

@property (strong, nonatomic) NSString *city_name;

@property (strong, nonatomic) NSString *date;

@property (strong, nonatomic) NSString *temperature;

@property (strong, nonatomic) NSString *climate;

@property (strong, nonatomic) NSString *wind_direction;

@property (strong, nonatomic) NSString *hurricane;

@property (strong, nonatomic) NSString *icon_day;

@property (strong, nonatomic) NSString *icon_night;

@end
