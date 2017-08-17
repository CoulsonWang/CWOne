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

@property (strong, nonatomic) NSString *quote;

@property (strong, nonatomic) NSString *content;

@property (assign, nonatomic) NSInteger praisenum;

@property (strong, nonatomic) NSString *input_date;

@property (strong, nonatomic) ONEUserItem *userItem;

@property (strong, nonatomic) ONEUserItem *touser;

@property (assign, nonatomic) BOOL isHot;

@property (assign, nonatomic, getter=isLastHotComment) BOOL lastHotComment;

+ (instancetype)commentItemWithDict:(NSDictionary *)dict;

@end
