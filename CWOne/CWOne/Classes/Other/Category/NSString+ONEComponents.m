//
//  NSString+ONEComponents.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/4.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "NSString+ONEComponents.h"

@implementation NSString (ONEComponents)

- (NSDateComponents *)getComponents {
    NSDate *date = [self getDate];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
}

- (NSDate *)getDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:self];
    return date;
}

+ (instancetype)getDateStringWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

- (BOOL)isLaterThanAnotherDateString:(NSString *)dateString {
    NSDate *thisDate = [self getDate];
    NSDate *compareDate = [dateString getDate];
    NSTimeInterval interval = [thisDate timeIntervalSinceDate:compareDate];
    return interval > 0;
}

@end
