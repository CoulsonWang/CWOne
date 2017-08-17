//
//  ONEUserInfoItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/17.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEUserInfoItem.h"

@implementation ONEUserInfoItem

+ (instancetype)userInfoItemWithDict:(NSDictionary *)dict {
    ONEUserInfoItem *userInfoItem = [[ONEUserInfoItem alloc] init];
    
    [userInfoItem setValuesForKeysWithDictionary:dict];
    
    return userInfoItem;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

@end
