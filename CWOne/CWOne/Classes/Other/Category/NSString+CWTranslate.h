//
//  NSString+CWTranslate.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONEHomeItem.h"

@interface NSString (CWTranslate)

+ (instancetype)chineseNumberWithNumber:(NSUInteger)number;

+ (instancetype)getCategoryStringWithCategoryInteger:(NSInteger)category;


- (ONEHomeItemType)getType;

+ (instancetype)getCategoryWithType:(ONEHomeItemType)type;

// 英文名

+ (NSString *)getTypeStrWithCategoryInteger:(NSInteger)category;

+ (NSString *)getTypeStrWithType:(ONEHomeItemType)type;



@end
