//
//  ONEEssayItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEEssayItem.h"
#import "ONEUserItem.h"

@implementation ONEEssayItem

+ (instancetype)essayItemWithDict:(NSDictionary *)dict {
    ONEEssayItem *item = [[ONEEssayItem alloc] init];
    
    [item setValuesForKeysWithDictionary:dict];
    
    NSArray *tag_list = dict[@"tag_list"];
    NSDictionary *tag = tag_list.firstObject;
    item.tagTitle = tag[@"title"];
    
    NSDictionary *authorDict = dict[@"author"];
    item.author = [ONEUserItem userItemWithDict:authorDict];
    
    NSDictionary *storyAuthorDict = dict[@"story_author"];
    item.story_author = [ONEUserItem userItemWithDict:storyAuthorDict];
    
    NSRange range = [item.feeds_cover rangeOfString:@"|"];
    item.feedsCoverURLstring = [item.feeds_cover substringToIndex:range.location];
    
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

@end
