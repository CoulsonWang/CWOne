//
//  ONEEssayItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEEssayItem.h"
#import "ONEUserItem.h"
#import "UIColor+Hex.h"

@implementation ONEEssayItem

+ (instancetype)essayItemWithDict:(NSDictionary *)dict {
    ONEEssayItem *item = [[ONEEssayItem alloc] init];
    
    [item setValuesForKeysWithDictionary:dict];
    
    NSArray *tag_list = dict[@"tag_list"];
    NSDictionary *tag = tag_list.firstObject;
    item.tagTitle = tag[@"title"];
    
    item.item_id = dict[@"id"];
    
    NSArray<NSDictionary *> *authorList = dict[@"author_list"];
    item.author = [ONEUserItem userItemWithDict:authorList.firstObject];
    
    // 音乐属性
    NSDictionary *storyAuthorDict = dict[@"story_author"];
    if (storyAuthorDict) {
        item.author = [ONEUserItem userItemWithDict:storyAuthorDict];
    }
    NSRange range = [item.feeds_cover rangeOfString:@"|"];
    item.feedsCoverURLstring = [item.feeds_cover substringToIndex:range.location];
    
    
    // 影视属性
    item.movieTitle = item.title;
    
    // 专题属性
    item.backgroundColor = [UIColor colorWithHexString:item.bg_color];
    item.fontColor = [UIColor colorWithHexString:item.font_color];
    
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
    self.author = [ONEUserItem userItemWithDict:dict[@"user"]];
    self.praisenum = [dict[@"praisenum"] integerValue];
}

@end
