//
//  ONEEssayItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEEssayItem : NSObject

/// 文章标题
@property (strong, nonatomic) NSString *title;

/// 正文
@property (strong, nonatomic) NSString *html_content;

/// 点赞数
@property (strong, nonatomic) NSString *praisenum;

/// 评论数
@property (strong, nonatomic) NSString *commentnum;

/// 另一个标题
@property (strong, nonatomic) NSString *tagTitle;

+ (instancetype)essayItemWithDict:(NSDictionary *)dict;

@end
