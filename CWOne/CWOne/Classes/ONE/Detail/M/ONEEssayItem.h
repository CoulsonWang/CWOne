//
//  ONEEssayItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ONEUserItem;

@interface ONEEssayItem : NSObject

/* ********************************************* 普通详情页内容 ********************************************* */

/// 文章标题
@property (strong, nonatomic) NSString *title;

/// 正文
@property (strong, nonatomic) NSString *html_content;

/// 点赞数
@property (assign, nonatomic) NSInteger praisenum;

/// 评论数
@property (assign, nonatomic) NSInteger commentnum;

/// 另一个标题
@property (strong, nonatomic) NSString *tagTitle;

/* ********************************************* 音乐详情页内容 ********************************************* */

/// 故事标题
@property (strong, nonatomic) NSString *story_title;

/// 故事正文
@property (strong, nonatomic) NSString *story;

/// 歌词信息
@property (strong, nonatomic) NSString *lyric;

/// 歌曲信息
@property (strong, nonatomic) NSString *info;

@property (strong, nonatomic) NSString *feeds_cover;

@property (strong, nonatomic) NSString *feedsCoverURLstring;

@property (strong, nonatomic) NSString *cover;

@property (strong, nonatomic) NSString *music_id;

@property (strong, nonatomic) NSString *album;

@property (strong, nonatomic) ONEUserItem *author;

@property (strong, nonatomic) ONEUserItem *story_author;

/* ********************************************* 影视详情页内容 ********************************************* */

/// 故事正文
@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSString *movieTitle;

@property (strong, nonatomic) NSString *contentTitle;

@property (strong, nonatomic) NSString *summary;

@property (strong, nonatomic) ONEUserItem *movieContentAuthor;

@property (strong, nonatomic) NSString *detailcover;

@property (strong, nonatomic) NSString *officialstory;

@property (strong, nonatomic) NSString *charge_edt;

@property (strong, nonatomic) NSString *editor_email;

@property (strong, nonatomic) NSString *poster;

@property (strong, nonatomic) NSArray *photo;

+ (instancetype)essayItemWithDict:(NSDictionary *)dict;

// 加载电影数据
- (void)setMovieStroyDateWithDetailDict:(NSDictionary *)dict;

@end
