//
//  ONEFeedItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/11.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEFeedItem.h"

@implementation ONEFeedItem

+ (instancetype)feedItemWithDict:(NSDictionary *)dict {
    ONEFeedItem *item = [[ONEFeedItem alloc] init];
    
    [item setValuesForKeysWithDictionary:dict];
    
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

@end
