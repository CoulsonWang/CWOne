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

@end
