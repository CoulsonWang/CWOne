//
//  ONEAuthorItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEAuthorItem : NSObject

// 快速构造方法
+ (instancetype)authorItemWithDict:(NSDictionary *)dict;

// 原始属性

// 作者名称
@property (strong, nonatomic) NSString *user_name;

// 描述
@property (strong, nonatomic) NSString *desc;


@end
