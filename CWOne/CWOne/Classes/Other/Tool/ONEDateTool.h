//
//  ONEDateTool.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/4.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEDateTool : NSObject

@property (strong, nonatomic) NSString *dateOriginStr;

@property (strong, nonatomic, readonly) NSString *currentDateString;

+ (instancetype)sharedInstance;

- (NSString *)yesterdayDateStr;

- (NSString *)getDateStringFromCurrentDateWihtDateInterval:(NSInteger)dateInterval;

- (NSDate *)getDateFromCurrentDateWithDateInterval:(NSInteger)dateInterval;

- (NSString *)getCommentDateStringWithOriginalDateString:(NSString *)dateString;

/// 根据原始日期获取请求feeds列表所需的日期文本
- (NSString *)getFeedsRequestDateStringWithOriginalDateString:(NSString *)dateString;

/// 根据原始日期转换为feed展示的日期
- (NSString *)getFeedsDateStringWithOriginalDateString:(NSString *)originalDateString;

/// 获取到下一个月的日期
- (NSString *)getNextMonthDateStringWithDateString:(NSString *)dateString;

/// 获取上一个月的日期
- (NSString *)getLastMonthDateStringWithDateString:(NSString *)dateString;
@end
