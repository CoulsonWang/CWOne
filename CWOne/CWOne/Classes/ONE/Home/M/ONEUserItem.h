//
//  ONEAuthorItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEUserItem : NSObject

// 快速构造方法
+ (instancetype)userItemWithDict:(NSDictionary *)dict;

// 原始属性

// 用户名称
@property (strong, nonatomic) NSString *user_name;

// 描述
@property (strong, nonatomic) NSString *desc;

// 用户头像
@property (strong, nonatomic) NSString *web_url;

@property (strong, nonatomic) NSString *summary;


@end
