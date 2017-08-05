//
//  NSString+ONEComponents.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/4.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ONEComponents)

- (NSDateComponents *)getComponents;

- (NSDate *)getDate;

+ (instancetype)getDateStringWithDate:(NSDate *)date;

- (BOOL)isLaterThanAnotherDateString:(NSString *)dateString;

@end
