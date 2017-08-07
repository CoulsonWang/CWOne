//
//  ONEHomeItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ONEHomeItemTypeSmallNote,
    ONEHomeItemTypeEssay,
    ONEHomeItemTypeSerial,
    ONEHomeItemTypeQuestion,
    ONEHomeItemTypeMusic,
    ONEHomeItemTypeMovie,
    ONEHomeItemTypeRadio,
    ONEHomeItemTypeUnknown,
} ONEHomeItemType;

@class ONEUserItem;

@interface ONEHomeItem : NSObject

// 快速构造方法
+ (instancetype)homeItemWithDict:(NSDictionary *)dict;

/* *********************************** 原始属性 *********************************** */

@property (strong, nonatomic) NSString *item_id;

// item的类型
@property (strong, nonatomic) NSString *category;

// 显示的类别
@property (assign, nonatomic) NSInteger display_category;

// 标题
@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *subtitle;

// 预览文本
@property (strong, nonatomic) NSString *forward;

@property (strong, nonatomic) NSString *img_url;

@property (assign, nonatomic) NSInteger like_count;

@property (strong, nonatomic) NSString *post_date;

@property (strong, nonatomic) NSString *pic_info;

@property (strong, nonatomic) NSString *words_info;

@property (strong, nonatomic) NSString *share_url;

@property (strong, nonatomic) NSString *volume;

@property (strong, nonatomic) NSArray *default_audios;

@property (strong, nonatomic) NSString *audio_url;

@property (strong, nonatomic) NSString *orientation;

// 音乐cell的属性
@property (strong, nonatomic) NSString *music_name;

@property (strong, nonatomic) NSString *audio_author;

@property (strong, nonatomic) NSString *audio_album;

@property (strong, nonatomic) NSString *cover;

@property (assign, nonatomic) NSInteger audio_platform;

/* *********************************** 自定义属性 *********************************** */

@property (strong, nonatomic) ONEUserItem *authorItem;

@property (strong, nonatomic) ONEUserItem *answererItem;

@property (strong, nonatomic) NSString *tag_title;

@property (assign, nonatomic) ONEHomeItemType type;

@property (assign, nonatomic, getter=isLike) BOOL like;

@property (strong, nonatomic) NSString *typeName;

@end
