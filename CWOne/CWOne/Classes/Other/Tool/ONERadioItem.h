//
//  ONERadioItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//  电台数据模型

#import <Foundation/Foundation.h>

@interface ONERadioItem : NSObject

// 原始属性
@property (assign, nonatomic) NSInteger start_interval;

@property (assign, nonatomic) NSInteger end_interval;

// 自定义的属性
@property (assign, nonatomic, getter=isActive) BOOL active;

+ (instancetype)radioItemWithDict:(NSDictionary *)dict;

@end
