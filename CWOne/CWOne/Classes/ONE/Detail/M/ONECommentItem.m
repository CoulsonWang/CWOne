//
//  ONECommentItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONECommentItem.h"
#import "ONEUserItem.h"

@implementation ONECommentItem

+ (instancetype)commentItemWithDict:(NSDictionary *)dict {
    ONECommentItem *item = [[ONECommentItem alloc] init];
    
    [item setValuesForKeysWithDictionary:dict];
    
    item.commentID = dict[@"id"];
    item.userItem = [ONEUserItem userItemWithDict:dict[@"user"]];
    item.isHot = ([dict[@"type"] integerValue] == 0);
    
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

@end
