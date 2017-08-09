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
    
    // 音乐属性
    NSDictionary *authorDict = dict[@"author"];
    if (authorDict) {
        item.author = [ONEUserItem userItemWithDict:authorDict];
    }
    NSDictionary *storyAuthorDict = dict[@"story_author"];
    if (storyAuthorDict) {
        item.story_author = [ONEUserItem userItemWithDict:storyAuthorDict];
    }
    
    NSRange range = [item.feeds_cover rangeOfString:@"|"];
    item.feedsCoverURLstring = [item.feeds_cover substringToIndex:range.location];
    
    
    // 影视属性
    item.movieTitle = item.title;
    
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

- (void)setMovieStroyDateWithDetailDict:(NSDictionary *)dict {
    self.contentTitle = dict[@"title"];
    self.title = dict[@"title"];
    self.content = dict[@"content"];
    self.summary = dict[@"summary"];
    self.movieContentAuthor = [ONEUserItem userItemWithDict:dict[@"user"]];
    
}

@end
