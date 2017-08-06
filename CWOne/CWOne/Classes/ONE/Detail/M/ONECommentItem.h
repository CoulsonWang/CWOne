//
//  ONECommentItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ONEUserItem;

@interface ONECommentItem : NSObject

@property (strong, nonatomic) NSString *commentID;

@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSString *praisenum;

@property (strong, nonatomic) NSString *input_date;

@property (strong, nonatomic) ONEUserItem *userItem;

@property (assign, nonatomic) BOOL isHot;

+ (instancetype)commentItemWithDict:(NSDictionary *)dict;

@end
