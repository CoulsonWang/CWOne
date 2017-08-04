//
//  ONEDateTool.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/4.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDateTool.h"
#import "ONEMainTabBarController.h"
#import "ONEHomeWeatherItem.h"
#import "NSString+ONEComponents.h"

static ONEDateTool *_instance;

@implementation ONEDateTool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ONEDateTool alloc] init];
    });
    return _instance;
}

- (NSString *)currentDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *currentDate = [formatter dateFromString:self.dateOriginStr];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *currentDateString = [formatter stringFromDate:currentDate];
    return currentDateString;
}

- (NSString *)getDateStringFromCurrentDateWihtDateInterval:(NSInteger)dateInterval {
    NSDate *currentDate = [self.currentDateString getDate];
    
    NSTimeInterval intervalInSeconds = dateInterval * 24.0 * 60 * 60;
    NSDate *newDate = [currentDate dateByAddingTimeInterval:-intervalInSeconds];
    return [NSString getDateStringWithDate:newDate];
}

- (NSString *)yesterdayDateStr {
    return [self getDateStringFromCurrentDateWihtDateInterval:1];
}

@end
